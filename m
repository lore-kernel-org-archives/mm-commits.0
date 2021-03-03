Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FC7C432C3
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82F564E76
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346302AbhCDA7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388596AbhCDA1H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:27:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C621C6023B;
        Wed,  3 Mar 2021 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614812884;
        bh=bgrSqwcAG6GBPZdsZPvrCpfbKWFRVKuaLuPJEpIjzbw=;
        h=Date:From:To:Subject:From;
        b=fW2c+RwpgIv98V2CU0/KFmaD4MQdzSySwj1DqYd23GGSBYRarjQGLtf13uZjXNJ4T
         sgc3DJM6pcLKjxeMSsjSixprmA/ZiAcEIheECOSW7c6aLrLD4eWBAH0qdB59RLix+a
         GK2n1WXWmknaGPLIgDPz170yfSOIGFuk0T+sPhBk=
Date:   Wed, 03 Mar 2021 15:08:03 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  + mm-memcontrol-fix-kernel-stack-account.patch added to
 -mm tree
Message-ID: <20210303230803.DGDdtDcHg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix kernel stack account
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-kernel-stack-account.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-kernel-stack-account.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-kernel-stack-account.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix kernel stack account

For simplification 991e7673859e ("mm: memcontrol: account kernel stack per
node") has changed the per zone vmalloc backed stack pages accounting to
per node.  By doing that we have lost a certain precision because those
pages might live in different NUMA nodes.  In the end NR_KERNEL_STACK_KB
exported to the userspace might be over estimated on some nodes while
underestimated on others.  But this is not a real world problem, just a
problem found by reading the code.  So there is no actual data to showing
how much impact it has on users.

This doesn't impose any real problem to correctnes of the kernel behavior
as the counter is not used for any internal processing but it can cause
some confusion to the userspace.

Address the problem by accounting each vmalloc backing page to its own
node.

Link: https://lkml.kernel.org/r/20210303151843.81156-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~mm-memcontrol-fix-kernel-stack-account
+++ a/kernel/fork.c
@@ -379,14 +379,17 @@ static void account_kernel_stack(struct
 	void *stack = task_stack_page(tsk);
 	struct vm_struct *vm = task_stack_vm_area(tsk);
 
+	if (vm) {
+		int i;
 
-	/* All stack pages are in the same node. */
-	if (vm)
-		mod_lruvec_page_state(vm->pages[0], NR_KERNEL_STACK_KB,
-				      account * (THREAD_SIZE / 1024));
-	else
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_KERNEL_STACK_KB,
+					      account * (PAGE_SIZE / 1024));
+	} else {
+		/* All stack pages are in the same node. */
 		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
+	}
 }
 
 static int memcg_charge_kernel_stack(struct task_struct *tsk)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch


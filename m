Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A869C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB5E61477
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhD3F4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhD3F4u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B132761463;
        Fri, 30 Apr 2021 05:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762163;
        bh=tdcXJV9zIUfD2SQPv2gjZoxJeI0K0sNYJbJleKIc/+A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NoHBAEJ0k+8IhYud/5S0xMnc0jIZ+pR8i3+yM5csp9GlRINMsqE3u4d+/SXzA+iN8
         UlWR2dD/OMIvELWv/1KvqkTcJt4RSjkLg44D7rxQbT9cT3FeoEsXyNmnWmyDVHLW0c
         70nG7eAixHG9BuB0Wlv1wuywcXHY85nt0YYbZ9nw=
Date:   Thu, 29 Apr 2021 22:56:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 056/178] mm: memcontrol: fix kernel stack account
Message-ID: <20210430055602._TPiM7mzp%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -380,14 +380,17 @@ static void account_kernel_stack(struct
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

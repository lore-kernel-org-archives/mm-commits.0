Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F051C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 050156521A
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhCDBdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236099AbhCDBWU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:22:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB19F64FFF;
        Thu,  4 Mar 2021 01:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820898;
        bh=f/agl8CFX2JVPdOwFHmsbY6bhYo5UGPobtH/kMn1KfA=;
        h=Date:From:To:Subject:From;
        b=aJM5jmp64rWhgjdE/l6KVDy47JA8YKhWweEti0JDP7FPYwDHfKj3ZOYj26NjZAflt
         82XaNXmMBv6MlTqdye2sm16NMQaVvK3y5cEnKn4FDE60AdaWHwUUR0QKmRZV/l3WuU
         w+ewslJ8M/NMoEG43tGFVWDcjBdEVW1nIqQ8UBVQ=
Date:   Wed, 03 Mar 2021 17:21:38 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-use-rcu_dereference-in-in_vfork.patch added to -mm
 tree
Message-ID: <20210304012138.3baFrM7Fw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sched/mm.h: use rcu_dereference in in_vfork()
has been added to the -mm tree.  Its filename is
     mm-use-rcu_dereference-in-in_vfork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-rcu_dereference-in-in_vfork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-rcu_dereference-in-in_vfork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Fix a sparse warning by using rcu_dereference().  Technically this is a
bug and a sufficiently aggressive compiler could reload the `real_parent'
pointer outside the protection of the rcu lock (and access freed memory),
but I think it's pretty unlikely to happen.

Link: https://lkml.kernel.org/r/20210221194207.1351703-1-willy@infradead.org
Fixes: b18dc5f291c0 ("mm, oom: skip vforked tasks from being selected")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/mm.h~mm-use-rcu_dereference-in-in_vfork
+++ a/include/linux/sched/mm.h
@@ -140,7 +140,8 @@ static inline bool in_vfork(struct task_
 	 * another oom-unkillable task does this it should blame itself.
 	 */
 	rcu_read_lock();
-	ret = tsk->vfork_done && tsk->real_parent->mm == tsk->mm;
+	ret = tsk->vfork_done &&
+			rcu_dereference(tsk->real_parent)->mm == tsk->mm;
 	rcu_read_unlock();
 
 	return ret;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-use-rcu_dereference-in-in_vfork.patch
mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch


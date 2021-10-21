Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692D0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 02:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D70611CC
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 02:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJUCUp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 22:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhJUCUp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 22:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F058861183;
        Thu, 21 Oct 2021 02:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634782710;
        bh=02h78RSt0ixBzEslorJM0mmMhnYcxs01TfzDhdHVk08=;
        h=Date:From:To:Subject:From;
        b=kA9iDQcFW7vARV+VxwTcQgZrWisPYfZGRmBicz+fNUPD8GDAAgtKKl/3KXEZAy7yl
         V+vxsDtJQ87C6bX822/VOsnrYcYcdfluQPtLqTCO8tp5Q4XB9VUgQ3zAgh8K8wYy8N
         hUVX1kQ72eiOgR8B3NHv3HhCVOVb4+T57/6keLf4=
Date:   Wed, 20 Oct 2021 19:18:29 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, caoyixuan2019@email.szu.edu.cn,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-page=5Fownerc-modify-the-type-of-argument-order-in-some?=
 =?US-ASCII?Q?-functions-fix.patch?= added to -mm tree
Message-ID: <20211021021829.W3wtyHMCo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix
has been added to the -mm tree.  Its filename is
     mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix

update include/linux/page_owner.h

Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/page_owner.h~mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix
+++ a/include/linux/page_owner.h
@@ -8,9 +8,9 @@
 extern struct static_key_false page_owner_inited;
 extern struct page_ext_operations page_owner_ops;
 
-extern void __reset_page_owner(struct page *page, unsigned int order);
+extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask);
+			unsigned short order, gfp_t gfp_mask);
 extern void __split_page_owner(struct page *page, unsigned int nr);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
@@ -18,14 +18,14 @@ extern void __dump_page_owner(const stru
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
 
-static inline void reset_page_owner(struct page *page, unsigned int order)
+static inline void reset_page_owner(struct page *page, unsigned short order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__reset_page_owner(page, order);
 }
 
 static inline void set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask)
+			unsigned short order, gfp_t gfp_mask)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__set_page_owner(page, order, gfp_mask);
@@ -52,7 +52,7 @@ static inline void dump_page_owner(const
 		__dump_page_owner(page);
 }
 #else
-static inline void reset_page_owner(struct page *page, unsigned int order)
+static inline void reset_page_owner(struct page *page, unsigned short order)
 {
 }
 static inline void set_page_owner(struct page *page,
@@ -60,7 +60,7 @@ static inline void set_page_owner(struct
 {
 }
 static inline void split_page_owner(struct page *page,
-			unsigned int order)
+			unsigned short order)
 {
 }
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch


From: akpm@linux-foundation.org
Subject: + mm-fix-wrong-comments-about-anon_vma-lock.patch added to -mm tree
Date: Thu, 24 Jan 2013 15:52:17 -0800
Message-ID: <20130124235217.9ACB531C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:49064 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AXXwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 18:52:18 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so687418ggn.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 15:52:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, mel@csn.ul.ie, mingo@kernel.org


The patch titled
     Subject: mm: fix wrong comments about anon_vma lock
has been added to the -mm tree.  Its filename is
     mm-fix-wrong-comments-about-anon_vma-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: mm: fix wrong comments about anon_vma lock

We use rwsem since commit 5a50508. And most of comments are converted to
the new rwsem lock; while just 2 more missed from:
	 $ git grep 'anon_vma->mutex'

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    2 +-
 mm/mmap.c                    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-fix-wrong-comments-about-anon_vma-lock include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-fix-wrong-comments-about-anon_vma-lock
+++ a/include/linux/mmu_notifier.h
@@ -151,7 +151,7 @@ struct mmu_notifier_ops {
  * Therefore notifier chains can only be traversed when either
  *
  * 1. mmap_sem is held.
- * 2. One of the reverse map locks is held (i_mmap_mutex or anon_vma->mutex).
+ * 2. One of the reverse map locks is held (i_mmap_mutex or anon_vma->rwsem).
  * 3. No other concurrent thread can access the list (release)
  */
 struct mmu_notifier {
diff -puN mm/mmap.c~mm-fix-wrong-comments-about-anon_vma-lock mm/mmap.c
--- a/mm/mmap.c~mm-fix-wrong-comments-about-anon_vma-lock
+++ a/mm/mmap.c
@@ -2958,7 +2958,7 @@ static void vm_lock_mapping(struct mm_st
  * vma in this mm is backed by the same anon_vma or address_space.
  *
  * We can take all the locks in random order because the VM code
- * taking i_mmap_mutex or anon_vma->mutex outside the mmap_sem never
+ * taking i_mmap_mutex or anon_vma->rwsem outside the mmap_sem never
  * takes more than one of them in a row. Secondly we're protected
  * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
  *
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

mm-fix-wrong-comments-about-anon_vma-lock.patch
fs-execc-make-bprm_mm_init-static.patch


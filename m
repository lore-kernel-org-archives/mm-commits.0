From: akpm@linux-foundation.org
Subject: [merged] mm-fix-wrong-comments-about-anon_vma-lock.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:27 -0800
Message-ID: <20130205202027.B1E2E31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:56449 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3BEUU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:29 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so65579ves.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, mel@csn.ul.ie, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix wrong comments about anon_vma lock
has been removed from the -mm tree.  Its filename was
     mm-fix-wrong-comments-about-anon_vma-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: mm: fix wrong comments about anon_vma lock

We use rwsem since commit 5a50508. And most of comments are converted to
the new rwsem lock; while just 2 more missed from:
	 $ git grep 'anon_vma->mutex'

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
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
@@ -2943,7 +2943,7 @@ static void vm_lock_mapping(struct mm_st
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

origin.patch
linux-next.patch
nsproxy-remove-duplicate-task_cred_xxx-for-user_ns.patch
fs-execc-make-bprm_mm_init-static.patch
sysctl-put-get-get_uts-into-config_proc_sysctl-code-block.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch


From: akpm@linux-foundation.org
Subject: - memcg-fix-possible-panic-when-config_mm_owner=y.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:07 -0700
Message-ID: <200805132134.m4DLY7Lv000891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759165AbYEMVeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix possible panic when CONFIG_MM_OWNER=y
has been removed from the -mm tree.  Its filename was
     memcg-fix-possible-panic-when-config_mm_owner=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix possible panic when CONFIG_MM_OWNER=y
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When mm destruction happens, we should pass mm_update_next_owner() the old mm.
 But unfortunately new mm is passed in exec_mmap().

Thus, kernel panic is possible when a multi-threaded process uses exec().

Also, the owner member comment description is wrong.  mm->owner does not
necessarily point to the thread group leader.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "Paul Menage" <menage@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    2 +-
 include/linux/mm_types.h |   13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~memcg-fix-possible-panic-when-config_mm_owner=y fs/exec.c
--- a/fs/exec.c~memcg-fix-possible-panic-when-config_mm_owner=y
+++ a/fs/exec.c
@@ -736,7 +736,7 @@ static int exec_mmap(struct mm_struct *m
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	mm_update_next_owner(mm);
+	mm_update_next_owner(old_mm);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
diff -puN include/linux/mm_types.h~memcg-fix-possible-panic-when-config_mm_owner=y include/linux/mm_types.h
--- a/include/linux/mm_types.h~memcg-fix-possible-panic-when-config_mm_owner=y
+++ a/include/linux/mm_types.h
@@ -226,8 +226,17 @@ struct mm_struct {
 	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct kioctx		*ioctx_list;
 #ifdef CONFIG_MM_OWNER
-	struct task_struct *owner;	/* The thread group leader that */
-					/* owns the mm_struct.		*/
+	/*
+	 * "owner" points to a task that is regarded as the canonical
+	 * user/owner of this mm. All of the following must be true in
+	 * order for it to be changed:
+	 *
+	 * current == mm->owner
+	 * current->mm != mm
+	 * new_owner->mm == mm
+	 * new_owner->alloc_lock is held
+	 */
+	struct task_struct *owner;
 #endif
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch


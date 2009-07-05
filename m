From: akpm@linux-foundation.org
Subject: [merged] oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch removed from -mm tree
Date: Sun, 05 Jul 2009 11:36:00 -0700
Message-ID: <200907051836.n65Ia0wG004874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbZGESgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jul 2009 14:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/android/lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct"
has been removed from the -mm tree.  Its filename was
     oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/android/lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct"
From: David Rientjes <rientjes@google.com>

I'm about to merge "oom: move oom_adj value from task_struct to
mm_struct", and this fixup is needed to repair linux-next's
drivers/staging/android/lowmemorykiller.c.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -96,19 +96,21 @@ static int lowmem_shrink(int nr_to_scan,
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
+		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		if (!p->mm) {
+		mm = p->mm;
+		if (!mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = p->oomkilladj;
+		oom_adj = mm->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(p->mm);
+		tasksize = get_mm_rss(mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch


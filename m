From: akpm@linux-foundation.org
Subject: [wrecked] revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch removed from -mm tree
Date: Wed, 07 Oct 2009 15:11:33 -0700
Message-ID: <200910072211.n97MBXR7025238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbZJGWNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2009 18:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, geert@linux-m68k.org, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Revert "Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct""
has been removed from the -mm tree.  Its filename was
     revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Revert "Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct""
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 0753ba01 (mm: revert "oom: move oom_adj value") reverted some
regression patch. but it didn't revert one oom retrieved driver patch.

Then, it made build error to the driver. This reverts commit
a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b too and fixes the build error.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -99,21 +99,19 @@ static int lowmem_shrink(int nr_to_scan,
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		if (!p->mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = mm->oom_adj;
+		oom_adj = p->oomkilladj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(mm);
+		tasksize = get_mm_rss(p->mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


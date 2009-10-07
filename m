From: akpm@linux-foundation.org
Subject: [wrecked] oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch removed from -mm tree
Date: Wed, 07 Oct 2009 15:11:40 -0700
Message-ID: <200910072211.n97MBeok025482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZJGWMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2009 18:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     lowmemorykiller: fix build error to move oom_adj
has been removed from the -mm tree.  Its filename was
     oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lowmemorykiller: fix build error to move oom_adj
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Recently, oom_adj moved from task_struct to signal_struct. Then, the oom_adj
treating code in android driver also should be changed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -106,7 +106,7 @@ static int lowmem_shrink(int nr_to_scan,
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = p->oomkilladj;
+		oom_adj = p->signal->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


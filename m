From: akpm@linux-foundation.org
Subject: - reiser4-fix-handling-enospc-cryptcompress.patch removed from -mm tree
Date: Tue, 30 Dec 2008 15:10:36 -0800
Message-ID: <200812302310.mBUNAapZ019455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYL3XLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:11:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix handling ENOSPC cryptcompress
has been removed from the -mm tree.  Its filename was
     reiser4-fix-handling-enospc-cryptcompress.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fix handling ENOSPC cryptcompress
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
Processes fall into infinite loop
when running in no-space-left-on-device situation.

Fixup:
Fixed leak of checkin_mutex in do_write_cryptcompress();


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-handling-enospc-cryptcompress fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-handling-enospc-cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2707,7 +2707,8 @@ static loff_t do_write_cryptcompress(str
 		if (result)
 			goto out;
 		if (cont->state == PSCHED_ASSIGNED_NEW)
-			goto out_no_release;
+			/* done_lh was called in write_pschedule_hook */
+			goto out_no_longterm_lock;
 
 		result = prepare_logical_cluster(inode, pos, count, &clust,
 						 LC_APPOV);
@@ -2779,9 +2780,9 @@ static loff_t do_write_cryptcompress(str
 	} while (count);
  out:
 	done_lh(&hint->lh);
-	mutex_unlock(&info->checkin_mutex);
 	save_file_hint(file, hint);
- out_no_release:
+ out_no_longterm_lock:
+	mutex_unlock(&info->checkin_mutex);
 	kfree(hint);
 	put_cluster_handle(&clust);
 	assert("edward-195",
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-fix-handling-enospc-cryptcompress.patch
reiser4-fix-handling-enospc-unix_file.patch
reiser4-fix-kill_hook_internal.patch
reiser4-semaphore-fix.patch
reiser4-compile-warning-cleanups.patch
reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch
reiser4-track-upstream-changes.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch


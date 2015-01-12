From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch removed from
 -mm tree
Date: Mon, 12 Jan 2015 11:33:08 -0800
Message-ID: <54b42174.BFjo2gPQk06eoFKm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbbALTdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 14:33:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove bogus check in dlm_process_recovery_data
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove bogus check in dlm_process_recovery_data

In dlm_process_recovery_data, only when dlm_new_lock failed the ret will
be set to -ENOMEM.  And in this case, newlock is definitely NULL.  So test
newlock is meaningless, remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-remove-bogus-check-in-dlm_process_recovery_data fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-remove-bogus-check-in-dlm_process_recovery_data
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2023,11 +2023,8 @@ leave:
 	dlm_lockres_drop_inflight_ref(dlm, res);
 	spin_unlock(&res->spinlock);
 
-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		if (newlock)
-			dlm_lock_put(newlock);
-	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch


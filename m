From: akpm@linux-foundation.org
Subject: + ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch
 added to -mm tree
Date: Wed, 17 Dec 2014 13:07:49 -0800
Message-ID: <5491f0a5.1FRylU/kr5KFiJZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQVHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove bogus check in dlm_process_recovery_data
has been added to the -mm tree.  Its filename is
     ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove bogus check in dlm_process_recovery_data

In dlm_process_recovery_data, only when dlm_new_lock failed the ret will
be set to -ENOMEM.  And in this case, newlock is definitely NULL.  So test
newlock is meaningless, remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
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

origin.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch
ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch


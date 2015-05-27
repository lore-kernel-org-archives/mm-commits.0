From: akpm@linux-foundation.org
Subject: + ocfs2-fix-race-between-crashed-dio-and-rm.patch added to -mm
 tree
Date: Wed, 27 May 2015 14:08:14 -0700
Message-ID: <5566323e.KYKmSjQaquSMICqe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbE0VIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix race between crashed dio and rm
has been added to the -mm tree.  Its filename is
     ocfs2-fix-race-between-crashed-dio-and-rm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-race-between-crashed-dio-and-rm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-race-between-crashed-dio-and-rm.patch

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
Subject: ocfs2: fix race between crashed dio and rm

There is a race case between crashed dio and rm, which will lead to
OCFS2_VALID_FL not set read-only.

N1                              N2
------------------------------------------------------------------------
dd with direct flag
                                rm file
crashed with an dio entry left
in orphan dir
                                clear OCFS2_VALID_FL in
                                ocfs2_remove_inode
                                recover N1 and read the corrupted inode,
                                and set filesystem read-only

So we skip the inode deletion this time and wait for dio entry
recovered first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c   |    9 +++++++++
 fs/ocfs2/journal.c |    4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/inode.c~ocfs2-fix-race-between-crashed-dio-and-rm fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-fix-race-between-crashed-dio-and-rm
+++ a/fs/ocfs2/inode.c
@@ -971,6 +971,7 @@ static void ocfs2_delete_inode(struct in
 	int wipe, status;
 	sigset_t oldset;
 	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
 
 	trace_ocfs2_delete_inode(inode->i_ino,
 				 (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1025,6 +1026,14 @@ static void ocfs2_delete_inode(struct in
 		goto bail_unlock_nfs_sync;
 	}
 
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	/* Skip inode deletion and wait for dio orphan entry recovered
+	 * first */
+	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ocfs2_cleanup_delete_inode(inode, 0);
+		goto bail_unlock_inode;
+	}
+
 	/* Query the cluster. This will be the final decision made
 	 * before we go ahead and wipe the inode. */
 	status = ocfs2_query_inode_wipe(inode, di_bh, &wipe);
diff -puN fs/ocfs2/journal.c~ocfs2-fix-race-between-crashed-dio-and-rm fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-race-between-crashed-dio-and-rm
+++ a/fs/ocfs2/journal.c
@@ -2193,7 +2193,9 @@ static int ocfs2_recover_orphans(struct
 			 * ocfs2_delete_inode. */
 			oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
 			spin_unlock(&oi->ip_lock);
-		} else if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
+		}
+
+		if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
 				(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
 			ret = ocfs2_truncate_file(inode, di_bh,
 					i_size_read(inode));
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch
ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch


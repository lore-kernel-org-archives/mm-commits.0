From: akpm@linux-foundation.org
Subject: +
 ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch added to -mm tree
Date: Thu, 17 Apr 2014 13:18:46 -0700
Message-ID: <53503726.zBEOyu+x0dtlVQJN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaDQUSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, alex.chen@huawei.com

Subject: + ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch added to -mm tree
To: alex.chen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:18:46 -0700


The patch titled
     Subject: ocfs2: should add inode into orphan dir after updating entry in ocfs2_rename()
has been added to the -mm tree.  Its filename is
     ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: should add inode into orphan dir after updating entry in ocfs2_rename()

There are two files a and b in dir /mnt/ocfs2.
    node A                           node B
mv a b
In ocfs2_rename(), after calling
ocfs2_orphan_add(), the inode of
file b will be added into orphan
dir.

If ocfs2_update_entry() fails,
ocfs2_rename return error and mv
operation fails. But file b still
exists in the parent dir.

ocfs2_queue_orphan_scan
-> ocfs2_queue_recovery_completion
-> ocfs2_complete_recovery
-> ocfs2_recover_orphans
The inode of the file b will be
put with iput().

ocfs2_evict_inode
-> ocfs2_delete_inode
-> ocfs2_wipe_inode
-> ocfs2_remove_inode
OCFS2_VALID_FL in the inode
i_flags will be cleared.

                                   The file b still can be accessed
                                   on node B.
                                   ls /mnt/ocfs2
                                   When first read the file b with
                                   ocfs2_read_inode_block(). It will
                                   validate the inode using
                                   ocfs2_validate_inode_block().
                                   Because OCFS2_VALID_FL not set in
                                   the inode i_flags, so the file
                                   system will be readonly.

So we should add inode into orphan dir after updating entry in
ocfs2_rename().

Signed-off-by: alex.chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename
+++ a/fs/ocfs2/namei.c
@@ -1098,6 +1098,7 @@ static int ocfs2_rename(struct inode *ol
 	struct ocfs2_dir_lookup_result old_entry_lookup = { NULL, };
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
+	bool should_add_orphan = false;
 
 	/* At some point it might be nice to break this function up a
 	 * bit. */
@@ -1304,6 +1305,7 @@ static int ocfs2_rename(struct inode *ol
 				mlog_errno(status);
 				goto bail;
 			}
+			should_add_orphan = true;
 		}
 	} else {
 		BUG_ON(new_dentry->d_parent->d_inode != new_dir);
@@ -1348,17 +1350,6 @@ static int ocfs2_rename(struct inode *ol
 			goto bail;
 		}
 
-		if (S_ISDIR(new_inode->i_mode) ||
-		    (ocfs2_read_links_count(newfe) == 1)) {
-			status = ocfs2_orphan_add(osb, handle, new_inode,
-						  newfe_bh, orphan_name,
-						  &orphan_insert, orphan_dir);
-			if (status < 0) {
-				mlog_errno(status);
-				goto bail;
-			}
-		}
-
 		/* change the dirent to point to the correct inode */
 		status = ocfs2_update_entry(new_dir, handle, &target_lookup_res,
 					    old_inode);
@@ -1373,6 +1364,15 @@ static int ocfs2_rename(struct inode *ol
 		else
 			ocfs2_add_links_count(newfe, -1);
 		ocfs2_journal_dirty(handle, newfe_bh);
+		if (should_add_orphan) {
+			status = ocfs2_orphan_add(osb, handle, new_inode,
+					newfe_bh, orphan_name,
+					&orphan_insert, orphan_dir);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+		}
 	} else {
 		/* if the name was not found in new_dir, add it now */
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch


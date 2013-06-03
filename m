From: akpm@linux-foundation.org
Subject: [merged]
 reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch removed from
 -mm tree
Date: Mon, 03 Jun 2013 13:30:03 -0700
Message-ID: <51acfccb.t+XdQWC/Skz5txBN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCUaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 16:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jslaby@suse.cz, jack@suse.cz, jeffm@suse.com

Subject: [merged] reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch removed from -mm tree
To: jeffm@suse.com,jack@suse.cz,jslaby@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 13:30:03 -0700


The patch titled
     Subject: reiserfs: fix deadlock with nfs racing on create/lookup
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Mahoney <jeffm@suse.com>
Subject: reiserfs: fix deadlock with nfs racing on create/lookup

Reiserfs is currently able to be deadlocked by having two NFS clients
where one has removed and recreated a file and another is accessing the
file with an open file handle.

If one client deletes and recreates a file with timing such that the
recreated file obtains the same [dirid, objectid] pair as the original
file while another client accesses the file via file handle, the create
and lookup can race and deadlock if the lookup manages to create the
in-memory inode first.

The create thread, in insert_inode_locked4, will hold the write lock while
waiting on the other inode to be unlocked.  The lookup thread, anywhere in
the iget path, will release and reacquire the write lock while it
schedules.  If it needs to reacquire the lock while the create thread has
it, it will never be able to make forward progress because it needs to
reacquire the lock before ultimately unlocking the inode.

This patch drops the write lock across the insert_inode_locked4 call so
that the ordering of inode_wait -> write lock is retained.  Since this
would have been the case before the BKL push-down, this is safe.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup
+++ a/fs/reiserfs/inode.c
@@ -1811,11 +1811,16 @@ int reiserfs_new_inode(struct reiserfs_t
 				  TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
 	memcpy(INODE_PKEY(inode), &(ih.ih_key), KEY_SIZE);
 	args.dirid = le32_to_cpu(ih.ih_key.k_dir_id);
-	if (insert_inode_locked4(inode, args.objectid,
-			     reiserfs_find_actor, &args) < 0) {
+
+	reiserfs_write_unlock(inode->i_sb);
+	err = insert_inode_locked4(inode, args.objectid,
+			     reiserfs_find_actor, &args);
+	reiserfs_write_lock(inode->i_sb);
+	if (err) {
 		err = -EINVAL;
 		goto out_bad_inode;
 	}
+
 	if (old_format_only(sb))
 		/* not a perfect generation count, as object ids can be reused, but
 		 ** this is as good as reiserfs can do right now.
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch
drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch
misdn-add-support-for-group-membership-check.patch


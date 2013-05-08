From: akpm@linux-foundation.org
Subject: + reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch added to -mm tree
Date: Wed, 08 May 2013 13:35:34 -0700
Message-ID: <20130508203534.7BE575A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:40861 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3EHUff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:35:35 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so221293vbg.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:35:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, jack@suse.cz, jslaby@suse.cz


The patch titled
     Subject: reiserfs: fix deadlock with nfs racing on create/lookup
has been added to the -mm tree.  Its filename is
     reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hfs-avoid-crash-in-hfs_bnode_create.patch
reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch


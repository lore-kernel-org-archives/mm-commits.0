From: akpm@linux-foundation.org
Subject: - ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:09 -0800
Message-ID: <200702112254.l1BMs9rE016173@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbXBKWyR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, sct@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ext4: refuse ro to rw remount of fs with orphan inodes
has been removed from the -mm tree.  Its filename was
     ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: refuse ro to rw remount of fs with orphan inodes
From: Eric Sandeen <sandeen@redhat.com>

In the rare case where we have skipped orphan inode processing due to a
readonly block device, and the block device subsequently changes back to
read-write, disallow a remount,rw transition of the filesystem when we have an
unprocessed orphan inodes as this would corrupt the list.

Ideally we should process the orphan inode list during the remount, but that's
trickier, and this plugs the hole for now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: "Stephen C. Tweedie" <sct@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN fs/ext4/super.c~ext4-refuse-ro-to-rw-remount-of-fs-with-orphan fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-refuse-ro-to-rw-remount-of-fs-with-orphan
+++ a/fs/ext4/super.c
@@ -2419,6 +2419,22 @@ static int ext4_remount (struct super_bl
 				err = -EROFS;
 				goto restore_opts;
 			}
+
+			/*
+			 * If we have an unprocessed orphan list hanging
+			 * around from a previously readonly bdev mount,
+			 * require a full umount/remount for now.
+			 */
+			if (es->s_last_orphan) {
+				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
+				       "remount RDWR because of unprocessed "
+				       "orphan inode list.  Please "
+				       "umount/remount instead.\n",
+				       sb->s_id);
+				err = -EINVAL;
+				goto restore_opts;
+			}
+
 			/*
 			 * Mounting a RDONLY partition read-write, so reread
 			 * and store the current valid flag.  (It may have
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch

From: akpm@osdl.org
Subject: + ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch added to -mm tree
Date: Thu, 11 Jan 2007 14:22:13 -0800
Message-ID: <200701112222.l0BMMDZw004892@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39201 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651AbXAKWWX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 17:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, sct@redhat.com


The patch titled
     ext4: refuse ro to rw remount of fs with orphan inodes
has been added to the -mm tree.  Its filename is
     ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/super.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

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

ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch
ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch

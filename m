From: akpm@osdl.org
Subject: + ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch added to -mm tree
Date: Thu, 11 Jan 2007 14:05:18 -0800
Message-ID: <200701112205.l0BM5IY8004389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38285 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXAKWFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 17:05:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, sct@redhat.com


The patch titled
     ext3: refuse ro to rw remount of fs with orphan inodes
has been added to the -mm tree.  Its filename is
     ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: refuse ro to rw remount of fs with orphan inodes
From: Eric Sandeen <sandeen@redhat.com>

needs a changelog

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: "Stephen C. Tweedie" <sct@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/super.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

diff -puN fs/ext3/super.c~ext3-refuse-ro-to-rw-remount-of-fs-with-orphan fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-refuse-ro-to-rw-remount-of-fs-with-orphan
+++ a/fs/ext3/super.c
@@ -2344,6 +2344,22 @@ static int ext3_remount (struct super_bl
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
+				printk(KERN_WARNING "EXT3-fs: %s: couldn't "
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

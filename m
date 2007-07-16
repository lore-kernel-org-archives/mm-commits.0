From: akpm@linux-foundation.org
Subject: - update-description-in-documentation-filesystems-vfstxt-typo-fixed.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:39 -0700
Message-ID: <200707162057.l6GKvdt7002212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757415AbXGPVJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     update description in Documentation/filesystems/vfs.txt
has been removed from the -mm tree.  Its filename was
     update-description-in-documentation-filesystems-vfstxt-typo-fixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update description in Documentation/filesystems/vfs.txt
From: Borislav Petkov <bbpetkov@yahoo.de>

Update the description of struct file_system_type and get_sb() in
Documentation/filesystems/vfs.txt to match the current code.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~update-description-in-documentation-filesystems-vfstxt-typo-fixed Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~update-description-in-documentation-filesystems-vfstxt-typo-fixed
+++ a/Documentation/filesystems/vfs.txt
@@ -3,7 +3,7 @@
 
 	Original author: Richard Gooch <rgooch@atnf.csiro.au>
 
-		  Last updated on October 28, 2005
+		  Last updated on June 24, 2007.
 
   Copyright (C) 1999 Richard Gooch
   Copyright (C) 2005 Pekka Enberg
@@ -107,7 +107,7 @@ file /proc/filesystems.
 struct file_system_type
 -----------------------
 
-This describes the filesystem. As of kernel 2.6.13, the following
+This describes the filesystem. As of kernel 2.6.22, the following
 members are defined:
 
 struct file_system_type {
@@ -119,6 +119,8 @@ struct file_system_type {
         struct module *owner;
         struct file_system_type * next;
         struct list_head fs_supers;
+	struct lock_class_key s_lock_key;
+	struct lock_class_key s_umount_key;
 };
 
   name: the name of the filesystem type, such as "ext2", "iso9660",
@@ -137,11 +139,12 @@ struct file_system_type {
 
   next: for internal VFS use: you should initialize this to NULL
 
+  s_lock_key, s_umount_key: lockdep-specific
+
 The get_sb() method has the following arguments:
 
-  struct super_block *sb: the superblock structure. This is partially
-	initialized by the VFS and the rest must be initialized by the
-	get_sb() method
+  struct file_system_type *fs_type: decribes the filesystem, partly initialized
+  	by the specific filesystem code
 
   int flags: mount flags
 
@@ -150,12 +153,13 @@ The get_sb() method has the following ar
   void *data: arbitrary mount options, usually comes as an ASCII
 	string
 
-  int silent: whether or not to be silent on error
+  struct vfsmount *mnt: a vfs-internal representation of a mount point
 
 The get_sb() method must determine if the block device specified
-in the superblock contains a filesystem of the type the method
-supports. On success the method returns the superblock pointer, on
-failure it returns NULL.
+in the dev_name and fs_type contains a filesystem of the type the method
+supports. If it succeeds in opening the named block device, it initializes a
+struct super_block descriptor for the filesystem contained by the block device.
+On failure it returns an error.
 
 The most interesting member of the superblock structure that the
 get_sb() method fills in is the "s_op" field. This is a pointer to
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch

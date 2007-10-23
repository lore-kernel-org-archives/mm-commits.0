From: akpm@linux-foundation.org
Subject: + fs-menu-small-reorg.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:32:27 -0700
Message-ID: <200710231932.l9NJWRqK002896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbXJWTc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     fs menu: small reorg
has been added to the -mm tree.  Its filename is
     fs-menu-small-reorg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs menu: small reorg
From: Randy Dunlap <randy.dunlap@oracle.com>

- move minixfs and ROMfs to the Miscellaneous filesystems menu
- move DNOTIFY config symbol so that it is adjacent to INOTIFY
  instead of being split by the QUOTA config options
- add some 'endif' annotations
- remove some whitespace (extra blank lines)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   93 +++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff -puN fs/Kconfig~fs-menu-small-reorg fs/Kconfig
--- a/fs/Kconfig~fs-menu-small-reorg
+++ a/fs/Kconfig
@@ -460,40 +460,18 @@ config OCFS2_DEBUG_MASKLOG
 	  This option will enlarge your kernel, but it allows debugging of
 	  ocfs2 filesystem issues.
 
-config MINIX_FS
-	tristate "Minix fs support"
-	help
-	  Minix is a simple operating system used in many classes about OS's.
-	  The minix file system (method to organize files on a hard disk
-	  partition or a floppy disk) was the original file system for Linux,
-	  but has been superseded by the second extended file system ext2fs.
-	  You don't want to use the minix file system on your hard disk
-	  because of certain built-in restrictions, but it is sometimes found
-	  on older Linux floppy disks.  This option will enlarge your kernel
-	  by about 28 KB. If unsure, say N.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called minix.  Note that the file system of your root
-	  partition (the one containing the directory /) cannot be compiled as
-	  a module.
-
-config ROMFS_FS
-	tristate "ROM file system support"
-	---help---
-	  This is a very small read-only file system mainly intended for
-	  initial ram disks of installation disks, but it could be used for
-	  other read-only media as well.  Read
-	  <file:Documentation/filesystems/romfs.txt> for details.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called romfs.  Note that the file system of your
-	  root partition (the one containing the directory /) cannot be a
-	  module.
+endif # BLOCK
 
-	  If you don't know whether you need it, then you don't need it:
-	  answer N.
+config DNOTIFY
+	bool "Dnotify support"
+	default y
+	help
+	  Dnotify is a directory-based per-fd file change notification system
+	  that uses signals to communicate events to user-space.  There exist
+	  superior alternatives, but some applications may still rely on
+	  dnotify.
 
-endif
+	  If unsure, say Y.
 
 config INOTIFY
 	bool "Inotify file change notification support"
@@ -574,17 +552,6 @@ config QUOTACTL
 	depends on XFS_QUOTA || QUOTA
 	default y
 
-config DNOTIFY
-	bool "Dnotify support"
-	default y
-	help
-	  Dnotify is a directory-based per-fd file change notification system
-	  that uses signals to communicate events to user-space.  There exist
-	  superior alternatives, but some applications may still rely on
-	  dnotify.
-
-	  If unsure, say Y.
-
 config AUTOFS_FS
 	tristate "Kernel automounter support"
 	help
@@ -710,7 +677,7 @@ config UDF_NLS
 	depends on (UDF_FS=m && NLS) || (UDF_FS=y && NLS=y)
 
 endmenu
-endif
+endif # BLOCK
 
 if BLOCK
 menu "DOS/FAT/NT Filesystems"
@@ -893,7 +860,7 @@ config NTFS_RW
 	  It is perfectly safe to say N here.
 
 endmenu
-endif
+endif # BLOCK
 
 menu "Pseudo filesystems"
 
@@ -1443,6 +1410,24 @@ config VXFS_FS
 	  To compile this as a module, choose M here: the module will be
 	  called freevxfs.  If unsure, say N.
 
+config MINIX_FS
+	tristate "Minix file system support"
+	depends on BLOCK
+	help
+	  Minix is a simple operating system used in many classes about OS's.
+	  The minix file system (method to organize files on a hard disk
+	  partition or a floppy disk) was the original file system for Linux,
+	  but has been superseded by the second extended file system ext2fs.
+	  You don't want to use the minix file system on your hard disk
+	  because of certain built-in restrictions, but it is sometimes found
+	  on older Linux floppy disks.  This option will enlarge your kernel
+	  by about 28 KB. If unsure, say N.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called minix.  Note that the file system of your root
+	  partition (the one containing the directory /) cannot be compiled as
+	  a module.
+
 
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
@@ -1460,7 +1445,6 @@ config HPFS_FS
 	  module will be called hpfs.  If unsure, say N.
 
 
-
 config QNX4FS_FS
 	tristate "QNX4 file system support (read only)"
 	depends on BLOCK
@@ -1487,6 +1471,22 @@ config QNX4FS_RW
 	  It's currently broken, so for now:
 	  answer N.
 
+config ROMFS_FS
+	tristate "ROM file system support"
+	depends on BLOCK
+	---help---
+	  This is a very small read-only file system mainly intended for
+	  initial ram disks of installation disks, but it could be used for
+	  other read-only media as well.  Read
+	  <file:Documentation/filesystems/romfs.txt> for details.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called romfs.  Note that the file system of your
+	  root partition (the one containing the directory /) cannot be a
+	  module.
+
+	  If you don't know whether you need it, then you don't need it:
+	  answer N.
 
 
 config SYSV_FS
@@ -1527,7 +1527,6 @@ config SYSV_FS
 	  If you haven't heard about all of this before, it's safe to say N.
 
 
-
 config UFS_FS
 	tristate "UFS file system support (read only)"
 	depends on BLOCK
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-mtd.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch

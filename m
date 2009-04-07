From: akpm@linux-foundation.org
Subject: [merged] nilfs2-update-makefile-and-kconfig.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:07 -0700
Message-ID: <200904071909.n37J97df012123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZDGTYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: update makefile and Kconfig
has been removed from the -mm tree.  Its filename was
     nilfs2-update-makefile-and-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: update makefile and Kconfig
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds a Makefile for the nilfs2 file system, and updates the
makefile and Kconfig file in the file system directory.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig         |   27 ++++++++++++++++++++++++++-
 fs/Makefile        |    1 +
 fs/nilfs2/Makefile |    5 +++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff -puN fs/Kconfig~nilfs2-update-makefile-and-kconfig fs/Kconfig
--- a/fs/Kconfig~nilfs2-update-makefile-and-kconfig
+++ a/fs/Kconfig
@@ -175,9 +175,34 @@ source "fs/qnx4/Kconfig"
 source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
-
 source "fs/exofs/Kconfig"
 
+config NILFS2_FS
+	tristate "NILFS2 file system support (EXPERIMENTAL)"
+	depends on BLOCK && EXPERIMENTAL
+	select CRC32
+	help
+	  NILFS2 is a log-structured file system (LFS) supporting continuous
+	  snapshotting.  In addition to versioning capability of the entire
+	  file system, users can even restore files mistakenly overwritten or
+	  destroyed just a few seconds ago.  Since this file system can keep
+	  consistency like conventional LFS, it achieves quick recovery after
+	  system crashes.
+
+	  NILFS2 creates a number of checkpoints every few seconds or per
+	  synchronous write basis (unless there is no change).  Users can
+	  select significant versions among continuously created checkpoints,
+	  and can change them into snapshots which will be preserved for long
+	  periods until they are changed back to checkpoints.  Each
+	  snapshot is mountable as a read-only file system concurrently with
+	  its writable mount, and this feature is convenient for online backup.
+
+	  Some features including atime, extended attributes, and POSIX ACLs,
+	  are not supported yet.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called nilfs2.  If unsure, say N.
+
 endif # MISC_FILESYSTEMS
 
 menuconfig NETWORK_FILESYSTEMS
diff -puN fs/Makefile~nilfs2-update-makefile-and-kconfig fs/Makefile
--- a/fs/Makefile~nilfs2-update-makefile-and-kconfig
+++ a/fs/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_JFS_FS)		+= jfs/
 obj-$(CONFIG_XFS_FS)		+= xfs/
 obj-$(CONFIG_9P_FS)		+= 9p/
 obj-$(CONFIG_AFS_FS)		+= afs/
+obj-$(CONFIG_NILFS2_FS)		+= nilfs2/
 obj-$(CONFIG_BEFS_FS)		+= befs/
 obj-$(CONFIG_HOSTFS)		+= hostfs/
 obj-$(CONFIG_HPPFS)		+= hppfs/
diff -puN /dev/null fs/nilfs2/Makefile
--- /dev/null
+++ a/fs/nilfs2/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_NILFS2_FS) += nilfs2.o
+nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
+	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
+	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
+	ifile.o alloc.o gcinode.o ioctl.o gcdat.o
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch


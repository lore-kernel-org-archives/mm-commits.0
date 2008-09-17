From: akpm@linux-foundation.org
Subject: + nilfs2-update-makefile-and-kconfig.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:28:33 -0700
Message-ID: <200809172028.m8HKSXcK029042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbYIQU2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: update makefile and Kconfig
has been added to the -mm tree.  Its filename is
     nilfs2-update-makefile-and-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: update makefile and Kconfig
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds a Makefile for the nilfs2 file system, and updates the
makefile and Kconfig file in the file system directory.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig         |   26 ++++++++++++++++++++++++++
 fs/Makefile        |    1 +
 fs/nilfs2/Makefile |    5 +++++
 3 files changed, 32 insertions(+)

diff -puN fs/Kconfig~nilfs2-update-makefile-and-kconfig fs/Kconfig
--- a/fs/Kconfig~nilfs2-update-makefile-and-kconfig
+++ a/fs/Kconfig
@@ -1162,6 +1162,32 @@ config MINIX_FS
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
 
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
 config OMFS_FS
 	tristate "SonicBlue Optimized MPEG File System support"
 	depends on BLOCK
diff -puN fs/Makefile~nilfs2-update-makefile-and-kconfig fs/Makefile
--- a/fs/Makefile~nilfs2-update-makefile-and-kconfig
+++ a/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_NILFS2_FS)		+= nilfs2/
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

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch


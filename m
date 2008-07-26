From: akpm@linux-foundation.org
Subject: - omfs-update-kbuild-to-include-omfs.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:31 -0700
Message-ID: <200807262115.m6QLFVcq019745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672AbYGZVP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     omfs: update kbuild to include OMFS
has been removed from the -mm tree.  Its filename was
     omfs-update-kbuild-to-include-omfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omfs: update kbuild to include OMFS
From: Bob Copeland <me@bobcopeland.com>

Adds OMFS to the fs Kconfig and Makefile

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig       |   13 +++++++++++++
 fs/Makefile      |    1 +
 fs/omfs/Makefile |    4 ++++
 3 files changed, 18 insertions(+)

diff -puN fs/Kconfig~omfs-update-kbuild-to-include-omfs fs/Kconfig
--- a/fs/Kconfig~omfs-update-kbuild-to-include-omfs
+++ a/fs/Kconfig
@@ -1383,6 +1383,19 @@ config MINIX_FS
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
 
+config OMFS_FS
+	tristate "SonicBlue Optimized MPEG File System support"
+	depends on BLOCK
+	select CRC_ITU_T
+	help
+	  This is the proprietary file system used by the Rio Karma music
+	  player and ReplayTV DVR.  Despite the name, this filesystem is not
+	  more efficient than a standard FS for MPEG files, in fact likely
+	  the opposite is true.  Say Y if you have either of these devices
+	  and wish to mount its disk.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called omfs.  If unsure, say N.
 
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
diff -puN fs/Makefile~omfs-update-kbuild-to-include-omfs fs/Makefile
--- a/fs/Makefile~omfs-update-kbuild-to-include-omfs
+++ a/fs/Makefile
@@ -111,6 +111,7 @@ obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
 obj-$(CONFIG_UDF_FS)		+= udf/
 obj-$(CONFIG_SUN_OPENPROMFS)	+= openpromfs/
+obj-$(CONFIG_OMFS_FS)		+= omfs/
 obj-$(CONFIG_JFS_FS)		+= jfs/
 obj-$(CONFIG_XFS_FS)		+= xfs/
 obj-$(CONFIG_9P_FS)		+= 9p/
diff -puN /dev/null fs/omfs/Makefile
--- /dev/null
+++ a/fs/omfs/Makefile
@@ -0,0 +1,4 @@
+
+obj-$(CONFIG_OMFS_FS) += omfs.o
+
+omfs-y := bitmap.o dir.o file.o inode.o
_

Patches currently in -mm which might be from me@bobcopeland.com are

origin.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch


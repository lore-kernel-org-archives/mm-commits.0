From: akpm@linux-foundation.org
Subject: + omfs-update-kbuild-to-include-omfs.patch added to -mm tree
Date: Tue, 06 May 2008 13:07:58 -0700
Message-ID: <200805062007.m46K7w4N024922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763507AbYEFUI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:08:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: me@bobcopeland.com


The patch titled
     omfs: update kbuild to include OMFS
has been added to the -mm tree.  Its filename is
     omfs-update-kbuild-to-include-omfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1477,6 +1477,19 @@ config MINIX_FS
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
@@ -102,6 +102,7 @@ obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
 obj-$(CONFIG_LOGFS)		+= logfs/
+obj-$(CONFIG_OMFS_FS)		+= omfs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
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

omfs-add-filesystem-documentation.patch
omfs-define-filesystem-structures.patch
omfs-add-inode-routines.patch
omfs-add-directory-routines.patch
omfs-add-file-routines.patch
omfs-add-bitmap-routines.patch
omfs-update-kbuild-to-include-omfs.patch
omfs-add-maintainers-entry.patch


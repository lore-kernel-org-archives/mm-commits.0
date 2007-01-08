From: akpm@osdl.org
Subject: - unionfs-kconfig-and-makefile.patch removed from -mm tree
Date: Mon, 08 Jan 2007 13:10:20 -0800
Message-ID: <200701082110.l08LAK3P019070@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43715 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXAHVLA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: Kconfig and Makefile
has been removed from the -mm tree.  Its filename was
     unionfs-kconfig-and-makefile.patch

This patch was dropped because I'll use the git tree

------------------------------------------------------
Subject: unionfs: Kconfig and Makefile
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

The changes to fs Kconfig file, Makefiles, and Maintainers file for Unionfs.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS         |    7 +++++++
 fs/Kconfig          |   10 ++++++++++
 fs/Makefile         |    1 +
 fs/unionfs/Makefile |    5 +++++
 4 files changed, 23 insertions(+)

diff -puN MAINTAINERS~unionfs-kconfig-and-makefile MAINTAINERS
--- a/MAINTAINERS~unionfs-kconfig-and-makefile
+++ a/MAINTAINERS
@@ -3294,6 +3294,13 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 
+UNIONFS
+P:	Josef "Jeff" Sipek
+M:	jsipek@cs.sunysb.edu
+L:	unionfs@filesystems.org
+W:	http://www.unionfs.org
+S:	Maintained
+
 USB ACM DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
diff -puN fs/Kconfig~unionfs-kconfig-and-makefile fs/Kconfig
--- a/fs/Kconfig~unionfs-kconfig-and-makefile
+++ a/fs/Kconfig
@@ -1554,6 +1554,16 @@ config UFS_DEBUG
 	  Y here.  This will result in _many_ additional debugging messages to be
 	  written to the system log.
 
+config UNION_FS
+	tristate "Union file system (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Unionfs is a stackable unification file system, which appears to
+	  merge the contents of several directories (branches), while keeping
+	  their physical content separate.
+
+	  See <http://www.unionfs.org> for details
+
 endmenu
 
 menu "Network File Systems"
diff -puN fs/Makefile~unionfs-kconfig-and-makefile fs/Makefile
--- a/fs/Makefile~unionfs-kconfig-and-makefile
+++ a/fs/Makefile
@@ -115,3 +115,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_UNION_FS)		+= unionfs/
diff -puN /dev/null fs/unionfs/Makefile
--- /dev/null
+++ a/fs/unionfs/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_UNION_FS) += unionfs.o
+
+unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
+	stale_inode.o branchman.o rdstate.o copyup.o dirhelper.o \
+	rename.o unlink.o lookup.o commonfops.o dirfops.o sioq.o
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-kconfig-and-makefile.patch
unionfs-extended-attributes-support.patch

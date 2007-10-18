From: akpm@linux-foundation.org
Subject: - remove-valueless-definition-of-hard-selected-ramfs-option.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:25 -0700
Message-ID: <200710180659.l9I6xPic030982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808AbXJRG73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Remove valueless definition of hard-selected RAMFS option
has been removed from the -mm tree.  Its filename was
     remove-valueless-definition-of-hard-selected-ramfs-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove valueless definition of hard-selected RAMFS option
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since CONFIG_RAMFS is currently hard-selected to "y", and since
Documentation/filesystems/ramfs-rootfs-initramfs.txt reads as follows:

"The amount of code required to implement ramfs is tiny, because all the
work is done by the existing Linux caching infrastructure.  Basically,
you're mounting the disk cache as a filesystem.  Because of this, ramfs is
not an optional component removable via menuconfig, since there would be
negligible space savings."

It seems pointless to leave this as a Kconfig entry.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig        |   14 --------------
 fs/Makefile       |    2 +-
 fs/ramfs/Makefile |    2 +-
 3 files changed, 2 insertions(+), 16 deletions(-)

diff -puN fs/Kconfig~remove-valueless-definition-of-hard-selected-ramfs-option fs/Kconfig
--- a/fs/Kconfig~remove-valueless-definition-of-hard-selected-ramfs-option
+++ a/fs/Kconfig
@@ -999,20 +999,6 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
-config RAMFS
-	bool
-	default y
-	---help---
-	  Ramfs is a file system which keeps all files in RAM. It allows
-	  read and write access.
-
-	  It is more of an programming example than a useable file system.  If
-	  you need a file system which lives in RAM with limit checking use
-	  tmpfs.
-
-	  To compile this as a module, choose M here: the module will be called
-	  ramfs.
-
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem (EXPERIMENTAL)"
 	depends on SYSFS && EXPERIMENTAL
diff -puN fs/Makefile~remove-valueless-definition-of-hard-selected-ramfs-option fs/Makefile
--- a/fs/Makefile~remove-valueless-definition-of-hard-selected-ramfs-option
+++ a/fs/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_JBD)		+= jbd/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_EXT2_FS)		+= ext2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
-obj-$(CONFIG_RAMFS)		+= ramfs/
+obj-y				+= ramfs/
 obj-$(CONFIG_HUGETLBFS)		+= hugetlbfs/
 obj-$(CONFIG_CODA_FS)		+= coda/
 obj-$(CONFIG_MINIX_FS)		+= minix/
diff -puN fs/ramfs/Makefile~remove-valueless-definition-of-hard-selected-ramfs-option fs/ramfs/Makefile
--- a/fs/ramfs/Makefile~remove-valueless-definition-of-hard-selected-ramfs-option
+++ a/fs/ramfs/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux ramfs routines.
 #
 
-obj-$(CONFIG_RAMFS) += ramfs.o
+obj-y += ramfs.o
 
 file-mmu-y := file-nommu.o
 file-mmu-$(CONFIG_MMU) := file-mmu.o
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch

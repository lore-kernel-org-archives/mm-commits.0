From: akpm@linux-foundation.org
Subject: + remove-valueless-definition-of-hard-selected-ramfs-option.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:15:19 -0700
Message-ID: <200708311815.l7VIFJiU020310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965778AbXHaSPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, viro@zeniv.linux.org.uk


The patch titled
     Remove valueless definition of hard-selected RAMFS option
has been added to the -mm tree.  Its filename is
     remove-valueless-definition-of-hard-selected-ramfs-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch

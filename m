From: akpm@linux-foundation.org
Subject: - documentation-fix-the-explanation-of-kconfig-files.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:55 -0700
Message-ID: <200705291850.l4TIos4h008307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453AbXE2TFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: fix the explanation of Kconfig files
has been removed from the -mm tree.  Its filename was
     documentation-fix-the-explanation-of-kconfig-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: fix the explanation of Kconfig files
From: Robert P. J. Day <rpjday@mindspring.com>

Fix the obvious errors in the explanation of Kconfig files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   51 +++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff -puN Documentation/CodingStyle~documentation-fix-the-explanation-of-kconfig-files Documentation/CodingStyle
--- a/Documentation/CodingStyle~documentation-fix-the-explanation-of-kconfig-files
+++ a/Documentation/CodingStyle
@@ -495,29 +495,40 @@ re-formatting you may want to take a loo
 remember: "indent" is not a fix for bad programming.
 
 
-		Chapter 10: Configuration-files
+		Chapter 10: Kconfig configuration files
 
-For configuration options (arch/xxx/Kconfig, and all the Kconfig files),
-somewhat different indentation is used.
-
-Help text is indented with 2 spaces.
-
-if CONFIG_EXPERIMENTAL
-	tristate CONFIG_BOOM
-	default n
-	help
-	  Apply nitroglycerine inside the keyboard (DANGEROUS)
-	bool CONFIG_CHEER
-	depends on CONFIG_BOOM
-	default y
+For all of the Kconfig* configuration files throughout the source tree,
+the indentation is somewhat different.  Lines under a "config" definition
+are indented with one tab, while help text is indented an additional two
+spaces.  Example:
+
+config AUDIT
+	bool "Auditing support"
+	depends on NET
 	help
-	  Output nice messages when you explode
-endif
+	  Enable auditing infrastructure that can be used with another
+	  kernel subsystem, such as SELinux (which requires this for
+	  logging of avc messages output).  Does not do system-call
+	  auditing without CONFIG_AUDITSYSCALL.
+
+Features that might still be considered unstable should be defined as
+dependent on "EXPERIMENTAL":
+
+config SLUB
+	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
+	bool "SLUB (Unqueued Allocator)"
+	...
+
+while seriously dangerous features (such as write support for certain
+filesystems) should advertise this prominently in their prompt string:
+
+config ADFS_FS_RW
+	bool "ADFS write support (DANGEROUS)"
+	depends on ADFS_FS
+	...
 
-Generally, CONFIG_EXPERIMENTAL should surround all options not considered
-stable. All options that are known to trash data (experimental write-
-support for file-systems, for instance) should be denoted (DANGEROUS), other
-experimental options should be denoted (EXPERIMENTAL).
+For full documentation on the configuration files, see the file
+Documentation/kbuild/kconfig-language.txt.
 
 
 		Chapter 11: Data structures
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
git-ieee1394.patch
git-kbuild.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch

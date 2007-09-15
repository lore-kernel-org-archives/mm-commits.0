From: akpm@linux-foundation.org
Subject: + express-relocatability-of-kernel-on-x86_64-in.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:18:40 -0700
Message-ID: <200709150818.l8F8IeIi025005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbXIOITa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, vgoyal@in.ibm.com


The patch titled
     Update help text for CONFIG_CRASH_DUMP
has been added to the -mm tree.  Its filename is
     express-relocatability-of-kernel-on-x86_64-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update help text for CONFIG_CRASH_DUMP
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos in CONFIG_RELOCATABLE.  Use tab + 2 spaces for indentation on all
lines.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig   |   17 +++++++++--------
 arch/x86_64/Kconfig |   21 +++++++++++----------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff -puN arch/i386/Kconfig~express-relocatability-of-kernel-on-x86_64-in arch/i386/Kconfig
--- a/arch/i386/Kconfig~express-relocatability-of-kernel-on-x86_64-in
+++ a/arch/i386/Kconfig
@@ -821,12 +821,13 @@ config CRASH_DUMP
 	depends on HIGHMEM
 	help
 	  Generate crash dump after being started by kexec.
-          This should be normally only set in special crash dump kernels
+	  This should be normally only set in special crash dump kernels
 	  which are loaded in the main kernel with kexec-tools into
 	  a specially reserved region and then later executed after
 	  a crash by kdump/kexec. The crash dump kernel must be compiled
-          to a memory address not used by the main kernel or BIOS using
-          PHYSICAL_START.
+	  to a memory address not used by the main kernel or BIOS using
+	  PHYSICAL_START, or it must be built as a relocatable image
+	  (CONFIG_RELOCATABLE=y).
 	  For more details see Documentation/kdump/kdump.txt
 
 config PHYSICAL_START
@@ -872,17 +873,17 @@ config PHYSICAL_START
 	  Don't change this unless you know what you are doing.
 
 config RELOCATABLE
-	bool "Build a relocatable kernel(EXPERIMENTAL)"
+	bool "Build a relocatable kernel (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
 	  This builds a kernel image that retains relocation information
-          so it can be loaded someplace besides the default 1MB.
+	  so it can be loaded someplace besides the default 1MB.
 	  The relocations tend to make the kernel binary about 10% larger,
-          but are discarded at runtime.
+	  but are discarded at runtime.
 
 	  One use is for the kexec on panic case where the recovery kernel
-          must live at a different physical address than the primary
-          kernel.
+	  must live at a different physical address than the primary
+	  kernel.
 
 config PHYSICAL_ALIGN
 	hex "Alignment value to which kernel should be aligned"
diff -puN arch/x86_64/Kconfig~express-relocatability-of-kernel-on-x86_64-in arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~express-relocatability-of-kernel-on-x86_64-in
+++ a/arch/x86_64/Kconfig
@@ -590,17 +590,18 @@ config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
-          Generate crash dump after being started by kexec.
-          This should be normally only set in special crash dump kernels
-          which are loaded in the main kernel with kexec-tools into
-          a specially reserved region and then later executed after
-          a crash by kdump/kexec. The crash dump kernel must be compiled
+	  Generate crash dump after being started by kexec.
+	  This should be normally only set in special crash dump kernels
+	  which are loaded in the main kernel with kexec-tools into
+	  a specially reserved region and then later executed after
+	  a crash by kdump/kexec. The crash dump kernel must be compiled
 	  to a memory address not used by the main kernel or BIOS using
-	  PHYSICAL_START.
-          For more details see Documentation/kdump/kdump.txt
+	  PHYSICAL_START, or it must be built as a relocatable image
+	  (CONFIG_RELOCATABLE=y).
+	  For more details see Documentation/kdump/kdump.txt
 
 config RELOCATABLE
-	bool "Build a relocatable kernel(EXPERIMENTAL)"
+	bool "Build a relocatable kernel (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
 	  Builds a relocatable kernel. This enables loading and running
@@ -611,8 +612,8 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
-	  Note: If CONFIG_RELOCATABLE=y, then kernel run from the address
-	  it has been loaded at and compile time physical address
+	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
+	  it has been loaded at and the compile time physical address
 	  (CONFIG_PHYSICAL_START) is ignored.
 
 config PHYSICAL_START
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
git-mtd.patch
git-nfsd.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch

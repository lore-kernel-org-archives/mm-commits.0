From: akpm@linux-foundation.org
Subject: - express-relocatability-of-kernel-on-x86_64-in.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:32 -0700
Message-ID: <200710180704.l9I74Whe031559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932337AbXJRHmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Update help text for CONFIG_CRASH_DUMP
has been removed from the -mm tree.  Its filename was
     express-relocatability-of-kernel-on-x86_64-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -831,12 +831,13 @@ config CRASH_DUMP
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
@@ -882,17 +883,17 @@ config PHYSICAL_START
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
@@ -582,17 +582,18 @@ config CRASH_DUMP
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
@@ -603,8 +604,8 @@ config RELOCATABLE
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

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
i-oat-cleanup-pci-issues.patch
profile-likely-unlikely-macros.patch

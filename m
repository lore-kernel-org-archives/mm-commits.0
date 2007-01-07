From: akpm@osdl.org
Subject: - i386-restore-config_physical_start-option.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:36 -0800
Message-ID: <200701070758.l077wa0G012966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbXAGH6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     i386: Restore CONFIG_PHYSICAL_START option
has been removed from the -mm tree.  Its filename was
     i386-restore-config_physical_start-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: Restore CONFIG_PHYSICAL_START option
From: Vivek Goyal <vgoyal@in.ibm.com>

o Relocatable bzImage support had got rid of CONFIG_PHYSICAL_START option
  thinking that now this option is not required as people can build a
  second kernel as relocatable and load it anywhere. So need of compiling
  the kernel for a custom address was gone. But Magnus uses vmlinux images
  for second kernel in Xen environment and he wants to continue to use
  it.

o Restoring the CONFIG_PHYSICAL_START option for the time being. I think
  down the line we can get rid of it.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig       |   41 ++++++++++++++++++++++++++++++++++++++
 include/asm-i386/boot.h |    3 +-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~i386-restore-config_physical_start-option arch/i386/Kconfig
--- a/arch/i386/Kconfig~i386-restore-config_physical_start-option
+++ a/arch/i386/Kconfig
@@ -777,6 +777,47 @@ config CRASH_DUMP
           PHYSICAL_START.
 	  For more details see Documentation/kdump/kdump.txt
 
+config PHYSICAL_START
+	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	default "0x100000"
+	help
+	  This gives the physical address where the kernel is loaded.
+
+	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
+	  bzImage will decompress itself to above physical address and
+	  run from there. Otherwise, bzImage will run from the address where
+	  it has been loaded by the boot loader and will ignore above physical
+	  address.
+
+	  In normal kdump cases one does not have to set/change this option
+	  as now bzImage can be compiled as a completely relocatable image
+	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
+	  address. This option is mainly useful for the folks who don't want
+	  to use a bzImage for capturing the crash dump and want to use a
+	  vmlinux instead. vmlinux is not relocatable hence a kernel needs
+	  to be specifically compiled to run from a specific memory area
+	  (normally a reserved region) and this option comes handy.
+
+	  So if you are using bzImage for capturing the crash dump, leave
+	  the value here unchanged to 0x100000 and set CONFIG_RELOCATABLE=y.
+	  Otherwise if you plan to use vmlinux for capturing the crash dump
+	  change this value to start of the reserved region (Typically 16MB
+	  0x1000000). In other words, it can be set based on the "X" value as
+	  specified in the "crashkernel=YM@XM" command line boot parameter
+	  passed to the panic-ed kernel. Typically this parameter is set as
+	  crashkernel=64M@16M. Please take a look at
+	  Documentation/kdump/kdump.txt for more details about crash dumps.
+
+	  Usage of bzImage for capturing the crash dump is recommended as
+	  one does not have to build two kernels. Same kernel can be used
+	  as production kernel and capture kernel. Above option should have
+	  gone away after relocatable bzImage support is introduced. But it
+	  is present because there are users out there who continue to use
+	  vmlinux for dump capture. This option should go away down the
+	  line.
+
+	  Don't change this unless you know what you are doing.
+
 config RELOCATABLE
 	bool "Build a relocatable kernel(EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff -puN include/asm-i386/boot.h~i386-restore-config_physical_start-option include/asm-i386/boot.h
--- a/include/asm-i386/boot.h~i386-restore-config_physical_start-option
+++ a/include/asm-i386/boot.h
@@ -13,7 +13,8 @@
 #define ASK_VGA		0xfffd		/* ask for it at bootup */
 
 /* Physical address where kenrel should be loaded. */
-#define LOAD_PHYSICAL_ADDR ((0x100000 + CONFIG_PHYSICAL_ALIGN - 1) \
+#define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
+				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
 #endif /* _LINUX_BOOT_H */
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

scsi-megaraid_mmmbox-init-fix-for-kdump.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch

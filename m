From: akpm@linux-foundation.org
Subject: + rm9000-serial-driver-tidy.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:48:55 -0800
Message-ID: <200702212148.l1LLmwTQ027461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbXBUVwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 16:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, thomas.koeller@baslerweb.com


The patch titled
     rm9000-serial-driver-tidy
has been added to the -mm tree.  Its filename is
     rm9000-serial-driver-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rm9000-serial-driver-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/serial/8250.c~rm9000-serial-driver-tidy drivers/serial/8250.c
--- a/drivers/serial/8250.c~rm9000-serial-driver-tidy
+++ a/drivers/serial/8250.c
@@ -320,11 +320,19 @@ static const u8
 		[UART_SCR]	= 0x2c
 	};
 
-#define map_8250_in_reg(up, offset) \
-	(((up)->port.iotype == UPIO_RM9000) ? regmap_in[offset] : (offset))
-#define map_8250_out_reg(up, offset) \
-	(((up)->port.iotype == UPIO_RM9000) ? regmap_out[offset] : (offset))
+static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
+{
+	if (up->port.iotype != UPIO_RM9000)
+		return offset;
+	return regmap_in[offset];
+}
 
+static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
+{
+	if (up->port.iotype != UPIO_RM9000)
+		return offset;
+	return regmap_out[offset];
+}
 
 #else
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

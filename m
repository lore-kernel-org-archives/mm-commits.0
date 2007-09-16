From: akpm@linux-foundation.org
Subject: - arm-extern-inline-static-inline.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:50 -0700
Message-ID: <200709160926.l8G9QoEG009211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbXIPJi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     arm: "extern inline" -> "static inline"
has been removed from the -mm tree.  Its filename was
     arm-extern-inline-static-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm: "extern inline" -> "static inline"
From: Adrian Bunk <bunk@kernel.org>

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/nwfpe/ARM-gcc.h                |    2 +-
 arch/arm/nwfpe/fpa11.inl                |    8 ++++----
 include/asm-arm/arch-ixp23xx/platform.h |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/arm/nwfpe/ARM-gcc.h~arm-extern-inline-static-inline arch/arm/nwfpe/ARM-gcc.h
--- a/arch/arm/nwfpe/ARM-gcc.h~arm-extern-inline-static-inline
+++ a/arch/arm/nwfpe/ARM-gcc.h
@@ -68,7 +68,7 @@ a compiler does not support explicit inl
 to be `static'.
 -------------------------------------------------------------------------------
 */
-#define INLINE extern __inline__
+#define INLINE static inline
 
 
 /* For use as a GCC soft-float library we need some special function names. */
diff -puN arch/arm/nwfpe/fpa11.inl~arm-extern-inline-static-inline arch/arm/nwfpe/fpa11.inl
--- a/arch/arm/nwfpe/fpa11.inl~arm-extern-inline-static-inline
+++ a/arch/arm/nwfpe/fpa11.inl
@@ -22,13 +22,13 @@
 #include "fpa11.h"
 
 /* Read and write floating point status register */
-extern __inline__ unsigned int readFPSR(void)
+static inline unsigned int readFPSR(void)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	return (fpa11->fpsr);
 }
 
-extern __inline__ void writeFPSR(FPSR reg)
+static inline void writeFPSR(FPSR reg)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	/* the sysid byte in the status register is readonly */
@@ -36,14 +36,14 @@ extern __inline__ void writeFPSR(FPSR re
 }
 
 /* Read and write floating point control register */
-extern __inline__ FPCR readFPCR(void)
+static inline FPCR readFPCR(void)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	/* clear SB, AB and DA bits before returning FPCR */
 	return (fpa11->fpcr & ~MASK_RFC);
 }
 
-extern __inline__ void writeFPCR(FPCR reg)
+static inline void writeFPCR(FPCR reg)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	fpa11->fpcr &= ~MASK_WFC;		/* clear SB, AB and DA bits */
diff -puN include/asm-arm/arch-ixp23xx/platform.h~arm-extern-inline-static-inline include/asm-arm/arch-ixp23xx/platform.h
--- a/include/asm-arm/arch-ixp23xx/platform.h~arm-extern-inline-static-inline
+++ a/include/asm-arm/arch-ixp23xx/platform.h
@@ -14,17 +14,17 @@
 
 #ifndef __ASSEMBLY__
 
-extern inline unsigned long ixp2000_reg_read(volatile void *reg)
+static inline unsigned long ixp2000_reg_read(volatile void *reg)
 {
 	return *((volatile unsigned long *)reg);
 }
 
-extern inline void ixp2000_reg_write(volatile void *reg, unsigned long val)
+static inline void ixp2000_reg_write(volatile void *reg, unsigned long val)
 {
 	*((volatile unsigned long *)reg) = val;
 }
 
-extern inline void ixp2000_reg_wrb(volatile void *reg, unsigned long val)
+static inline void ixp2000_reg_wrb(volatile void *reg, unsigned long val)
 {
 	*((volatile unsigned long *)reg) = val;
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-alsa.patch
git-arm.patch
ppc-remove-apus-support.patch
powerpc-proper-defconfig-for-crosscompiles.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-block.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch

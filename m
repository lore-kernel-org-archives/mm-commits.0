From: akpm@linux-foundation.org
Subject: [folded] drivers-char-memc-cleanups-fix-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:51:26 -0800
Message-ID: <201003102251.o2AMpQB4008639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757420Ab0CJWvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     drivers-char-memc-cleanups-fix-fix
has been removed from the -mm tree.  Its filename was
     drivers-char-memc-cleanups-fix-fix.patch

This patch was dropped because it was folded into drivers-char-memc-cleanups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-char-memc-cleanups-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

uninlining revealed:

drivers/char/mem.c:53: warning: 'uncached_access' defined but not used

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   65 +++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-memc-cleanups-fix-fix drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-cleanups-fix-fix
+++ a/drivers/char/mem.c
@@ -44,38 +44,6 @@ static inline unsigned long size_inside_
 	return min(sz, size);
 }
 
-/*
- * Architectures vary in how they handle caching for addresses
- * outside of main memory.
- *
- */
-static int uncached_access(struct file *file, unsigned long addr)
-{
-#if defined(CONFIG_IA64)
-	/*
-	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory
-	 * attribute aliases.
-	 */
-	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
-#elif defined(CONFIG_MIPS)
-	{
-		extern int __uncached_access(struct file *file,
-					     unsigned long addr);
-
-		return __uncached_access(file, addr);
-	}
-#else
-	/*
-	 * Accessing memory above the top the kernel knows about or through a
-	 * file pointer
-	 * that was marked O_DSYNC will be done non-cached.
-	 */
-	if (file->f_flags & O_DSYNC)
-		return 1;
-	return addr >= __pa(high_memory);
-#endif
-}
-
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
 static inline int valid_phys_addr_range(unsigned long addr, size_t count)
 {
@@ -251,6 +219,39 @@ int __weak phys_mem_access_prot_allowed(
 }
 
 #ifndef __HAVE_PHYS_MEM_ACCESS_PROT
+
+/*
+ * Architectures vary in how they handle caching for addresses
+ * outside of main memory.
+ *
+ */
+static int uncached_access(struct file *file, unsigned long addr)
+{
+#if defined(CONFIG_IA64)
+	/*
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory
+	 * attribute aliases.
+	 */
+	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
+#elif defined(CONFIG_MIPS)
+	{
+		extern int __uncached_access(struct file *file,
+					     unsigned long addr);
+
+		return __uncached_access(file, addr);
+	}
+#else
+	/*
+	 * Accessing memory above the top the kernel knows about or through a
+	 * file pointer
+	 * that was marked O_DSYNC will be done non-cached.
+	 */
+	if (file->f_flags & O_DSYNC)
+		return 1;
+	return addr >= __pa(high_memory);
+#endif
+}
+
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper.patch
broadsheetfb-support-storing-waveform.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
pps-serial-clients-support-warning-fixes.patch
sysctl-extern-cleanup-binfmts-fix.patch
sysctl-extern-cleanup-module-fix.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


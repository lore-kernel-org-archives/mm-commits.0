From: akpm@linux-foundation.org
Subject: + drivers-char-memc-cleanups-fix-fix.patch added to -mm tree
Date: Wed, 10 Feb 2010 13:50:40 -0800
Message-ID: <201002102216.o1AMGIxU002234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab0BJWQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Feb 2010 17:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     drivers-char-memc-cleanups-fix-fix
has been added to the -mm tree.  Its filename is
     drivers-char-memc-cleanups-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


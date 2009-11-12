From: akpm@linux-foundation.org
Subject: + crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:10:04 -0800
Message-ID: <200911122210.nACMA5gD000783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbZKLWKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:10:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Joakim.Tjernlund@transmode.se


The patch titled
     crc32-minor-optimizations-and-cleanup-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch

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
Subject: crc32-minor-optimizations-and-cleanup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

may as well depukify it a bit while we're there.



WARNING: plain inline is preferred over __inline__
#22: FILE: lib/crc32.c:47:
+static __inline__ u32

ERROR: space prohibited after that open square bracket '['
#26: FILE: lib/crc32.c:51:
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)

ERROR: space prohibited before that close square bracket ']'
#26: FILE: lib/crc32.c:51:
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)

ERROR: Macros with complex values should be enclosed in parenthesis
#26: FILE: lib/crc32.c:51:
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)

ERROR: space prohibited after that open square bracket '['
#28: FILE: lib/crc32.c:53:
+#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)

ERROR: Macros with complex values should be enclosed in parenthesis
#28: FILE: lib/crc32.c:53:
+#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)

ERROR: spaces required around that '=' (ctx:WxV)
#30: FILE: lib/crc32.c:55:
+	const u32 *b =(u32 *)buf;
 	             ^

ERROR: space required before the open parenthesis '('
#34: FILE: lib/crc32.c:59:
+	if(unlikely(((long)b)&3 && len)) {

ERROR: space required before the open parenthesis '('
#53: FILE: lib/crc32.c:78:
+	if(len) {

total: 8 errors, 1 warnings, 145 lines checked

./patches/crc32-minor-optimizations-and-cleanup.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/crc32.c~crc32-minor-optimizations-and-cleanup-checkpatch-fixes lib/crc32.c
--- a/lib/crc32.c~crc32-minor-optimizations-and-cleanup-checkpatch-fixes
+++ a/lib/crc32.c
@@ -44,19 +44,19 @@ MODULE_LICENSE("GPL");
 
 #if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
 
-static __inline__ u32
+static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
+#  define DO_CRC(x) crc = tab[(crc ^ (x)) & 255 ] ^ (crc >> 8)
 # else
-#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
+#  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
 # endif
-	const u32 *b =(u32 *)buf;
+	const u32 *b = (const u32 *)buf;
 	size_t    rem_len;
 
 	/* Align it */
-	if(unlikely(((long)b)&3 && len)) {
+	if (unlikely((long)b & 3 && len)) {
 		u8 *p = (u8 *)b;
 		do {
 			DO_CRC(*p++);
@@ -75,7 +75,7 @@ crc32_body(u32 crc, unsigned char const 
 	}
 	len = rem_len;
 	/* And the last few bytes */
-	if(len) {
+	if (len) {
 		u8 *p = (u8 *)(b + 1) - 1;
 		do {
 			DO_CRC(*++p); /* use pre increment for speed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-move-thread_size-definition-outside-ifndef-assembly.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


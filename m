From: akpm@linux-foundation.org
Subject: + zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch added to -mm tree
Date: Fri, 13 Nov 2009 14:48:39 -0800
Message-ID: <200911132248.nADMmdeQ019147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182AbZKMWtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:49:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Joakim.Tjernlund@transmode.se


The patch titled
     zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch

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
Subject: zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#90: FILE: lib/zlib_inflate/inffast.c:250:
+                    /* minimum length is three */$

ERROR: space prohibited before that close parenthesis ')'
#97: FILE: lib/zlib_inflate/inffast.c:257:
+		    if (dist > 2 ) {

WARNING: suspect code indent for conditional statements (24, 28)
#111: FILE: lib/zlib_inflate/inffast.c:271:
+			if (dist == 1)
[...]
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);

ERROR: space prohibited before that close parenthesis ')'
#113: FILE: lib/zlib_inflate/inffast.c:273:
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);

ERROR: space prohibited before that close parenthesis ')'
#115: FILE: lib/zlib_inflate/inffast.c:275:
+			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00 ) >> 8);

total: 4 errors, 1 warnings, 93 lines checked

./patches/zlib-optimize-inffast-when-copying-direct-from-output.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes
+++ a/lib/zlib_inflate/inffast.c
@@ -247,14 +247,14 @@ void inflate_fast(z_streamp strm, unsign
 		    unsigned long loops;
 
                     from = out - dist;          /* copy direct from output */
-                    /* minimum length is three */
+		    /* minimum length is three */
 		    /* Align out addr */
 		    if (!((long)(out - 1 + OFF) & 1)) {
 			PUP(out) = PUP(from);
 			len--;
 		    }
 		    sout = (unsigned short *)(out - OFF);
-		    if (dist > 2 ) {
+		    if (dist > 2) {
 			unsigned short *sfrom;
 
 			sfrom = (unsigned short *)(from - OFF);
@@ -270,9 +270,9 @@ void inflate_fast(z_streamp strm, unsign
 			pat16 = *(sout-2+2*OFF);
 			if (dist == 1)
 #if defined(__BIG_ENDIAN)
-			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff) << 8);
 #elif defined(__LITTLE_ENDIAN)
-			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00 ) >> 8);
+			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00) >> 8);
 #else
 #error __BIG_ENDIAN nor __LITTLE_ENDIAN is defined
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch
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
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
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


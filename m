From: akpm@linux-foundation.org
Subject: [nacked] mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch removed from -mm tree
Date: Sat, 18 Apr 2009 10:55:49 -0700
Message-ID: <200904181755.n3IHtnk0031901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZDRR6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Apr 2009 13:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, maxin.john@gmail.com, maxinbjohn@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited after that open parenthesis '('
#122: FILE: arch/mips/mm/cache.c:68:
+       if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )

ERROR: space prohibited before that close parenthesis ')'
#122: FILE: arch/mips/mm/cache.c:68:
+       if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )

ERROR: code indent should use tabs where possible
#123: FILE: arch/mips/mm/cache.c:69:
+                return -EINVAL;$

total: 3 errors, 0 warnings, 10 lines checked

./patches/mips-cacheflush-system-call-not-returning-einval.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Maxin B. John <maxinbjohn@gmail.com>
Cc: Maxin John <maxin.john@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/mm/cache.c~mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes
+++ a/arch/mips/mm/cache.c
@@ -65,8 +65,8 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 	if (bytes == 0)
 		return 0;
 
-       if ( (cache != ICACHE) && (cache != DCACHE) && (cache != BCACHE) )
-                return -EINVAL;
+	if (cache != ICACHE && cache != DCACHE && cache != BCACHE)
+		return -EINVAL;
 
 	if (!access_ok(VERIFY_WRITE, (void __user *) addr, bytes))
 		return -EFAULT;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


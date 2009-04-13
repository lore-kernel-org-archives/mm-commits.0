From: akpm@linux-foundation.org
Subject: + squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch added to -mm tree
Date: Mon, 13 Apr 2009 15:51:29 -0700
Message-ID: <200904132251.n3DMpT3M024464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZDMWxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Apr 2009 18:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, doug.chapman@hp.com, phillip@lougher.demon.co.uk


The patch titled
     squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch

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
Subject: squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: spaces required around that '?' (ctx:VxV)
#22: FILE: fs/squashfs/cache.c:255:
+	cache->pages = cache->pages?cache->pages:1;
 	                           ^

ERROR: spaces required around that ':' (ctx:VxV)
#22: FILE: fs/squashfs/cache.c:255:
+	cache->pages = cache->pages?cache->pages:1;
 	                                        ^

total: 2 errors, 0 warnings, 7 lines checked

./patches/squashfs-fix-breakage-when-pagesize-blocksize.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Chapman <doug.chapman@hp.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/squashfs/cache.c~squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes fs/squashfs/cache.c
--- a/fs/squashfs/cache.c~squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes
+++ a/fs/squashfs/cache.c
@@ -252,7 +252,7 @@ struct squashfs_cache *squashfs_cache_in
 	cache->entries = entries;
 	cache->block_size = block_size;
 	cache->pages = block_size >> PAGE_CACHE_SHIFT;
-	cache->pages = cache->pages?cache->pages:1;
+	cache->pages = cache->pages ? cache->pages : 1;
 	cache->name = name;
 	cache->num_waiters = 0;
 	spin_lock_init(&cache->lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hfs-fix-memory-leak-when-unmounting.patch
memcg-remove-warning-when-config_debug_vm=n.patch
shmem-respect-max_lfs_filesize.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-dont-open-code-smp_call_function_many.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
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
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
readahead-introduce-context-readahead-algorithm-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
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


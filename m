From: akpm@linux-foundation.org
Subject: [folded] hfs-fix-memory-leak-when-unmounting-fix.patch removed from -mm tree
Date: Mon, 13 Apr 2009 14:35:02 -0700
Message-ID: <200904132135.n3DLZ2EB022228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbZDMVh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Apr 2009 17:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anderson@redhat.com, eugeneteo@kernel.sg, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs-fix-memory-leak-when-unmounting-fix
has been removed from the -mm tree.  Its filename was
     hfs-fix-memory-leak-when-unmounting-fix.patch

This patch was dropped because it was folded into hfs-fix-memory-leak-when-unmounting.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs-fix-memory-leak-when-unmounting-fix
From: Andrew Morton <akpm@linux-foundation.org>

- free_pages(0) is legal

- the comment was a bit obvious ;)

Cc: Dave Anderson <anderson@redhat.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/hfs/mdb.c~hfs-fix-memory-leak-when-unmounting-fix fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-fix-memory-leak-when-unmounting-fix
+++ a/fs/hfs/mdb.c
@@ -349,10 +349,7 @@ void hfs_mdb_put(struct super_block *sb)
 	if (HFS_SB(sb)->nls_disk)
 		unload_nls(HFS_SB(sb)->nls_disk);
 
-	/* free the bitmap page(s) */
-	if (HFS_SB(sb)->bitmap)
-		free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
-
+	free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
 	kfree(HFS_SB(sb));
 	sb->s_fs_info = NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hfs-fix-memory-leak-when-unmounting.patch
hfs-fix-memory-leak-when-unmounting-fix.patch
memcg-remove-warning-when-config_debug_vm=n-fix.patch
shmem-respect-max_lfs_filesize-fix.patch
shmem-respect-max_lfs_filesize-fix-fix.patch
shmem-respect-max_lfs_filesize-fix-2.patch
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


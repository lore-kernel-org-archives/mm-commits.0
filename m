From: akpm@linux-foundation.org
Subject: + edac-add-edac_device_alloc_index-cleanup.patch added to -mm tree
Date: Wed, 15 Apr 2009 15:27:46 -0700
Message-ID: <200904152227.n3FMRkAO007185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987AbZDOWcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 18:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org, qingtao.cao@windriver.com


The patch titled
     edac-add-edac_device_alloc_index-cleanup
has been added to the -mm tree.  Its filename is
     edac-add-edac_device_alloc_index-cleanup.patch

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
Subject: edac-add-edac_device_alloc_index-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

keep things neat.  Also avoids having global identifier device_index
shadowed by local identifier device_index.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Harry Ciao <qingtao.cao@windriver.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup
+++ a/drivers/edac/edac_device.c
@@ -37,7 +37,6 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
-static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -499,6 +498,8 @@ void edac_device_reset_delay_period(stru
  */
 int edac_device_alloc_index(void)
 {
+	static atomic_t device_indexes = ATOMIC_INIT(0);
+
 	return atomic_inc_return(&device_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_device_alloc_index);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
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


From: akpm@linux-foundation.org
Subject: + floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:16:22 -0700
Message-ID: <200909302316.n8UNGMug001944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbZI3XQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org


The patch titled
     floppy-add-an-extra-bound-check-on-ioctl-arguments-fix
has been added to the -mm tree.  Its filename is
     floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch

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
Subject: floppy-add-an-extra-bound-check-on-ioctl-arguments-fix
From: Andrew Morton <akpm@linux-foundation.org>

add WARN_ON()

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~floppy-add-an-extra-bound-check-on-ioctl-arguments-fix drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-add-an-extra-bound-check-on-ioctl-arguments-fix
+++ a/drivers/block/floppy.c
@@ -3497,7 +3497,7 @@ static int fd_ioctl(struct block_device 
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
 		return -EPERM;
 
-	if (size < 0 || size > sizeof(inparam))
+	if (WARN_ON(size < 0 || size > sizeof(inparam)))
 		return -EINVAL;
 
 	/* copyin */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-input-inputc-fix-config_pm=n-warning.patch
revert-m68k-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
serial167-fix-read-buffer-overflow.patch
ar9170-fix-bug-in-iq-auto-calibration-value-calculation.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
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


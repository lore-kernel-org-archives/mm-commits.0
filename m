From: akpm@linux-foundation.org
Subject: + scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch added to -mm tree
Date: Thu, 08 Oct 2009 14:33:51 -0700
Message-ID: <200910082133.n98LXpeO023183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933524AbZJHVek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 17:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com


The patch titled
     scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix
has been added to the -mm tree.  Its filename is
     scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch

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
Subject: scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid helpful cleanup patches.

Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/hpsa.c~scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix
+++ a/drivers/scsi/hpsa.c
@@ -214,7 +214,7 @@ static inline int is_logical_dev_addr_mo
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
-#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0]) - 1)
+#define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
 
 static ssize_t raid_level_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-sdio-dont-require-cistpl_vers_1-to-contain-4-strings.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
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


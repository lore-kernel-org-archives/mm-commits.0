From: akpm@linux-foundation.org
Subject: + usb-storage-add-new-no_read_disc_info-quirk-fix.patch added to -mm tree
Date: Tue, 27 Jul 2010 13:16:04 -0700
Message-ID: <201007272045.o6RKjgDE004435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab0G0UqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jul 2010 16:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, greg@kroah.com, hdegoede@redhat.com, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu


The patch titled
     usb-storage-add-new-no_read_disc_info-quirk-fix
has been added to the -mm tree.  Its filename is
     usb-storage-add-new-no_read_disc_info-quirk-fix.patch

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
Subject: usb-storage-add-new-no_read_disc_info-quirk-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/usb/storage/scsiglue.c: In function 'slave_configure':
drivers/usb/storage/scsiglue.c:262: error: 'US_FLAG_NO_READ_DISC_INFO' undeclared (first use in this function)
drivers/usb/storage/scsiglue.c:262: error: (Each undeclared identifier is reported only once
drivers/usb/storage/scsiglue.c:262: error: for each function it appears in.)


huh?


Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/scsiglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/storage/scsiglue.c~usb-storage-add-new-no_read_disc_info-quirk-fix drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c~usb-storage-add-new-no_read_disc_info-quirk-fix
+++ a/drivers/usb/storage/scsiglue.c
@@ -255,7 +255,7 @@ static int slave_configure(struct scsi_d
 		sdev->use_10_for_ms = 1;
 
 		/* Some (fake) usb cdrom devices don't like READ_DISC_INFO */
-		if (us->fflags & US_FLAG_NO_READ_DISC_INFO)
+		if (us->fflags & US_FL_NO_READ_DISC_INFO)
 			sdev->no_read_disc_info = 1;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap-checkpatch-fixes.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
a.patch


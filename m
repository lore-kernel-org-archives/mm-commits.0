From: akpm@linux-foundation.org
Subject: + drivers-scsi-qla4xxx-fix-build.patch added to -mm tree
Date: Wed, 11 Aug 2010 14:43:24 -0700
Message-ID: <201008112213.o7BMDNJ9017368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab0HKWN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 18:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com


The patch titled
     drivers/scsi/qla4xxx: fix build
has been added to the -mm tree.  Its filename is
     drivers-scsi-qla4xxx-fix-build.patch

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
Subject: drivers/scsi/qla4xxx: fix build
From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/qla4xxx/ql4_os.c: In function 'qla4_8xxx_error_recovery':
drivers/scsi/qla4xxx/ql4_glbl.h:135: sorry, unimplemented: inlining failed in call to 'qla4_8xxx_set_drv_active': function body not available
drivers/scsi/qla4xxx/ql4_os.c:2377: sorry, unimplemented: called from here
drivers/scsi/qla4xxx/ql4_glbl.h:135: sorry, unimplemented: inlining failed in call to 'qla4_8xxx_set_drv_active': function body not available
drivers/scsi/qla4xxx/ql4_os.c:2393: sorry, unimplemented: called from here

Cc: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla4xxx/ql4_glbl.h~drivers-scsi-qla4xxx-fix-build drivers/scsi/qla4xxx/ql4_glbl.h
--- a/drivers/scsi/qla4xxx/ql4_glbl.h~drivers-scsi-qla4xxx-fix-build
+++ a/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -132,7 +132,7 @@ void qla4_8xxx_idc_unlock(struct scsi_ql
 int qla4_8xxx_device_state_handler(struct scsi_qla_host *ha);
 void qla4_8xxx_need_qsnt_handler(struct scsi_qla_host *ha);
 void qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha);
-inline void qla4_8xxx_set_drv_active(struct scsi_qla_host *ha);
+void qla4_8xxx_set_drv_active(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
diff -puN drivers/scsi/qla4xxx/ql4_os.c~drivers-scsi-qla4xxx-fix-build drivers/scsi/qla4xxx/ql4_os.c
diff -puN drivers/scsi/qla4xxx/ql4_nx.c~drivers-scsi-qla4xxx-fix-build drivers/scsi/qla4xxx/ql4_nx.c
--- a/drivers/scsi/qla4xxx/ql4_nx.c~drivers-scsi-qla4xxx-fix-build
+++ a/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1418,7 +1418,7 @@ static int qla4_8xxx_rcvpeg_ready(struct
 	return QLA_SUCCESS;
 }
 
-inline void
+void
 qla4_8xxx_set_drv_active(struct scsi_qla_host *ha)
 {
 	uint32_t drv_active;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-fix-bogus-preemption-logic.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
drivers-acpi-debugfsc-needs-uaccessh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-scsi-qla4xxx-fix-build.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
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


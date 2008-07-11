From: akpm@linux-foundation.org
Subject: - pm-remove-references-to-struct-pm_dev-from-irda-headers.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:21 -0700
Message-ID: <200807112351.m6BNpLtd011034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754797AbYGKXvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@suse.cz, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     pm: remove references to struct pm_dev from IRDA headers
has been removed from the -mm tree.  Its filename was
     pm-remove-references-to-struct-pm_dev-from-irda-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: remove references to struct pm_dev from IRDA headers
From: Rafael J. Wysocki <rjw@sisk.pl>

Some IRDA headers contain references to 'struct pm_dev' that are not
necessary any more and may be removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/ali-ircc.h    |    2 --
 drivers/net/irda/au1000_ircc.h |    1 -
 drivers/net/irda/via-ircc.h    |    1 -
 3 files changed, 4 deletions(-)

diff -puN drivers/net/irda/ali-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers drivers/net/irda/ali-ircc.h
--- a/drivers/net/irda/ali-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers
+++ a/drivers/net/irda/ali-ircc.h
@@ -219,8 +219,6 @@ struct ali_ircc_cb {
 	int index;                 /* Instance index */
 	
 	unsigned char fifo_opti_buf;
-
-        struct pm_dev *dev;
 };
 
 static inline void switch_bank(int iobase, int bank)
diff -puN drivers/net/irda/au1000_ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers drivers/net/irda/au1000_ircc.h
--- a/drivers/net/irda/au1000_ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers
+++ a/drivers/net/irda/au1000_ircc.h
@@ -122,6 +122,5 @@ struct au1k_private {
 	struct timer_list timer;
 
 	spinlock_t lock;           /* For serializing operations */
-        struct pm_dev *dev;
 };
 #endif /* AU1000_IRCC_H */
diff -puN drivers/net/irda/via-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers drivers/net/irda/via-ircc.h
--- a/drivers/net/irda/via-ircc.h~pm-remove-references-to-struct-pm_dev-from-irda-headers
+++ a/drivers/net/irda/via-ircc.h
@@ -118,7 +118,6 @@ struct via_ircc_cb {
 	int index;		/* Instance index */
 
 	struct eventflag EventFlag;
-	struct pm_dev *dev;
 	unsigned int chip_id;	/* to remember chip id */
 	unsigned int RetryCount;
 	unsigned int RxDataReady;
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
remove-include-linux-pm_legacyh.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-remaining-obsolete-definitions-from-pmh.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
pm-drop-unnecessary-includes-from-pmh.patch
pm-add-new-pm_event-codes-for-runtime-power-transitions.patch
pm-ahci-speed-up-resume.patch
pm-hibernation-simplify-memory-bitmap.patch
pm-serio-speed-up-resume.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
pm-acpi-hibernation-utilize-hardware-signature.patch
pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
shrink_slab-handle-bad-shrinkers.patch


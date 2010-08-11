From: akpm@linux-foundation.org
Subject: + sdhci-get-rid-of-card-detect-work-fix.patch added to -mm tree
Date: Wed, 11 Aug 2010 14:23:12 -0700
Message-ID: <201008112153.o7BLrBut016484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab0HKVxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 17:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, albert_herranz@yahoo.es, avorontsov@mvista.com, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci-get-rid-of-card-detect-work-fix
has been added to the -mm tree.  Its filename is
     sdhci-get-rid-of-card-detect-work-fix.patch

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
Subject: sdhci-get-rid-of-card-detect-work-fix
From: Andrew Morton <akpm@linux-foundation.org>

sdhci_card_detect() is now used in drivers/mmc/host/sdhci-s3c.c.

Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Anton Vorontsov <avorontsov@mvista.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-get-rid-of-card-detect-work-fix drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-get-rid-of-card-detect-work-fix
+++ a/drivers/mmc/host/sdhci.c
@@ -1256,7 +1256,7 @@ static const struct mmc_host_ops sdhci_o
  *                                                                           *
 \*****************************************************************************/
 
-static void sdhci_card_detect(struct sdhci_host *host)
+void sdhci_card_detect(struct sdhci_host *host)
 {
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
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


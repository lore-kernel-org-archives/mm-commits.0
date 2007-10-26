From: akpm@linux-foundation.org
Subject: - drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:17 -0700
Message-ID: <200710261848.l9QImHls009126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbXJZSsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, bzolnier@gmail.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ide/pci/sc1200.c: fix suspend/resume buglets and warnings
has been removed from the -mm tree.  Its filename was
     drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/ide/pci/sc1200.c: fix suspend/resume buglets and warnings
From: Jeff Garzik <jeff@garzik.org>

* We shouldn't bother with dev->current_state, the PCI API functions we
  call manage this for us (and do a far better job at it too).

* Remove pci_set_power_state(dev, PCI_D0) call in resume, as
  pci_enable_device() does the same thing.

* Check pci_enable_device() return value.  If it failed, fail
  the entire resume and avoid programming timings into the [potentially
  dead/asleep] chip.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/sc1200.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/ide/pci/sc1200.c~drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings drivers/ide/pci/sc1200.c
--- a/drivers/ide/pci/sc1200.c~drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings
+++ a/drivers/ide/pci/sc1200.c
@@ -334,7 +334,6 @@ static int sc1200_suspend (struct pci_de
 	 */
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
-	dev->current_state = state.event;
 	return 0;
 }
 
@@ -343,9 +342,10 @@ static int sc1200_resume (struct pci_dev
 	ide_hwif_t		*hwif;
 	int			i;
 
-	pci_set_power_state(dev, PCI_D0);	// bring chip back from sleep state
-	dev->current_state = PM_EVENT_ON;
-	pci_enable_device(dev);
+	i = pci_enable_device(dev);
+	if (i)
+		return i;
+
 	//
 	// loop over all interfaces that are part of this pci device:
 	//
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch

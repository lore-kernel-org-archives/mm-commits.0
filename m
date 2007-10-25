From: akpm@linux-foundation.org
Subject: + remove-warnings-for-longstanding-conditions.patch added to -mm tree
Date: Thu, 25 Oct 2007 01:13:56 -0700
Message-ID: <200710250813.l9P8Duwx014660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbXJYIT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 04:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com, kkeil@suse.de, willy@debian.org


The patch titled
     Remove #warnings for longstanding conditions
has been added to the -mm tree.  Its filename is
     remove-warnings-for-longstanding-conditions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove #warnings for longstanding conditions
From: Jeff Garzik <jeff@garzik.org>

These two warnings...

drivers/isdn/capi/capidrv.c:2126:3: warning: #warning FIXME: maybe a
race condition the card should be removed here from global list /kkeil

drivers/scsi/advansys.c:71:2: warning: #warning this driver is still
not properly converted to the DMA API

...represent conditions that have existed for years, and are duly noted
in FIXMEs.  There does not seem to be much need to warn on every kernel
build for a driver bug or handicap that has existed for years.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capidrv.c |    3 ++-
 drivers/scsi/advansys.c     |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/capi/capidrv.c~remove-warnings-for-longstanding-conditions drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~remove-warnings-for-longstanding-conditions
+++ a/drivers/isdn/capi/capidrv.c
@@ -2123,7 +2123,8 @@ static int capidrv_delcontr(u16 contr)
 		printk(KERN_ERR "capidrv: delcontr: no contr %u\n", contr);
 		return -1;
 	}
-	#warning FIXME: maybe a race condition the card should be removed here from global list /kkeil
+
+	/* FIXME: maybe a race condition the card should be removed here from global list /kkeil */
 	spin_unlock_irqrestore(&global_lock, flags);
 
 	del_timer(&card->listentimer);
diff -puN drivers/scsi/advansys.c~remove-warnings-for-longstanding-conditions drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~remove-warnings-for-longstanding-conditions
+++ a/drivers/scsi/advansys.c
@@ -68,7 +68,6 @@
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
-#warning this driver is still not properly converted to the DMA API
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
_

Patches currently in -mm which might be from jeff@garzik.org are

lguest-build-fix.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
permit-silencing-of-__deprecated-warnings.patch
remove-warnings-for-longstanding-conditions.patch
isdn-capidrv-fix-casting-warning.patch
isdn-sc-fix-longstanding-warning.patch

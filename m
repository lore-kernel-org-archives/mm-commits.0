From: akpm@linux-foundation.org
Subject: + sound-oss-sb_commonc-fix-casting-warning.patch added to -mm tree
Date: Thu, 25 Oct 2007 01:13:51 -0700
Message-ID: <200710250813.l9P8DpET014654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427AbXJYITO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 04:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com


The patch titled
     sound/oss/sb_common.c: fix casting warning
has been added to the -mm tree.  Its filename is
     sound-oss-sb_commonc-fix-casting-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sound/oss/sb_common.c: fix casting warning
From: Jeff Garzik <jeff@garzik.org>

sound/oss/sb_common.c: In function 'probe_sbmpu':
sound/oss/sb_common.c:1231: warning: cast to pointer from integer of different size

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/sb_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN sound/oss/sb_common.c~sound-oss-sb_commonc-fix-casting-warning sound/oss/sb_common.c
--- a/sound/oss/sb_common.c~sound-oss-sb_commonc-fix-casting-warning
+++ a/sound/oss/sb_common.c
@@ -1228,7 +1228,8 @@ int probe_sbmpu(struct address_info *hw_
 		}
 		attach_mpu401(hw_config, owner);
 		if (last_sb->irq == -hw_config->irq)
-			last_sb->midi_irq_cookie=(void *)hw_config->slots[1];
+			last_sb->midi_irq_cookie =
+				(void *)(long) hw_config->slots[1];
 		return 1;
 	}
 #endif
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

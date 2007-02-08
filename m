From: akpm@linux-foundation.org
Subject: - scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:37 -0800
Message-ID: <200702080948.l189mbbn011050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423209AbXBHJso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     SCSI-BusLogic: local_irq_disable() is redundant after local_irq_save()
has been removed from the -mm tree.  Its filename was
     scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI-BusLogic: local_irq_disable() is redundant after local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

drivers/scsi/BusLogic.c::BusLogic_Command() contains local_irq_disable() call
after local_irq_save().  This looks redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/BusLogic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/BusLogic.c~scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c~scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save
+++ a/drivers/scsi/BusLogic.c
@@ -362,10 +362,8 @@ static int BusLogic_Command(struct BusLo
 	   interrupt could occur if the IRQ Channel was previously enabled by another
 	   BusLogic Host Adapter or another driver sharing the same IRQ Channel.
 	 */
-	if (!HostAdapter->IRQ_ChannelAcquired) {
+	if (!HostAdapter->IRQ_ChannelAcquired)
 		local_irq_save(ProcessorFlags);
-		local_irq_disable();
-	}
 	/*
 	   Wait for the Host Adapter Ready bit to be set and the Command/Parameter
 	   Register Busy bit to be reset in the Status Register.
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-powerpc.patch
git-scsi-misc.patch
git-ipwireless_cs.patch
cris-local_irq_disable-is-redundant-after-local_irq_save.patch
cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch
char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch

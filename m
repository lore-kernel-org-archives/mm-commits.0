From: akpm@linux-foundation.org
Subject: - sata_promise-sata-hotplug-support-take-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 11:45:10 -0700
Message-ID: <200707091845.l69IjAFL001279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbXGISpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 14:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_promise: SATA hotplug support, take 2
has been removed from the -mm tree.  Its filename was
     sata_promise-sata-hotplug-support-take-2.patch

This patch was dropped because it was folded into sata_promise-sata-hotplug-support.patch

------------------------------------------------------
Subject: sata_promise: SATA hotplug support, take 2
From: Mikael Pettersson <mikpe@it.uu.se>

Changes since the previous version (posted June 19):
- Correct pdc_interrupt() to increment 'handled' also in
  the hotplug case. This prevents IRQ_NONE from being
  returned when an interrupt only has hotplug events to
  handle, which could confuse the kernel's IRQ machinery.
- Added testing on the SATAII150 TX4.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/sata_promise.c~sata_promise-sata-hotplug-support-take-2 drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-sata-hotplug-support-take-2
+++ a/drivers/ata/sata_promise.c
@@ -773,6 +773,7 @@ static irqreturn_t pdc_interrupt (int ir
 			ata_ehi_hotplugged(ehi);
 			ata_ehi_push_desc(ehi, "hotplug_status %#x", tmp);
 			ata_port_freeze(ap);
+			++handled;
 			continue;
 		}
 
_

Patches currently in -mm which might be from mikpe@it.uu.se are

git-libata-all.patch
sata_promise-sata-hotplug-support.patch
sata_promise-sata-hotplug-support-take-2.patch

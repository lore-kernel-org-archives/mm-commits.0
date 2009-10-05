From: akpm@linux-foundation.org
Subject: [merged] bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:58 -0700
Message-ID: <200910051839.n95Idw4G020163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbZJESkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mbizon@freebox.fr, mm-commits@vger.kernel.org


The patch titled
     bcm63xx_enet: timeout off by one in do_mdio_op()
has been removed from the -mm tree.  Its filename was
     bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bcm63xx_enet: timeout off by one in do_mdio_op()
From: Roel Kluin <roel.kluin@gmail.com>

`while (limit-- >= 0)' reaches -2 after the loop upon timeout.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bcm63xx_enet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/bcm63xx_enet.c~bcm63xx_enet-timeout-off-by-one-in-do_mdio_op drivers/net/bcm63xx_enet.c
--- a/drivers/net/bcm63xx_enet.c~bcm63xx_enet-timeout-off-by-one-in-do_mdio_op
+++ a/drivers/net/bcm63xx_enet.c
@@ -90,7 +90,7 @@ static int do_mdio_op(struct bcm_enet_pr
 		if (enet_readl(priv, ENET_IR_REG) & ENET_IR_MII)
 			break;
 		udelay(1);
-	} while (limit-- >= 0);
+	} while (limit-- > 0);
 
 	return (limit < 0) ? 1 : 0;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
random-kmalloc-failure-ignored-in-init_std_data.patch


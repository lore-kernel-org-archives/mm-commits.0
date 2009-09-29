From: akpm@linux-foundation.org
Subject: + bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch added to -mm tree
Date: Tue, 29 Sep 2009 16:07:46 -0700
Message-ID: <200909292307.n8TN7k73014624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbZI2XHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 19:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mbizon@freebox.fr


The patch titled
     bcm63xx_enet: timeout off by one in do_mdio_op()
has been added to the -mm tree.  Its filename is
     bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch

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
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
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


From: akpm@linux-foundation.org
Subject: - pata_atiixp-simplex-clear.patch removed from -mm tree
Date: Fri, 02 May 2008 15:12:54 -0700
Message-ID: <200805022212.m42MCs9V017556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758019AbYEBWN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_atiixp: simplex clear
has been removed from the -mm tree.  Its filename was
     pata_atiixp-simplex-clear.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_atiixp: simplex clear
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Some of the other quirks changes seem to have left some users with the simplex
bits mis-set by the time the driver loads.  Clear simplex mode before we probe
the controller therefore.

[akpm@linux-foundation.org: fix build after upstream renamed things]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>

On Sat, 29 Mar 2008 12:15:40 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> This patch triggered an audit which led me to... bug city.
> 
> 1) This call occurs before resources are guaranteed to be present, which 
> happens when pci[m]_enable_device() is called.
> 
> 2) Auditing the other ata_pci_clear_simplex() uses, it seems the others 
> are equally broken.
> 
> 3) Further, looking at pata_amd, I notice that the resume code twiddles 
> bits before the PCI device is even bought into D0 state!
> 
> 4) ata_pci_clear_simplex() does its work before resources are mapped, 
> and assumes PCI IDE and PCI BAR #4 behavior.  This works at present, but 
> is less robust than it could be.
> 
> 
> Anyway, my suggestion would be to add a "post-enable" function pointer 
> to ata_pci_init_one() arguments, and call ata_pci_clear_simplex() from 
> that hook.  That would permit this patch and other 
> ata_pci_clear_simplex() callsites to be fixed.
> 
> 	Jeff
> 

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_atiixp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_atiixp.c~pata_atiixp-simplex-clear drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~pata_atiixp-simplex-clear
+++ a/drivers/ata/pata_atiixp.c
@@ -22,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_atiixp"
-#define DRV_VERSION "0.4.6"
+#define DRV_VERSION "0.4.7"
 
 enum {
 	ATIIXP_IDE_PIO_TIMING	= 0x40,
@@ -243,6 +243,9 @@ static int atiixp_init_one(struct pci_de
 		.port_ops = &atiixp_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
+	/* Some of the quirk reconfiguration messes up the simplex flag, so
+	   clear it again */
+	ata_pci_bmdma_clear_simplex(dev);
 	return ata_pci_sff_init_one(dev, ppi, &atiixp_sht, NULL);
 }
 
@@ -279,7 +282,7 @@ static void __exit atiixp_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for ATI IXP200/300/400");
+MODULE_DESCRIPTION("low-level driver for ATI IXP series");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, atiixp);
 MODULE_VERSION(DRV_VERSION);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
sxc-fix-printk-warnings-on-sparc32.patch
git-gfs2-nmw.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch


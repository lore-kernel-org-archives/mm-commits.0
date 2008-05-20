From: akpm@linux-foundation.org
Subject: + 3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch added to -mm tree
Date: Mon, 19 May 2008 20:23:59 -0700
Message-ID: <200805200323.m4K3NxtJ002547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633AbYETDYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:24:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ambx1@neo.rr.com, bjorn.helgaas@hp.com, jeff@garzik.org


The patch titled
     3c515: fix using pnp_get_resource when CONFIG_ISAPNP=n
has been added to the -mm tree.  Its filename is
     3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 3c515: fix using pnp_get_resource when CONFIG_ISAPNP=n
From: Randy Dunlap <randy.dunlap@oracle.com>

3c515.c uses pnp_irq(), which calls pnp_get_resource(), which is not
defined when CONFIG_PNP=n, so in that case, get the IRQ from a hardware
register.

3c515.c:(.text+0x3adc0): undefined reference to `pnp_get_resource'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c515.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/3c515.c~3c515-fix-using-pnp_get_resource-when-config_isapnp=n drivers/net/3c515.c
--- a/drivers/net/3c515.c~3c515-fix-using-pnp_get_resource-when-config_isapnp=n
+++ a/drivers/net/3c515.c
@@ -572,12 +572,16 @@ static int corkscrew_setup(struct net_de
 	int irq;
 	DECLARE_MAC_BUF(mac);
 
+#ifdef __ISAPNP__
 	if (idev) {
 		irq = pnp_irq(idev, 0);
 		vp->dev = &idev->dev;
 	} else {
 		irq = inw(ioaddr + 0x2002) & 15;
 	}
+#else
+	irq = inw(ioaddr + 0x2002) & 15;
+#endif
 
 	dev->base_addr = ioaddr;
 	dev->irq = irq;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch


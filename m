From: akpm@linux-foundation.org
Subject: + rapidio-mpc85xx-fix-possible-mport-registration-problems.patch added to -mm tree
Date: Tue, 12 Apr 2011 16:26:28 -0700
Message-ID: <201104122326.p3CNQSQF009174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab1DLX0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 19:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     RapidIO/mpc85xx: fix possible mport registration problems
has been added to the -mm tree.  Its filename is
     rapidio-mpc85xx-fix-possible-mport-registration-problems.patch

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
Subject: RapidIO/mpc85xx: fix possible mport registration problems
From: Alexandre Bounine <alexandre.bounine@idt.com>

Fix a possible problem with mport registration left non-cleared after
fsl_rio_setup() exits on link error.  Abort mport initialization if
registration failed.

This patch is applicable to 2.6.39-rc1 only.  The problem does not exist
for earlier versions.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    4 +++-
 drivers/rapidio/rio.c         |    5 +++--
 include/linux/rio.h           |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-mpc85xx-fix-possible-mport-registration-problems arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-mpc85xx-fix-possible-mport-registration-problems
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1457,7 +1457,6 @@ int fsl_rio_setup(struct platform_device
 	port->ops = ops;
 	port->priv = priv;
 	port->phys_efptr = 0x100;
-	rio_register_mport(port);
 
 	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
 	rio_regs_win = priv->regs_win;
@@ -1504,6 +1503,9 @@ int fsl_rio_setup(struct platform_device
 	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
 			port->sys_size ? 65536 : 256);
 
+	if (rio_register_mport(port))
+		goto err;
+
 	if (port->host_deviceid >= 0)
 		out_be32(priv->regs_win + RIO_GCCSR, RIO_PORT_GEN_HOST |
 			RIO_PORT_GEN_MASTER | RIO_PORT_GEN_DISCOVERED);
diff -puN drivers/rapidio/rio.c~rapidio-mpc85xx-fix-possible-mport-registration-problems drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-mpc85xx-fix-possible-mport-registration-problems
+++ a/drivers/rapidio/rio.c
@@ -1171,16 +1171,17 @@ static int rio_hdid_setup(char *str)
 
 __setup("riohdid=", rio_hdid_setup);
 
-void rio_register_mport(struct rio_mport *port)
+int rio_register_mport(struct rio_mport *port)
 {
 	if (next_portid >= RIO_MAX_MPORTS) {
 		pr_err("RIO: reached specified max number of mports\n");
-		return;
+		return 1;
 	}
 
 	port->id = next_portid++;
 	port->host_deviceid = rio_get_hdid(port->id);
 	list_add_tail(&port->node, &rio_mports);
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(rio_local_get_device_id);
diff -puN include/linux/rio.h~rapidio-mpc85xx-fix-possible-mport-registration-problems include/linux/rio.h
--- a/include/linux/rio.h~rapidio-mpc85xx-fix-possible-mport-registration-problems
+++ a/include/linux/rio.h
@@ -396,7 +396,7 @@ union rio_pw_msg {
 };
 
 /* Architecture and hardware-specific functions */
-extern void rio_register_mport(struct rio_mport *);
+extern int rio_register_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-mpc85xx-fix-possible-mport-registration-problems.patch


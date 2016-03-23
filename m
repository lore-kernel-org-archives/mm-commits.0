From: akpm@linux-foundation.org
Subject: [merged] powerpc-fsl_rio-changes-to-mport-registration.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:41 -0700
Message-ID: <56f2d555.h6xEuIb3iEq0KyCv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbcCWRlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, benh@kernel.crashing.org, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: changes to mport registration
has been removed from the -mm tree.  Its filename was
     powerpc-fsl_rio-changes-to-mport-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: powerpc/fsl_rio: changes to mport registration

Change mport object initialization/registration sequence to match reworked
version of rio_register_mport() in the core code.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-changes-to-mport-registration arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-changes-to-mport-registration
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -606,6 +606,12 @@ int fsl_rio_setup(struct platform_device
 		if (!port)
 			continue;
 
+		rc = rio_mport_initialize(port);
+		if (rc) {
+			kfree(port);
+			continue;
+		}
+
 		i = *port_index - 1;
 		port->index = (unsigned char)i;
 
@@ -682,12 +688,6 @@ int fsl_rio_setup(struct platform_device
 		dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
 				port->sys_size ? 65536 : 256);
 
-		if (rio_register_mport(port)) {
-			release_resource(&port->iores);
-			kfree(priv);
-			kfree(port);
-			continue;
-		}
 		if (port->host_deviceid >= 0)
 			out_be32(priv->regs_win + RIO_GCCSR, RIO_PORT_GEN_HOST |
 				RIO_PORT_GEN_MASTER | RIO_PORT_GEN_DISCOVERED);
@@ -727,6 +727,12 @@ int fsl_rio_setup(struct platform_device
 
 		dbell->mport[i] = port;
 
+		if (rio_register_mport(port)) {
+			release_resource(&port->iores);
+			kfree(priv);
+			kfree(port);
+			continue;
+		}
 		active_ports++;
 	}
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are



From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:26 -0800
Message-ID: <201111072028.pA7KSQRL020810@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Gang.Liu@freescale.com, alexandre.bounine@idt.com, benh@kernel.crashing.org, grant.likely@secretlab.ca, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/sysdev/fsl_rio.c: release rapidio port I/O region resource if port failed to initialize
has been removed from the -mm tree.  Its filename was
     arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Liu Gang <Gang.Liu@freescale.com>
Subject: arch/powerpc/sysdev/fsl_rio.c: release rapidio port I/O region resource if port failed to initialize

The "struct rio_mport" contains a member of master port I/O memory
resource structure "struct resource iores".  This resource will be read
from device tree and be used for rapidio R/W transaction memory space. 
Rapidio requests the port I/O memory resource under the root resource
"iomem_resource".

			struct rio_mport *port;
			port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);

			request_resource(&iomem_resource, &port->iores);

When port failed to initialize, allocated "rio_mport" structure memory
will be freed, and the port I/O memory resource structure pointer
"&port->iores" will be invalid.  If other requests resource under
"iomem_resource", "&port->iores" node may be operated in the child
resources list and this will cause the system to crash.

So the requested port I/O memory resource should be released before
freeing allocated "rio_mport" structure.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/sysdev/fsl_rio.c~arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1608,6 +1608,7 @@ int fsl_rio_setup(struct platform_device
 	return 0;
 err:
 	iounmap(priv->regs_win);
+	release_resource(&port->iores);
 err_res:
 	kfree(priv);
 err_priv:
_

Patches currently in -mm which might be from Gang.Liu@freescale.com are

origin.patch


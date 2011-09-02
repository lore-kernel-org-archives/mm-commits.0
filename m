From: akpm@linux-foundation.org
Subject: + arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch added to -mm tree
Date: Fri, 02 Sep 2011 16:16:15 -0700
Message-ID: <201109022316.p82NGFiW016321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab1IBXQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 19:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Gang.Liu@freescale.com, alexandre.bounine@idt.com, benh@kernel.crashing.org, grant.likely@secretlab.ca, paulus@samba.org


The patch titled
     arch/powerpc/sysdev/fsl_rio.c: release rapidio port I/O region resource if port failed to initialize
has been added to the -mm tree.  Its filename is
     arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch

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
Subject: arch/powerpc/sysdev/fsl_rio.c: release rapidio port I/O region resource if port failed to initialize
From: Liu Gang <Gang.Liu@freescale.com>

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

arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch
drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch


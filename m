From: akpm@linux-foundation.org
Subject: - cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch removed from -mm tree
Date: Wed, 18 Jul 2007 17:23:48 -0700
Message-ID: <200707190023.l6J0NmWx004747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763173AbXGSAYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcd@tribudubois.net, arnd.bergmann@de.ibm.com, krafft@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cell: allow linux to map Cell regs on legacy SLOF tree.
has been removed from the -mm tree.  Its filename was
     cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cell: allow linux to map Cell regs on legacy SLOF tree.
From: Jean-Christophe DUBOIS <jcd@tribudubois.net>

The platforms missing the "cpus" property in the "be" node are mono-Cell
platforms such as CAB or Getaway.

Therefore it is possible to assume that if there is no "cpus" properties under
the "be" node then we can safely return the "device node" without more
checking.  This is a bit hacky but ...  it allows it to work on these
platforms.

Signed-off-by: Jean-Christophe DUBOIS <jcd@tribudubois.net>
Acked-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_regs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/cell/cbe_regs.c~cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree arch/powerpc/platforms/cell/cbe_regs.c
--- a/arch/powerpc/platforms/cell/cbe_regs.c~cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree
+++ a/arch/powerpc/platforms/cell/cbe_regs.c
@@ -174,9 +174,13 @@ static struct device_node *cbe_get_be_no
 
 		cpu_handle = of_get_property(np, "cpus", &len);
 
+		/*
+		 * the CAB SLOF tree is non compliant, so we just assume
+		 * there is only one node
+		 */
 		if (!cpu_handle) {
 			WARN_ON_ONCE(!cpu_handle);
-			continue;
+			return np;
 		}
 
 		for (i=0; i<len; i++)
_

Patches currently in -mm which might be from jcd@tribudubois.net are

cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch

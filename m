From: akpm@linux-foundation.org
Subject: + cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch added to -mm tree
Date: Wed, 18 Jul 2007 12:52:06 -0700
Message-ID: <200707181952.l6IJq6Tc025931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758979AbXGRTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jcd@tribudubois.net, arnd.bergmann@de.ibm.com, krafft@de.ibm.com


The patch titled
     cell: allow linux to map Cell regs on legacy SLOF tree.
has been added to the -mm tree.  Its filename is
     cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch

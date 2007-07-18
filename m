From: akpm@linux-foundation.org
Subject: + cell-fix-cbe_regc-for-legacy-slof-tree.patch added to -mm tree
Date: Wed, 18 Jul 2007 12:52:02 -0700
Message-ID: <200707181952.l6IJq2m7025925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759012AbXGRTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jcd@tribudubois.net, arnd.bergmann@de.ibm.com, krafft@de.ibm.com


The patch titled
     cell: fix cbe_reg.c for legacy SLOF tree.
has been added to the -mm tree.  Its filename is
     cell-fix-cbe_regc-for-legacy-slof-tree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cell: fix cbe_reg.c for legacy SLOF tree.
From: Jean-Christophe DUBOIS <jcd@tribudubois.net>

Some legacy SLOF device trees have a "be" node but no "cpus" properties under
it.

So let's fix the crash until the device tree is fixed.

Signed-off-by: Jean-Christophe DUBOIS <jcd@tribudubois.net>
Acked-by: Christian Kraff <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_regs.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN arch/powerpc/platforms/cell/cbe_regs.c~cell-fix-cbe_regc-for-legacy-slof-tree arch/powerpc/platforms/cell/cbe_regs.c
--- a/arch/powerpc/platforms/cell/cbe_regs.c~cell-fix-cbe_regc-for-legacy-slof-tree
+++ a/arch/powerpc/platforms/cell/cbe_regs.c
@@ -174,6 +174,11 @@ static struct device_node *cbe_get_be_no
 
 		cpu_handle = of_get_property(np, "cpus", &len);
 
+		if (!cpu_handle) {
+			WARN_ON_ONCE(!cpu_handle);
+			continue;
+		}
+
 		for (i=0; i<len; i++)
 			if (of_find_node_by_phandle(cpu_handle[i]) == of_get_cpu_node(cpu_id, NULL))
 				return np;
_

Patches currently in -mm which might be from jcd@tribudubois.net are

cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch

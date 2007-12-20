From: akpm@linux-foundation.org
Subject: - arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:23 -0800
Message-ID: <200712202337.lBKNbN0r018885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759152AbXLTXsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, djerb@us.ibm.com, krafft@de.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc/platforms/cell/cbe_regs.c: add missing of_node_put
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/powerpc/platforms/cell/cbe_regs.c: add missing of_node_put
From: Julia Lawall <julia@diku.dk>

There should be an of_node_put when breaking out of a loop that iterates
using for_each_node_by_type.

This was detected and fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_node_by_type;
@@

T *d;
...
for_each_node_by_type(d,...)
  {... when != of_node_put(d)
       when != e = d
(
   return d;
|
+  of_node_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christian Krafft <krafft@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Erb <djerb@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_regs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/platforms/cell/cbe_regs.c~arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put arch/powerpc/platforms/cell/cbe_regs.c
--- a/arch/powerpc/platforms/cell/cbe_regs.c~arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put
+++ a/arch/powerpc/platforms/cell/cbe_regs.c
@@ -256,6 +256,7 @@ void __init cbe_regs_init(void)
 			printk(KERN_ERR "cbe_regs: More BE chips than supported"
 			       "!\n");
 			cbe_regs_map_count--;
+			of_node_put(cpu);
 			return;
 		}
 		map->cpu_node = cpu;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
git-agpgart.patch
git-powerpc.patch
git-input.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch

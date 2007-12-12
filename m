From: akpm@linux-foundation.org
Subject: + arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:31:25 -0800
Message-ID: <200712121031.lBCAVP1v005277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366AbXLLKbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 05:31:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, djerb@us.ibm.com, krafft@de.ibm.com, paulus@samba.org


The patch titled
     arch/powerpc/platforms/cell/cbe_regs.c: add missing of_node_put
has been added to the -mm tree.  Its filename is
     arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
arch-powerpc-add-missing-of_node_put.patch
arch-powerpc-platforms-cell-cbe_regsc-add-missing-of_node_put.patch
git-input.patch
drivers-video-remove-unnecessary-pci_dev_put.patch

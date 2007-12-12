From: akpm@linux-foundation.org
Subject: + arch-powerpc-add-missing-of_node_put.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:11:52 -0800
Message-ID: <200712121011.lBCABqMG004539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423AbXLLKMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 05:12:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     arch/powerpc: add missing of_node_put
has been added to the -mm tree.  Its filename is
     arch-powerpc-add-missing-of_node_put.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/powerpc: add missing of_node_put
From: Julia Lawall <julia@diku.dk>

There should be an of_node_put when breaking out of a loop that iterates
over calls to of_find_all_nodes, as this function does an of_node_get on
the value it returns.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier d;
expression e;
@@

T *d;
...
for (d = NULL; (d = of_find_all_nodes(d)) != NULL; )
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/iseries/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/iseries/iommu.c~arch-powerpc-add-missing-of_node_put arch/powerpc/platforms/iseries/iommu.c
--- a/arch/powerpc/platforms/iseries/iommu.c~arch-powerpc-add-missing-of_node_put
+++ a/arch/powerpc/platforms/iseries/iommu.c
@@ -163,8 +163,10 @@ static struct iommu_table *iommu_table_f
 		    (it->it_type == TCE_PCI) &&
 		    (it->it_offset == tbl->it_offset) &&
 		    (it->it_index == tbl->it_index) &&
-		    (it->it_size == tbl->it_size))
+		    (it->it_size == tbl->it_size)) {
+			of_node_put(node);
 			return it;
+		}
 	}
 	return NULL;
 }
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
arch-powerpc-add-missing-of_node_put.patch
git-input.patch
drivers-video-remove-unnecessary-pci_dev_put.patch

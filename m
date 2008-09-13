From: akpm@linux-foundation.org
Subject: - arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:52 -0700
Message-ID: <200809130745.m8D7jqJk026797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139AbYIMHp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64/sn/pci/tioca_provider.c: introduce missing kfree
has been removed from the -mm tree.  Its filename was
     arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/ia64/sn/pci/tioca_provider.c: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/pci/tioca_provider.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/ia64/sn/pci/tioca_provider.c~arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree arch/ia64/sn/pci/tioca_provider.c
--- a/arch/ia64/sn/pci/tioca_provider.c~arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree
+++ a/arch/ia64/sn/pci/tioca_provider.c
@@ -420,8 +420,10 @@ tioca_dma_mapped(struct pci_dev *pdev, u
 		entry = find_next_zero_bit(map, mapsize, last_entry);
 	}
 
-	if (entry > mapsize)
+	if (entry > mapsize) {
+		kfree(ca_dmamap);
 		goto map_return;
+	}
 
 	for (i = 0; i < entries; i++)
 		set_bit(entry + i, map);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-infiniband-hw-drop-code-after-return.patch
drivers-atm-use-div_round_up.patch
net-atm-lecc-drop-code-after-return.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-dma-ioat_dmac-drop-code-after-return.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
net-9p-trans_fdc-introduce-missing-kfree.patch
fs-9p-use-an-is_err-test-rather-than-a-null-test.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch


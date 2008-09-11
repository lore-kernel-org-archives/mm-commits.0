From: akpm@linux-foundation.org
Subject: + arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch added to -mm tree
Date: Thu, 11 Sep 2008 11:55:10 -0700
Message-ID: <200809111855.m8BItAY2011089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYIKSzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 14:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, tony.luck@intel.com


The patch titled
     arch/ia64/sn/pci/tioca_provider.c: introduce missing kfree
has been added to the -mm tree.  Its filename is
     arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch
arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch
drivers-atm-use-div_round_up.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch


From: akpm@linux-foundation.org
Subject: + missing-critical-phys_to_virt-in-lib-swiotlbc.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:36:04 -0800
Message-ID: <200702052136.l15La4ie031878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbXBEVh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcm@acm.org, ak@suse.de, jbeulich@novell.com, stable@kernel.org, tony.luck@intel.com


The patch titled
     Missing critical phys_to_virt in lib/swiotlb.c
has been added to the -mm tree.  Its filename is
     missing-critical-phys_to_virt-in-lib-swiotlbc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Missing critical phys_to_virt in lib/swiotlb.c
From: David Moore <dcm@acm.org>

Adds missing call to phys_to_virt() in the lib/swiotlb.c:swiotlb_sync_sg()
function.  Without this change, a kernel panic will always occur whenever a
SWIOTLB bounce buffer from a scatter-gather list gets synced.

This change was originally part of a larger patch by Jan Beulich, which
was more extensive and doesn't look destined to make it into 2.6.20:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/ia64-swiotlb-bug-fixes.patch

However, considering the severity of this one-liner bug, I would like to
request that this simplified patch make it into 2.6.20, despite how
close we are to the final cut.  It fixes real crashes:
http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
http://qa.mandriva.com/show_bug.cgi?id=28224
http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce

Signed-off-by: David Moore <dcm@acm.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/swiotlb.c~missing-critical-phys_to_virt-in-lib-swiotlbc lib/swiotlb.c
--- a/lib/swiotlb.c~missing-critical-phys_to_virt-in-lib-swiotlbc
+++ a/lib/swiotlb.c
@@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, (void *) sg->dma_address,
+			sync_single(hwdev, phys_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 }
 
_

Patches currently in -mm which might be from dcm@acm.org are

missing-critical-phys_to_virt-in-lib-swiotlbc.patch

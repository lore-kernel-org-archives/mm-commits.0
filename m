From: akpm@osdl.org
Subject: - lumpy-take-the-other-active-inactive-pages-in-the-area.patch removed from -mm tree
Date: Mon, 11 Dec 2006 14:44:58 -0800
Message-ID: <200612112244.kBBMiwPF011054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937709AbWLKWpb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:45:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lumpy take the other active inactive pages in the area
has been removed from the -mm tree.  Its filename was
     lumpy-take-the-other-active-inactive-pages-in-the-area.patch

This patch was dropped because it was folded into lumpy-reclaim-v2.patch

------------------------------------------------------
Subject: lumpy take the other active inactive pages in the area
From: Andy Whitcroft <apw@shadowen.org>

When we scan an order N aligned area around our tag page take any other pages
with a matching active state to that of the tag page.  This will tend to
demote areas of the order we are interested from the active list to the
inactive list and from the end of the inactive list, increasing the chances of
such areas coming free together.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmscan.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmscan.c~lumpy-take-the-other-active-inactive-pages-in-the-area mm/vmscan.c
--- a/mm/vmscan.c~lumpy-take-the-other-active-inactive-pages-in-the-area
+++ a/mm/vmscan.c
@@ -709,7 +709,7 @@ static unsigned long isolate_lru_pages(u
 			case 0:
 				list_move(&tmp->lru, dst);
 				nr_taken++;
-				continue;
+				break;
 
 			case -EBUSY:
 				/* else it is being freed elsewhere */
@@ -717,7 +717,6 @@ static unsigned long isolate_lru_pages(u
 			default:
 				break;
 			}
-			break;
 		}
 	}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
lumpy-reclaim-v2.patch
lumpy-take-the-other-active-inactive-pages-in-the-area.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch


From: akpm@linux-foundation.org
Subject: + mm-sync-vmalloc-address-space-page-tables-in-alloc_vm_area.patch added to -mm tree
Date: Fri, 02 Sep 2011 15:32:09 -0700
Message-ID: <201109022232.p82MW9OT014417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1IBWcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 18:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.vrabel@citrix.com, Ian.Campbell@citrix.com, jeremy.fitzhardinge@citrix.com, keir.xen@gmail.com, konrad.wilk@oracle.com, stable@kernel.org


The patch titled
     mm: sync vmalloc address space page tables in alloc_vm_area()
has been added to the -mm tree.  Its filename is
     mm-sync-vmalloc-address-space-page-tables-in-alloc_vm_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: sync vmalloc address space page tables in alloc_vm_area()
From: David Vrabel <david.vrabel@citrix.com>

Xen backend drivers (e.g., blkback and netback) would sometimes fail to
map grant pages into the vmalloc address space allocated with
alloc_vm_area().  The GNTTABOP_map_grant_ref would fail because Xen could
not find the page (in the L2 table) containing the PTEs it needed to
update.

(XEN) mm.c:3846:d0 Could not find L1 PTE for address fbb42000

netback and blkback were making the hypercall from a kernel thread where
task->active_mm != &init_mm and alloc_vm_area() was only updating the page
tables for init_mm.  The usual method of deferring the update to the page
tables of other processes (i.e., after taking a fault) doesn't work as a
fault cannot occur during the hypercall.

This would work on some systems depending on what else was using vmalloc.

Fix this by reverting ef691947d8a3 ("vmalloc: remove vmalloc_sync_all()
from alloc_vm_area()") and add a comment to explain why it's needed.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Keir Fraser <keir.xen@gmail.com>
Cc: <stable@kernel.org>		[3.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmalloc.c~mm-sync-vmalloc-address-space-page-tables-in-alloc_vm_area mm/vmalloc.c
--- a/mm/vmalloc.c~mm-sync-vmalloc-address-space-page-tables-in-alloc_vm_area
+++ a/mm/vmalloc.c
@@ -2176,6 +2176,14 @@ struct vm_struct *alloc_vm_area(size_t s
 		return NULL;
 	}
 
+	/*
+	 * If the allocated address space is passed to a hypercall
+	 * before being used then we cannot rely on a page fault to
+	 * trigger an update of the page tables.  So sync all the page
+	 * tables here.
+	 */
+	vmalloc_sync_all();
+
 	return area;
 }
 EXPORT_SYMBOL_GPL(alloc_vm_area);
_

Patches currently in -mm which might be from david.vrabel@citrix.com are

mm-sync-vmalloc-address-space-page-tables-in-alloc_vm_area.patch


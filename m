From: akpm@linux-foundation.org
Subject: + nommu-correct-kobjsize-page-validity-checks.patch added to -mm tree
Date: Thu, 12 Jun 2008 00:51:30 -0700
Message-ID: <200806120751.m5C7pUxq008535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbYFLHwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 03:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, clameter@sgi.com, cooloney@kernel.org, dhowells@redhat.com, penberg@cs.helsinki.fi


The patch titled
     nommu: correct kobjsize() page validity checks.
has been added to the -mm tree.  Its filename is
     nommu-correct-kobjsize-page-validity-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: correct kobjsize() page validity checks.
From: Paul Mundt <lethal@linux-sh.org>

This implements a few changes on top of the recent kobjsize() refactoring
introduced by

commit 6cfd53fc03670c7a544a56d441eb1a6cc800d72b
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Thu Jun 5 22:46:08 2008 -0700

    nommu: fix kobjsize() for SLOB and SLUB
    


As Christoph points out:

	virt_to_head_page cannot return NULL. virt_to_page also
	does not return NULL. pfn_valid() needs to be used to
	figure out if a page is valid.  Otherwise the page struct
	reference that was returned may have PageReserved() set
	to indicate that it is not a valid page.

As discussed further in the thread, virt_addr_valid() is the preferable
way to validate the object pointer in this case.  In addition to fixing up
the reserved page case, it also has the benefit of encapsulating the hack
introduced by commit 4016a1390d07f15b267eecb20e76a48fd5c524ef on the
impacted platforms, allowing us to get rid of the extra checking in
kobjsize() for the platforms that don't perform this type of bizarre
memory_end abuse (every nommu platform that isn't blackfin).  If blackfin
decides to get in line with every other platform and use PageReserved for
the DMA pages in question, kobjsize() will also continue to work fine.

It also turns out that compound_order() will give us back 0-order for
non-head pages, so we can get rid of the PageCompound check and just use
compound_order() directly.  Clean that up while we're at it.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff -puN mm/nommu.c~nommu-correct-kobjsize-page-validity-checks mm/nommu.c
--- a/mm/nommu.c~nommu-correct-kobjsize-page-validity-checks
+++ a/mm/nommu.c
@@ -104,21 +104,15 @@ EXPORT_SYMBOL(vmtruncate);
 unsigned int kobjsize(const void *objp)
 {
 	struct page *page;
-	int order = 0;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp)
-		return 0;
-
-	if ((unsigned long)objp >= memory_end)
+	if (!objp || !virt_addr_valid(objp))
 		return 0;
 
 	page = virt_to_head_page(objp);
-	if (!page)
-		return 0;
 
 	/*
 	 * If the allocator sets PageSlab, we know the pointer came from
@@ -129,18 +123,9 @@ unsigned int kobjsize(const void *objp)
 
 	/*
 	 * The ksize() function is only guaranteed to work for pointers
-	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
-	 * always to be compound pages, here.
-	 */
-	if (PageCompound(page))
-		order = compound_order(page);
-
-	/*
-	 * Finally, handle arbitrary pointers that don't set PageSlab.
-	 * Default to 0-order in the case when we're unable to ksize()
-	 * the object.
+	 * returned by kmalloc(). So handle arbitrary pointers here.
 	 */
-	return PAGE_SIZE << order;
+	return PAGE_SIZE << compound_order(page);
 }
 
 /*
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
nommu-correct-kobjsize-page-validity-checks.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
smc911x-remove-unused-8-bit-i-o-operations.patch
smc911x-fix-16-bit-i-o-operations.patch
smc911x-pass-along-private-data-and-use-iomem.patch
smc911x-introduce-platform-data-flags.patch
smc911x-superh-architecture-support.patch
net-sh_eth-add-support-for-renesas-superh-ethernet.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
lib-taint-kernel-in-common-report_bug-warn-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch


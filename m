From: akpm@linux-foundation.org
Subject: - nommu-fix-kobjsize-for-slob-and-slub-v2.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:30 -0700
Message-ID: <200806081947.m58JlUjT017424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbYFHTsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, dhowells@redhat.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nommu: fix kobjsize() for SLOB and SLUB
has been removed from the -mm tree.  Its filename was
     nommu-fix-kobjsize-for-slob-and-slub-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix kobjsize() for SLOB and SLUB
From: Paul Mundt <lethal@linux-sh.org>

kobjsize() has been abusing page->index as a method for sorting out
compound order, which blows up both for page cache pages, and SLOB's
reuse of the index in struct slob_page.

Presently we are not able to accurately size arbitrary pointers that
don't come from kmalloc(), so the best we can do is sort out the
compound order from the head page if it's a compound page, or default
to 0-order if it's impossible to ksize() the object.

Obviously this leaves quite a bit to be desired in terms of object
sizing accuracy, but the behaviour is unchanged over the existing
implementation, while fixing the page->index oopses originally reported
here:

	http://marc.info/?l=linux-mm&m=121127773325245&w=2

Accuracy could also be improved by having SLUB and SLOB both set PG_slab
on ksizeable pages, rather than just handling the __GFP_COMP cases
irregardless of the PG_slab setting, as made possibly with Pekka's
patches:

	http://marc.info/?l=linux-kernel&m=121139439900534&w=2
	http://marc.info/?l=linux-kernel&m=121139440000537&w=2
	http://marc.info/?l=linux-kernel&m=121139440000540&w=2

This is primarily a bugfix for nommu systems for 2.6.26, with the aim
being to gradually kill off kobjsize() and its particular brand of
object abuse entirely.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~nommu-fix-kobjsize-for-slob-and-slub-v2 mm/nommu.c
--- a/mm/nommu.c~nommu-fix-kobjsize-for-slob-and-slub-v2
+++ a/mm/nommu.c
@@ -104,21 +104,43 @@ EXPORT_SYMBOL(vmtruncate);
 unsigned int kobjsize(const void *objp)
 {
 	struct page *page;
+	int order = 0;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
+	if (!objp)
 		return 0;
 
+	if ((unsigned long)objp >= memory_end)
+		return 0;
+
+	page = virt_to_head_page(objp);
+	if (!page)
+		return 0;
+
+	/*
+	 * If the allocator sets PageSlab, we know the pointer came from
+	 * kmalloc().
+	 */
 	if (PageSlab(page))
 		return ksize(objp);
 
-	BUG_ON(page->index < 0);
-	BUG_ON(page->index >= MAX_ORDER);
+	/*
+	 * The ksize() function is only guaranteed to work for pointers
+	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
+	 * always to be compound pages, here.
+	 */
+	if (PageCompound(page))
+		order = compound_order(page);
 
-	return (PAGE_SIZE << page->index);
+	/*
+	 * Finally, handle arbitrary pointers that don't set PageSlab.
+	 * Default to 0-order in the case when we're unable to ksize()
+	 * the object.
+	 */
+	return PAGE_SIZE << order;
 }
 
 /*
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
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
net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
lib-taint-kernel-in-common-report_bug-warn-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch


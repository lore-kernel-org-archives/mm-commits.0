From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:49:32 -0700
Message-ID: <56eb185c.nBgMmq0RxQijW0yS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936842AbcCQUtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch

This patch was dropped because it was folded into mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix

update comment, per David.  Adjust comment to use 80 cols

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix
+++ a/mm/vmalloc.c
@@ -531,17 +531,16 @@ static void unmap_vmap_area(struct vmap_
 static void vmap_debug_free_range(unsigned long start, unsigned long end)
 {
 	/*
-	 * Unmap page tables and force a TLB flush immediately if
-	 * CONFIG_DEBUG_PAGEALLOC is set. This catches use after free
-	 * bugs similarly to those in linear kernel virtual address
-	 * space after a page has been freed.
+	 * Unmap page tables and force a TLB flush immediately if pagealloc
+	 * debugging is enabled.  This catches use after free bugs similarly to
+	 * those in linear kernel virtual address space after a page has been
+	 * freed.
 	 *
-	 * All the lazy freeing logic is still retained, in order to
-	 * minimise intrusiveness of this debugging feature.
+	 * All the lazy freeing logic is still retained, in order to minimise
+	 * intrusiveness of this debugging feature.
 	 *
-	 * This is going to be *slow* (linear kernel virtual address
-	 * debugging doesn't do a broadcast TLB flush so it is a lot
-	 * faster).
+	 * This is going to be *slow* (linear kernel virtual address debugging
+	 * doesn't do a broadcast TLB flush so it is a lot faster).
 	 */
 	if (debug_pagealloc_enabled()) {
 		vunmap_page_range(start, end);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch


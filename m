From: akpm@linux-foundation.org
Subject: - slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:45:54 -0800
Message-ID: <200702112245.l1BMjswW015452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59452 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbXBKWqB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab: remove broken PageSlab check from kfree_debugcheck
has been removed from the -mm tree.  Its filename was
     slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove broken PageSlab check from kfree_debugcheck
From: Pekka Enberg <penberg@cs.helsinki.fi>

The PageSlab debug check in kfree_debugcheck() is broken for compound
pages.  It is also redundant as we already do BUG_ON for non-slab pages in
page_get_cache() and page_get_slab() which are always called before we free
any actual objects.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/slab.c~slab-remove-broken-pageslab-check-from-kfree_debugcheck mm/slab.c
--- a/mm/slab.c~slab-remove-broken-pageslab-check-from-kfree_debugcheck
+++ a/mm/slab.c
@@ -2814,19 +2814,11 @@ failed:
  */
 static void kfree_debugcheck(const void *objp)
 {
-	struct page *page;
-
 	if (!virt_addr_valid(objp)) {
 		printk(KERN_ERR "kfree_debugcheck: out of range ptr %lxh.\n",
 		       (unsigned long)objp);
 		BUG();
 	}
-	page = virt_to_page(objp);
-	if (!PageSlab(page)) {
-		printk(KERN_ERR "kfree_debugcheck: bad ptr %lxh.\n",
-		       (unsigned long)objp);
-		BUG();
-	}
 }
 
 static inline void verify_redzone_free(struct kmem_cache *cache, void *obj)
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch

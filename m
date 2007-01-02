From: akpm@osdl.org
Subject: + slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:33:05 -0800
Message-ID: <200701022333.l02NX62I001260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44431 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbXABXdR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     slab: remove broken PageSlab check from kfree_debugcheck
has been added to the -mm tree.  Its filename is
     slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: remove broken PageSlab check from kfree_debugcheck
From: Pekka Enberg <penberg@cs.helsinki.fi>

The PageSlab debug check in kfree_debugcheck() is broken for compound
pages.  It is also redundant as we already do BUG_ON for non-slab pages in
page_get_cache() and page_get_slab() which are always called before we free
any actual objects.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    8 --------
 1 files changed, 8 deletions(-)

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

slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch
slab-leaks3-default-y.patch

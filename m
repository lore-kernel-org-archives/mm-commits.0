From: akpm@linux-foundation.org
Subject: - slob-fix-page-order-calculation-on-not-4kb-page.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:30 -0700
Message-ID: <200705080004.l4804U7Z009018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967371AbXEHAGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mpm@selenic.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     slob: fix page order calculation on not 4KB page
has been removed from the -mm tree.  Its filename was
     slob-fix-page-order-calculation-on-not-4kb-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slob: fix page order calculation on not 4KB page
From: Akinobu Mita <akinobu.mita@gmail.com>

SLOB doesn't calculate correct page order when page size is not 4KB.  This
patch fixes it with using get_order() instead of find_order() which is SLOB
version of get_order().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN mm/slob.c~slob-fix-page-order-calculation-on-not-4kb-page mm/slob.c
--- a/mm/slob.c~slob-fix-page-order-calculation-on-not-4kb-page
+++ a/mm/slob.c
@@ -150,15 +150,6 @@ static void slob_free(void *block, int s
 	spin_unlock_irqrestore(&slob_lock, flags);
 }
 
-static int FASTCALL(find_order(int size));
-static int fastcall find_order(int size)
-{
-	int order = 0;
-	for ( ; size > 4096 ; size >>=1)
-		order++;
-	return order;
-}
-
 void *__kmalloc(size_t size, gfp_t gfp)
 {
 	slob_t *m;
@@ -174,7 +165,7 @@ void *__kmalloc(size_t size, gfp_t gfp)
 	if (!bb)
 		return 0;
 
-	bb->order = find_order(size);
+	bb->order = get_order(size);
 	bb->pages = (void *)__get_free_pages(gfp, bb->order);
 
 	if (bb->pages) {
@@ -318,7 +309,7 @@ void *kmem_cache_alloc(struct kmem_cache
 	if (c->size < PAGE_SIZE)
 		b = slob_alloc(c->size, flags, c->align);
 	else
-		b = (void *)__get_free_pages(flags, find_order(c->size));
+		b = (void *)__get_free_pages(flags, get_order(c->size));
 
 	if (c->ctor)
 		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
@@ -345,7 +336,7 @@ void kmem_cache_free(struct kmem_cache *
 	if (c->size < PAGE_SIZE)
 		slob_free(b, c->size);
 	else
-		free_pages((unsigned long)b, find_order(c->size));
+		free_pages((unsigned long)b, get_order(c->size));
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch

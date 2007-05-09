From: akpm@linux-foundation.org
Subject: - slub-consolidate-trace-code.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:07 -0700
Message-ID: <200705092148.l49Lm7W3002545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757070AbXEIVsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: consolidate trace code
has been removed from the -mm tree.  Its filename was
     slub-consolidate-trace-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: consolidate trace code
From: Christoph Lameter <clameter@sgi.com>

Trace in both slab_alloc and slab_free has a lot of common code.  Use a single
function for both.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~slub-consolidate-trace-code mm/slub.c
--- a/mm/slub.c~slub-consolidate-trace-code
+++ a/mm/slub.c
@@ -805,6 +805,22 @@ fail:
 	return 0;
 }
 
+static void trace(struct kmem_cache *s, struct page *page, void *object, int alloc)
+{
+	if (s->flags & SLAB_TRACE) {
+		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
+			s->name,
+			alloc ? "alloc" : "free",
+			object, page->inuse,
+			page->freelist);
+
+		if (!alloc)
+			print_section("Object", (void *)object, s->objsize);
+
+		dump_stack();
+	}
+}
+
 /*
  * Slab allocation and freeing
  */
@@ -1289,12 +1305,7 @@ debug:
 		goto another_slab;
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_ALLOC, addr);
-	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
-			s->name, object, page->inuse,
-			page->freelist);
-		dump_stack();
-	}
+	trace(s, page, object, 1);
 	init_object(s, object, 1);
 	goto have_object;
 }
@@ -1379,13 +1390,7 @@ debug:
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, x, TRACK_FREE, addr);
-	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s free 0x%p inuse=%d fp=0x%p\n",
-			s->name, object, page->inuse,
-			page->freelist);
-		print_section("Object", (void *)object, s->objsize);
-		dump_stack();
-	}
+	trace(s, page, object, 0);
 	init_object(s, object, 0);
 	goto checks_ok;
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch

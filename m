From: akpm@linux-foundation.org
Subject: + slub-bulk-allocation-from-per-cpu-partial-pages.patch added to
 -mm tree
Date: Thu, 09 Apr 2015 13:23:07 -0700
Message-ID: <5526dfab.dwWQN4k43p0/PzHz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbbDIUXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 16:23:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: bulk allocation from per cpu partial pages
has been added to the -mm tree.  Its filename is
     slub-bulk-allocation-from-per-cpu-partial-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-bulk-allocation-from-per-cpu-partial-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-bulk-allocation-from-per-cpu-partial-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: bulk allocation from per cpu partial pages

Cover all of the per cpu objects available.

Expand the bulk allocation support to drain the per cpu partial pages
while interrupts are off.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-bulk-allocation-from-per-cpu-partial-pages mm/slub.c
--- a/mm/slub.c~slub-bulk-allocation-from-per-cpu-partial-pages
+++ a/mm/slub.c
@@ -2769,15 +2769,45 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 		while (size) {
 			void *object = c->freelist;
 
-			if (!object)
-				break;
+			if (unlikely(!object)) {
+				/*
+				 * Check if there remotely freed objects
+				 * availalbe in the page.
+				 */
+				object = get_freelist(s, c->page);
+
+				if (!object) {
+					/*
+					 * All objects in use lets check if
+					 * we have other per cpu partial
+					 * pages that have available
+					 * objects.
+					 */
+					c->page = c->partial;
+					if (!c->page) {
+						/* No per cpu objects left */
+						c->freelist = NULL;
+						break;
+					}
+
+					/* Next per cpu partial page */
+					c->partial = c->page->next;
+					c->freelist = get_freelist(s,
+							c->page);
+					continue;
+				}
+
+			}
+
 
-			c->freelist = get_freepointer(s, object);
 			*p++ = object;
 			size--;
 
 			if (unlikely(flags & __GFP_ZERO))
 				memset(object, 0, s->object_size);
+
+			c->freelist = get_freepointer(s, object);
+
 		}
 		c->tid = next_tid(c->tid);
 
_

Patches currently in -mm which might be from cl@linux.com are

mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
linux-next.patch


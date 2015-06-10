From: akpm@linux-foundation.org
Subject: [failures] slub-bulk-allocation-from-per-cpu-partial-pages.patch
 removed from -mm tree
Date: Wed, 10 Jun 2015 12:31:17 -0700
Message-ID: <55789085.rWHYQkmiIQmqnR3j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbbFJTbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 15:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: bulk allocation from per cpu partial pages
has been removed from the -mm tree.  Its filename was
     slub-bulk-allocation-from-per-cpu-partial-pages.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: bulk allocation from per cpu partial pages

Cover all of the per cpu objects available.

Expand the bulk allocation support to drain the per cpu partial pages
while interrupts are off.

[akpm@linux-foundation.org: fix comments, code layout]
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-bulk-allocation-from-per-cpu-partial-pages mm/slub.c
--- a/mm/slub.c~slub-bulk-allocation-from-per-cpu-partial-pages
+++ a/mm/slub.c
@@ -2769,15 +2769,42 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 		while (size) {
 			void *object = c->freelist;
 
-			if (!object)
-				break;
+			if (unlikely(!object)) {
+				/*
+				 * Check if there are remotely freed objects
+				 * available in the page.
+				 */
+				object = get_freelist(s, c->page);
+
+				if (!object) {
+					/*
+					 * All objects in use.  Let's check if
+					 * we have other per cpu partial pages
+					 * that have available objects.
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
+					c->freelist = get_freelist(s, c->page);
+					continue;
+				}
+
+			}
 
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

mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch
linux-slabh-fix-three-off-by-one-typos-in-comment.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
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
linux-next.patch


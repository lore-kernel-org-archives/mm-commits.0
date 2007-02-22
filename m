From: akpm@linux-foundation.org
Subject: + slab-ensure-cache_alloc_refill-terminates.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:55:50 -0800
Message-ID: <200702220055.l1M0toeW032057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780AbXBVA4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:56:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, mcr@sandelman.ca


The patch titled
     slab: ensure cache_alloc_refill terminates
has been added to the -mm tree.  Its filename is
     slab-ensure-cache_alloc_refill-terminates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: ensure cache_alloc_refill terminates
From: Pekka Enberg <penberg@cs.helsinki.fi>

If slab->inuse is corrupted, cache_alloc_refill can enter an infinite
loop as detailed by Michael Richardson in the following post:
<http://lkml.org/lkml/2007/2/16/292>. This adds a BUG_ON to catch
those cases.

Cc: Michael Richardson <mcr@sandelman.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN mm/slab.c~slab-ensure-cache_alloc_refill-terminates mm/slab.c
--- a/mm/slab.c~slab-ensure-cache_alloc_refill-terminates
+++ a/mm/slab.c
@@ -2987,6 +2987,14 @@ retry:
 		slabp = list_entry(entry, struct slab, list);
 		check_slabp(cachep, slabp);
 		check_spinlock_acquired(cachep);
+
+		/*
+		 * The slab was either on partial or free list so
+		 * there must be at least one object available for
+		 * allocation.
+		 */
+		BUG_ON(slabp->inuse < 0 || slabp->inuse >= cachep->num);
+
 		while (slabp->inuse < cachep->num && batchcount--) {
 			STATS_INC_ALLOCED(cachep);
 			STATS_INC_ACTIVE(cachep);
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-ensure-cache_alloc_refill-terminates.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch

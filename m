From: akpm@linux-foundation.org
Subject: - slab-fix-slab-debug-for-non-alien-caches.patch removed from -mm tree
Date: Mon, 04 Jun 2007 17:58:03 -0700
Message-ID: <200706050058.l550w2nq026498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867AbXFEA6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 20:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] slab: Fix slab debug for non alien caches.
has been removed from the -mm tree.  Its filename was
     slab-fix-slab-debug-for-non-alien-caches.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: Subject: [PATCH] slab: Fix slab debug for non alien caches.
From: Paul Mundt <lethal@linux-sh.org>

Currently when slab debugging is enabled, the WARN_ON() nodeid checks
trigger if we boot with 'noaliencache'.  In the noaliencache case the
WARN_ON()'s seem to be superfluous, so only bother doing the nodeid
comparison if use_alien_caches is set.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-fix-slab-debug-for-non-alien-caches mm/slab.c
--- a/mm/slab.c~slab-fix-slab-debug-for-non-alien-caches
+++ a/mm/slab.c
@@ -2663,7 +2663,7 @@ static void *slab_get_obj(struct kmem_ca
 	next = slab_bufctl(slabp)[slabp->free];
 #if DEBUG
 	slab_bufctl(slabp)[slabp->free] = BUFCTL_FREE;
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(use_alien_caches && slabp->nodeid != nodeid);
 #endif
 	slabp->free = next;
 
@@ -2677,7 +2677,7 @@ static void slab_put_obj(struct kmem_cac
 
 #if DEBUG
 	/* Verify that the slab belongs to the intended node */
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(use_alien_caches && slabp->nodeid != nodeid);
 
 	if (slab_bufctl(slabp)[objnr] + 1 <= SLAB_LIMIT + 1) {
 		printk(KERN_ERR "slab: double free detected in cache "
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-sh.patch
slab-fix-slab-debug-for-non-alien-caches.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch

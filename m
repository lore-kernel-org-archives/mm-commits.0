From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-idrc-zero-memory-properly-in-idr_remove_all.patch removed from -mm tree
Date: Wed, 14 Jan 2009 09:45:22 -0800
Message-ID: <200901141745.n0EHjMRc018763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284AbZANRqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 12:46:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcm@acm.org, Nadia.Derbey@bull.net, manfred@colorfullife.com, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     lib/idr.c: zero memory properly in idr_remove_all
has been removed from the -mm tree.  Its filename was
     lib-idrc-zero-memory-properly-in-idr_remove_all.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/idr.c: zero memory properly in idr_remove_all
From: David Moore <dcm@acm.org>

The idr_remove_all() function returns unused slabs to the kmem cache, but
needs to zero them first or else they will be uninitialized upon next use.
This fixes crashes which have been observed in the firewire subsystem.

Signed-off-by: David Moore <dcm@acm.org>
Tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~lib-idrc-zero-memory-properly-in-idr_remove_all lib/idr.c
--- a/lib/idr.c~lib-idrc-zero-memory-properly-in-idr_remove_all
+++ a/lib/idr.c
@@ -65,6 +65,20 @@ static inline void free_layer(struct idr
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
 
+static void idr_layer_rcu_free_zero(struct rcu_head *head)
+{
+	struct idr_layer *layer;
+
+	layer = container_of(head, struct idr_layer, rcu_head);
+	memset(layer, 0, sizeof(struct idr_layer));
+	kmem_cache_free(idr_layer_cache, layer);
+}
+
+static inline void free_layer_zero(struct idr_layer *p)
+{
+	call_rcu(&p->rcu_head, idr_layer_rcu_free_zero);
+}
+
 /* only called when idp->lock is held */
 static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
@@ -462,7 +476,7 @@ void idr_remove_all(struct idr *idp)
 		id += 1 << n;
 		while (n < fls(id)) {
 			if (p)
-				free_layer(p);
+				free_layer_zero(p);
 			n += IDR_BITS;
 			p = *--paa;
 		}
_

Patches currently in -mm which might be from dcm@acm.org are

lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
linux-next.patch
lib-idrc-zero-memory-properly-in-idr_remove_all.patch


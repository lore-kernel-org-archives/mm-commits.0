From: akpm@linux-foundation.org
Subject: [merged] slub-min-order-when-debug_guardpage_minorder-0.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:01 -0800
Message-ID: <20120111212701.B458310004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:58611 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab2AKV1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:02 -0500
Received: by yhpp56 with SMTP id p56so153744yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, aarcange@redhat.com, cl@linux.com, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: min order when debug_guardpage_minorder > 0
has been removed from the -mm tree.  Its filename was
     slub-min-order-when-debug_guardpage_minorder-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: slub: min order when debug_guardpage_minorder > 0

Disable slub debug facilities and allocate slabs at minimal order when
debug_guardpage_minorder > 0 to increase probability to catch random
memory corruption by cpu exception.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/slub.c~slub-min-order-when-debug_guardpage_minorder-0 mm/slub.c
--- a/mm/slub.c~slub-min-order-when-debug_guardpage_minorder-0
+++ a/mm/slub.c
@@ -3654,6 +3654,9 @@ void __init kmem_cache_init(void)
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
 
+	if (debug_guardpage_minorder())
+		slub_max_order = 0;
+
 	kmem_size = offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *);
 
_

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch


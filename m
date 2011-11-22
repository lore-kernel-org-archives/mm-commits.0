From: akpm@linux-foundation.org
Subject: + slub-min-order-when-debug_guardpage_minorder-0.patch added to -mm tree
Date: Tue, 22 Nov 2011 13:57:07 -0800
Message-ID: <201111222157.pAMLv8J1028949@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:35208 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1KVV5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 16:57:12 -0500
Received: by fabs1 with SMTP id s1so30705fab.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 13:57:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, aarcange@redhat.com, cl@linux.com, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl


The patch titled
     Subject: slub: min order when debug_guardpage_minorder > 0
has been added to the -mm tree.  Its filename is
     slub-min-order-when-debug_guardpage_minorder-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: slub: min order when debug_guardpage_minorder > 0

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch


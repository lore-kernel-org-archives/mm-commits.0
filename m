From: akpm@linux-foundation.org
Subject: - slub-dont-confuse-ctor-and-dtor.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:17 -0700
Message-ID: <200705180705.l4I75Gtx010078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542AbXERHHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: don't confuse ctor and dtor
has been removed from the -mm tree.  Its filename was
     slub-dont-confuse-ctor-and-dtor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: don't confuse ctor and dtor
From: Hugh Dickins <hugh@veritas.com>

kmem_cache_create() was swapping ctor and dtor in calling find_mergeable():
though it caused no bug, and probably never would, even if destructors are
retained; but fix it so as not to generate anxiety ;)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-dont-confuse-ctor-and-dtor mm/slub.c
--- a/mm/slub.c~slub-dont-confuse-ctor-and-dtor
+++ a/mm/slub.c
@@ -2522,7 +2522,7 @@ struct kmem_cache *kmem_cache_create(con
 	struct kmem_cache *s;
 
 	down_write(&slub_lock);
-	s = find_mergeable(size, align, flags, dtor, ctor);
+	s = find_mergeable(size, align, flags, ctor, dtor);
 	if (s) {
 		s->refcount++;
 		/*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
scsi-fix-config_scsi_wait_scan=m.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio_tree-debugging-patch.patch

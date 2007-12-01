From: akpm@linux-foundation.org
Subject: - slab-fix-kmem_cache_free-performance-regression.patch removed from -mm tree
Date: Sat, 01 Dec 2007 03:56:58 -0800
Message-ID: <200712011156.lB1Buww0021501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbXLAL5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 1 Dec 2007 06:57:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, clameter@sgi.com, penberg@cs.helsinki.fi, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     slab: fix kmem_cache_free performance regression
has been removed from the -mm tree.  Its filename was
     slab-fix-kmem_cache_free-performance-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: fix kmem_cache_free performance regression
From: Matthew Wilcox <matthew@wil.cx>

The database performance group have found that half the cycles spent in
kmem_cache_free are spent in this one call to BUG_ON.  Moving it into the
CONFIG_SLAB_DEBUG-only function cache_free_debugcheck() is a performance
win of almost 0.5% on their particular benchmark.

The call was added as part of commit
ddc2e812d592457747c4367fb73edcaa8e1e49ff with the comment that "overhead
should be minimal".  It may have been minimal at the time, but it isn't
now.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-fix-kmem_cache_free-performance-regression mm/slab.c
--- a/mm/slab.c~slab-fix-kmem_cache_free-performance-regression
+++ a/mm/slab.c
@@ -2881,6 +2881,8 @@ static void *cache_free_debugcheck(struc
 	unsigned int objnr;
 	struct slab *slabp;
 
+	BUG_ON(virt_to_cache(objp) != cachep);
+
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
 	page = virt_to_head_page(objp);
@@ -3759,8 +3761,6 @@ void kmem_cache_free(struct kmem_cache *
 {
 	unsigned long flags;
 
-	BUG_ON(virt_to_cache(objp) != cachep);
-
 	local_irq_save(flags);
 	debug_check_no_locks_freed(objp, obj_size(cachep));
 	__cache_free(cachep, objp);
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
use-wake_up_locked-in-eventpoll.patch
use-macros-instead-of-task_-flags.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
add-task_wakekill.patch
add-lock_page_killable.patch
hash-add-explicit-u32-and-u64-versions-of-hash.patch
make-sure-nobodys-leaking-resources.patch

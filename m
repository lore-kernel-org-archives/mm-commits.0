From: akpm@linux-foundation.org
Subject: - slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:24 -0700
Message-ID: <200705080008.l4808OiZ009377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967429AbXEHAIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: allocate smallest object size if the user asks for 0 bytes
has been removed from the -mm tree.  Its filename was
     slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: allocate smallest object size if the user asks for 0 bytes
From: Christoph Lameter <clameter@sgi.com>

Makes SLUB behave like SLAB in this area to avoid issues....

Throw a stack dump to alert people.

At some point the behavior should be switched back.  NULL is no memory as
far as I can tell and if the use asked for 0 bytes then he need to get no
memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    8 ++++++--
 mm/slub.c                |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/slub_def.h~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes
+++ a/include/linux/slub_def.h
@@ -80,8 +80,12 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(int size)
 {
-	if (size == 0)
-		return 0;
+	/*
+	 * We should return 0 if size == 0 but we use the smallest object
+	 * here for SLAB legacy reasons.
+	 */
+	WARN_ON_ONCE(size == 0);
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
diff -puN mm/slub.c~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes mm/slub.c
--- a/mm/slub.c~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes
+++ a/mm/slub.c
@@ -1979,7 +1979,7 @@ static struct kmem_cache *get_slab(size_
 {
 	int index = kmalloc_index(size);
 
-	if (!size)
+	if (!index)
 		return NULL;
 
 	/* Allocation too large? */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch

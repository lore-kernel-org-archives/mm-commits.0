From: akpm@linux-foundation.org
Subject: + slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:23:11 -0700
Message-ID: <200708171823.l7HINBPn023253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbXHQSXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check
has been added to the -mm tree.  Its filename is
     slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check
From: Satyam Sharma <satyam@infradead.org>

Considering kfree(NULL) would normally occur only in error paths and
kfree(ZERO_SIZE_PTR) is uncommon as well, so let's use unlikely() for the
condition check in SLUB's and SLOB's kfree() to optimize for the common
case.  SLAB has this already.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    6 +++---
 mm/slub.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slob.c
--- a/mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check
+++ a/mm/slob.c
@@ -360,7 +360,7 @@ static void slob_free(void *block, int s
 	slobidx_t units;
 	unsigned long flags;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 	BUG_ON(!size);
 
@@ -466,7 +466,7 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
@@ -484,7 +484,7 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff -puN mm/slub.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slub.c
--- a/mm/slub.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check
+++ a/mm/slub.c
@@ -2434,7 +2434,7 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (ZERO_OR_NULL_PTR(object))
+	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return 0;
 
 	page = get_object_page(object);
@@ -2468,7 +2468,7 @@ void kfree(const void *x)
 {
 	struct page *page;
 
-	if (ZERO_OR_NULL_PTR(x))
+	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
 	page = virt_to_head_page(x);
@@ -2785,7 +2785,7 @@ void *__kmalloc_track_caller(size_t size
 							get_order(size));
 	s = get_slab(size, gfpflags);
 
-	if (ZERO_OR_NULL_PTR(s))
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
 	return slab_alloc(s, gfpflags, -1, caller);
@@ -2801,7 +2801,7 @@ void *__kmalloc_node_track_caller(size_t
 							get_order(size));
 	s = get_slab(size, gfpflags);
 
-	if (ZERO_OR_NULL_PTR(s))
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
 	return slab_alloc(s, gfpflags, node, caller);
_

Patches currently in -mm which might be from satyam@infradead.org are

ia64-include-kconfigpreempt.patch
git-netdev-all.patch
git-net.patch
introduce-u16_max-and-u32_max.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch

From: akpm@linux-foundation.org
Subject: + slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:31:17 -0700
Message-ID: <200710301831.l9UIVH3Z021435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbXJ3SbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:31:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLUB: noinline some functions to avoid them being folded into alloc/free
has been added to the -mm tree.  Its filename is
     slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: noinline some functions to avoid them being folded into alloc/free
From: Christoph Lameter <clameter@sgi.com>

Some function tend to get folded into __slab_free and __slab_alloc although
they are rarely called.  They cause register pressure that leads to bad code
generation.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free mm/slub.c
--- a/mm/slub.c~slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free
+++ a/mm/slub.c
@@ -831,8 +831,8 @@ static void setup_object_debug(struct km
 	init_tracking(s, object);
 }
 
-static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+static noinline int alloc_debug_processing(struct kmem_cache *s,
+		struct page *page, void *object, void *addr)
 {
 	if (!check_slab(s, page))
 		goto bad;
@@ -871,8 +871,8 @@ bad:
 	return 0;
 }
 
-static int free_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+static noinline int free_debug_processing(struct kmem_cache *s,
+			struct page *page, void *object, void *addr)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -1074,7 +1074,8 @@ static void setup_object(struct kmem_cac
 		s->ctor(s, object);
 }
 
-static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+static noinline struct page *new_slab(struct kmem_cache *s,
+						gfp_t flags, int node)
 {
 	struct page *page;
 	struct kmem_cache_node *n;
@@ -1208,7 +1209,7 @@ static void add_partial(struct kmem_cach
 	spin_unlock(&n->list_lock);
 }
 
-static void remove_partial(struct kmem_cache *s,
+static noinline void remove_partial(struct kmem_cache *s,
 						struct page *page)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
_

Patches currently in -mm which might be from clameter@sgi.com are

ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
fix-mm-utilckrealloc.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

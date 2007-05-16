From: akpm@linux-foundation.org
Subject: + fix-find_or_create_page-skips-cpuset-memory-spreading.patch added to -mm tree
Date: Tue, 15 May 2007 22:30:39 -0700
Message-ID: <200705160530.l4G5UcV1027035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760341AbXEPFcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 01:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Fix: find_or_create_page skips cpuset memory spreading.
has been added to the -mm tree.  Its filename is
     fix-find_or_create_page-skips-cpuset-memory-spreading.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix: find_or_create_page skips cpuset memory spreading.
From: Christoph Lameter <clameter@sgi.com>

We call alloc_page where we should be calling __page_cache_alloc.

__page_cache_alloc performs cpuset memory spreading.  alloc_page does not. 
There is no reason that pages allocated via find_or_create should be
exempt.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~fix-find_or_create_page-skips-cpuset-memory-spreading mm/filemap.c
--- a/mm/filemap.c~fix-find_or_create_page-skips-cpuset-memory-spreading
+++ a/mm/filemap.c
@@ -670,7 +670,8 @@ repeat:
 	page = find_lock_page(mapping, index);
 	if (!page) {
 		if (!cached_page) {
-			cached_page = alloc_page(gfp_mask);
+			cached_page =
+				__page_cache_alloc(gfp_mask);
 			if (!cached_page)
 				return NULL;
 		}
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
slub-fix-handling-of-oversized-slabs.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch

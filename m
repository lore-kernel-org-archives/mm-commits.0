From: akpm@linux-foundation.org
Subject: + slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch added to -mm tree
Date: Wed, 09 May 2007 21:31:35 -0700
Message-ID: <200705100431.l4A4VZKC012030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbXEJEbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:31:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: use antifrag constant instead of hardcoding page order
has been added to the -mm tree.  Its filename is
     slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: use antifrag constant instead of hardcoding page order
From: Christoph Lameter <clameter@sgi.com>

Andy suggested this change.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order mm/slub.c
--- a/mm/slub.c~slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order
+++ a/mm/slub.c
@@ -153,7 +153,7 @@ static inline void ClearSlabDebug(struct
  * If antifragmentation methods are in effect then increase the
  * slab sizes to increase performance
  */
-#define DEFAULT_ANTIFRAG_MAX_ORDER 3
+#define DEFAULT_ANTIFRAG_MAX_ORDER PAGE_ALLOC_COSTLY_ORDER
 #define DEFAULT_ANTIFRAG_MIN_OBJECTS 16
 
 /*
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
slub-slub_debug-must-depend-on-slub.patch
slub-remove-nr_cpu_ids-hack.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-i386-support.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch

From: akpm@linux-foundation.org
Subject: + sh-dwarf-use-mempool_create_slab_pool.patch added to -mm tree
Date: Wed, 11 Mar 2015 16:13:00 -0700
Message-ID: <5500cbfc.I2xVIfpXWmo69+CC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbCKXNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 19:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/kernel/dwarf.c: use mempool_create_slab_pool()
has been added to the -mm tree.  Its filename is
     sh-dwarf-use-mempool_create_slab_pool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-dwarf-use-mempool_create_slab_pool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-dwarf-use-mempool_create_slab_pool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: arch/sh/kernel/dwarf.c: use mempool_create_slab_pool()

Mempools created for slab caches should use mempool_create_slab_pool().

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/dwarf.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN arch/sh/kernel/dwarf.c~sh-dwarf-use-mempool_create_slab_pool arch/sh/kernel/dwarf.c
--- a/arch/sh/kernel/dwarf.c~sh-dwarf-use-mempool_create_slab_pool
+++ a/arch/sh/kernel/dwarf.c
@@ -1180,17 +1180,13 @@ static int __init dwarf_unwinder_init(vo
 			sizeof(struct dwarf_reg), 0,
 			SLAB_PANIC | SLAB_HWCACHE_ALIGN | SLAB_NOTRACK, NULL);
 
-	dwarf_frame_pool = mempool_create(DWARF_FRAME_MIN_REQ,
-					  mempool_alloc_slab,
-					  mempool_free_slab,
-					  dwarf_frame_cachep);
+	dwarf_frame_pool = mempool_create_slab_pool(DWARF_FRAME_MIN_REQ,
+						    dwarf_frame_cachep);
 	if (!dwarf_frame_pool)
 		goto out;
 
-	dwarf_reg_pool = mempool_create(DWARF_REG_MIN_REQ,
-					 mempool_alloc_slab,
-					 mempool_free_slab,
-					 dwarf_reg_cachep);
+	dwarf_reg_pool = mempool_create_slab_pool(DWARF_REG_MIN_REQ,
+						  dwarf_reg_cachep);
 	if (!dwarf_reg_pool)
 		goto out;
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-utilc-add-kstrimdup.patch


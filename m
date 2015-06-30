From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:48:46 -0700
Message-ID: <55930ebe.S8ByWmMiG0dAPU58%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbF3Vss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: initialise a subset of struct pages if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set -fix
has been removed from the -mm tree.  Its filename was
     mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch

This patch was dropped because it was folded into mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: meminit: initialise a subset of struct pages if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set -fix

This is take 2 on describing why these section names exist. If accepted
then it should be considered a fix for the mmotm patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/internal.h~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix mm/internal.h
--- a/mm/internal.h~mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix
+++ a/mm/internal.h
@@ -388,10 +388,14 @@ static inline void mminit_verify_zonelis
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
 /*
- * Deferred struct page initialisation requires some early init functions that
- * are removed before kswapd is up and running. The feature depends on memory
- * hotplug so put the data and code required by deferred initialisation into
- * the __meminit section where they are preserved.
+ * Deferred struct page initialisation requires init functions that are freed
+ * before kswapd is available. Reuse the memory hotplug section annotation
+ * to mark the required code.
+ *
+ * __defermem_init is code that always exists but is annotated __meminit to
+ * 	avoid section warnings.
+ * __defer_init code gets marked __meminit when deferring struct page
+ *	initialistion but is otherwise in the init section.
  */
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 #define __defermem_init __meminit
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
mm-meminit-remove-mminit_verify_page_links.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch


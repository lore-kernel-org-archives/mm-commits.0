From: akpm@linux-foundation.org
Subject: + tile-query-dynamic-debug_pagealloc-setting.patch added to -mm
 tree
Date: Thu, 04 Feb 2016 15:43:33 -0800
Message-ID: <56b3e225.yhesFPry/KUvl5Hf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbcBDXne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:43:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: query dynamic DEBUG_PAGEALLOC setting
has been added to the -mm tree.  Its filename is
     tile-query-dynamic-debug_pagealloc-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-query-dynamic-debug_pagealloc-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-query-dynamic-debug_pagealloc-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: tile: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is complied
with CONFIG_DEBUG_PAGEALLOC.  This patch changes the code to query whether
it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/init.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/tile/mm/init.c~tile-query-dynamic-debug_pagealloc-setting arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~tile-query-dynamic-debug_pagealloc-setting
+++ a/arch/tile/mm/init.c
@@ -896,17 +896,15 @@ void __init pgtable_cache_init(void)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-static long __write_once initfree;
-#else
 static long __write_once initfree = 1;
-#endif
+static bool __write_once set_initfree_done;
 
 /* Select whether to free (1) or mark unusable (0) the __init pages. */
 static int __init set_initfree(char *str)
 {
 	long val;
 	if (kstrtol(str, 0, &val) == 0) {
+		set_initfree_done = true;
 		initfree = val;
 		pr_info("initfree: %s free init pages\n",
 			initfree ? "will" : "won't");
@@ -919,6 +917,11 @@ static void free_init_pages(char *what,
 {
 	unsigned long addr = (unsigned long) begin;
 
+	/* Prefer user request first */
+	if (!set_initfree_done) {
+		if (debug_pagealloc_enabled())
+			initfree = 0;
+	}
 	if (kdata_huge && !initfree) {
 		pr_warn("Warning: ignoring initfree=0: incompatible with kdata=huge\n");
 		initfree = 1;
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch


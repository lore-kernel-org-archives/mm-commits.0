Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61C7C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B86C461430
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhEHWzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhEHWzg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C5561402;
        Sat,  8 May 2021 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514474;
        bh=Kp01GneuNzbLu/ZC3lD2FiL0Gteu8w9zdAIgvjmwHLA=;
        h=Date:From:To:Subject:From;
        b=B6znq5tUQ5RgJk58q9ChXvH2bzZG8mk2AqaZU+dBJBb19JVKUb+0dxjQ4RdWtL6zf
         J9elP+CMxNPT9/d6lh95FnhYRQJ4QD2fuwXQDvxti75qUqAJf+d4WwOhCaPAgi5KcL
         fUpd+6giZYFbKZBA04R5KUuiu6xPcEpR+ivJSLG8=
Date:   Sat, 08 May 2021 15:54:34 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, luoshijie1@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-fix-some-typos-and-code-style-problems.patch
 removed from -mm tree
Message-ID: <20210508225434.moYbkPinN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some typos and code style problems
has been removed from the -mm tree.  Its filename was
     mm-fix-some-typos-and-code-style-problems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shijie Luo <luoshijie1@huawei.com>
Subject: mm: fix some typos and code style problems

fix some typos and code style problems in mm.

gfp.h: s/MAXNODES/MAX_NUMNODES
mmzone.h: s/then/than
rmap.c: s/__vma_split()/__vma_adjust()
swap.c: s/__mod_zone_page_stat/__mod_zone_page_state, s/is is/is
swap_state.c: s/whoes/whose
z3fold.c: code style problem fix in z3fold_unregister_migration
zsmalloc.c: s/of/or, s/give/given

Link: https://lkml.kernel.org/r/20210419083057.64820-1-luoshijie1@huawei.com
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    2 +-
 include/linux/mmzone.h |    2 +-
 mm/rmap.c              |    2 +-
 mm/swap.c              |    4 ++--
 mm/swap_state.c        |    2 +-
 mm/z3fold.c            |    2 +-
 mm/zsmalloc.c          |    4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/gfp.h~mm-fix-some-typos-and-code-style-problems
+++ a/include/linux/gfp.h
@@ -490,7 +490,7 @@ static inline int gfp_zonelist(gfp_t fla
 
 /*
  * We get the zone list from the current node and the gfp_mask.
- * This zone list contains a maximum of MAXNODES*MAX_NR_ZONES zones.
+ * This zone list contains a maximum of MAX_NUMNODES*MAX_NR_ZONES zones.
  * There are two zonelists per node, one for all zones with memory and
  * one containing just zones from the node the zonelist belongs to.
  *
--- a/include/linux/mmzone.h~mm-fix-some-typos-and-code-style-problems
+++ a/include/linux/mmzone.h
@@ -55,7 +55,7 @@ enum migratetype {
 	 * pageblocks to MIGRATE_CMA which can be done by
 	 * __free_pageblock_cma() function.  What is important though
 	 * is that a range of pageblocks must be aligned to
-	 * MAX_ORDER_NR_PAGES should biggest page be bigger then
+	 * MAX_ORDER_NR_PAGES should biggest page be bigger than
 	 * a single pageblock.
 	 */
 	MIGRATE_CMA,
--- a/mm/rmap.c~mm-fix-some-typos-and-code-style-problems
+++ a/mm/rmap.c
@@ -257,7 +257,7 @@ static inline void unlock_anon_vma_root(
  * Attach the anon_vmas from src to dst.
  * Returns 0 on success, -ENOMEM on failure.
  *
- * anon_vma_clone() is called by __vma_split(), __split_vma(), copy_vma() and
+ * anon_vma_clone() is called by __vma_adjust(), __split_vma(), copy_vma() and
  * anon_vma_fork(). The first three want an exact copy of src, while the last
  * one, anon_vma_fork(), may try to reuse an existing anon_vma to prevent
  * endless growth of anon_vma. Since dst->anon_vma is set to NULL before call,
--- a/mm/swap.c~mm-fix-some-typos-and-code-style-problems
+++ a/mm/swap.c
@@ -496,7 +496,7 @@ void lru_cache_add_inactive_or_unevictab
 	if (unlikely(unevictable) && !TestSetPageMlocked(page)) {
 		int nr_pages = thp_nr_pages(page);
 		/*
-		 * We use the irq-unsafe __mod_zone_page_stat because this
+		 * We use the irq-unsafe __mod_zone_page_state because this
 		 * counter is not modified from interrupt context, and the pte
 		 * lock is held(spinlock), which implies preemption disabled.
 		 */
@@ -808,7 +808,7 @@ inline void __lru_add_drain_all(bool for
 	 * below which drains the page vectors.
 	 *
 	 * Let x, y, and z represent some system CPU numbers, where x < y < z.
-	 * Assume CPU #z is is in the middle of the for_each_online_cpu loop
+	 * Assume CPU #z is in the middle of the for_each_online_cpu loop
 	 * below and has already reached CPU #y's per-cpu data. CPU #x comes
 	 * along, adds some pages to its per-cpu vectors, then calls
 	 * lru_add_drain_all().
--- a/mm/swap_state.c~mm-fix-some-typos-and-code-style-problems
+++ a/mm/swap_state.c
@@ -792,7 +792,7 @@ static void swap_ra_info(struct vm_fault
  *
  * Returns the struct page for entry and addr, after queueing swapin.
  *
- * Primitive swap readahead code. We simply read in a few pages whoes
+ * Primitive swap readahead code. We simply read in a few pages whose
  * virtual addresses are around the fault address in the same vma.
  *
  * Caller must hold read mmap_lock if vmf->vma is not NULL.
--- a/mm/z3fold.c~mm-fix-some-typos-and-code-style-problems
+++ a/mm/z3fold.c
@@ -391,7 +391,7 @@ static void z3fold_unregister_migration(
 {
 	if (pool->inode)
 		iput(pool->inode);
- }
+}
 
 /* Initializes the z3fold header of a newly allocated z3fold page */
 static struct z3fold_header *init_z3fold_page(struct page *page, bool headless,
--- a/mm/zsmalloc.c~mm-fix-some-typos-and-code-style-problems
+++ a/mm/zsmalloc.c
@@ -61,7 +61,7 @@
 #define ZSPAGE_MAGIC	0x58
 
 /*
- * This must be power of 2 and greater than of equal to sizeof(link_free).
+ * This must be power of 2 and greater than or equal to sizeof(link_free).
  * These two conditions ensure that any 'struct link_free' itself doesn't
  * span more than 1 page which avoids complex case of mapping 2 pages simply
  * to restore link_free pointer values.
@@ -530,7 +530,7 @@ static void set_zspage_mapping(struct zs
  * class maintains a list of zspages where each zspage is divided
  * into equal sized chunks. Each allocation falls into one of these
  * classes depending on its size. This function returns index of the
- * size class which has chunk size big enough to hold the give size.
+ * size class which has chunk size big enough to hold the given size.
  */
 static int get_size_class_index(int size)
 {
_

Patches currently in -mm which might be from luoshijie1@huawei.com are



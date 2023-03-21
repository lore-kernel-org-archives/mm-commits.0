Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E5CC6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 19:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCUTim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCUTik (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 15:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0A422CAF
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 12:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5782661DE6
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 19:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BC9C433EF;
        Tue, 21 Mar 2023 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679427424;
        bh=pYfnTlETyoXGJc3MMLNmr9gOSzboX38xCzwtRg4uRgY=;
        h=Date:To:From:Subject:From;
        b=OH4q/pCRUG/a/b/XaE9zzgSVyKGj4V8I1d3VEXNxQW/fyfjHzkxspXlZZlVMbRkI/
         HuvAwIgIdFOssoiEQCSH1hyUWWLApLKsLJ8rqDpghK/5PpiEt3ViwPhFaemFoQBNAo
         wZOor/k6aBdl5e7EUN13DSaW/QnhORVq0MUbp1s4=
Date:   Tue, 21 Mar 2023 12:37:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch added to mm-unstable branch
Message-Id: <20230321193704.B2BC9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add helper for checking if check_pages_enabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/page_alloc: add helper for checking if check_pages_enabled
Date: Tue, 21 Mar 2023 19:05:01 +0200

Instead of duplicating long static_branch_enabled(&check_pages_enabled)
wrap it in a helper function is_check_pages_enabled()

Link: https://lkml.kernel.org/r/20230321170513.2401534-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-helper-for-checking-if-check_pages_enabled
+++ a/mm/page_alloc.c
@@ -245,6 +245,11 @@ EXPORT_SYMBOL(init_on_free);
 /* perform sanity checks on struct pages being allocated or freed */
 static DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
+static inline bool is_check_pages_enabled(void)
+{
+	return static_branch_unlikely(&check_pages_enabled);
+}
+
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
 static int __init early_init_on_alloc(char *buf)
@@ -1443,7 +1448,7 @@ static __always_inline bool free_pages_p
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			if (static_branch_unlikely(&check_pages_enabled)) {
+			if (is_check_pages_enabled()) {
 				if (unlikely(free_page_is_bad(page + i))) {
 					bad++;
 					continue;
@@ -1456,7 +1461,7 @@ static __always_inline bool free_pages_p
 		page->mapping = NULL;
 	if (memcg_kmem_online() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
-	if (static_branch_unlikely(&check_pages_enabled)) {
+	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
 			bad++;
 		if (bad)
@@ -2366,7 +2371,7 @@ static int check_new_page(struct page *p
 
 static inline bool check_new_pages(struct page *page, unsigned int order)
 {
-	if (static_branch_unlikely(&check_pages_enabled)) {
+	if (is_check_pages_enabled()) {
 		for (int i = 0; i < (1 << order); i++) {
 			struct page *p = page + i;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mips-fix-comment-about-pgtable_init.patch
mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch
mm-move-most-of-core-mm-initialization-to-mm-mm_initc.patch
mm-handle-hashdist-initialization-in-mm-mm_initc.patch
mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch
init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch
initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch
mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch
mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch
initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch
mm-move-mem_init_print_info-to-mm_initc.patch
mm-move-kmem_cache_init-declaration-to-mm-slabh.patch
mm-move-vmalloc_init-declaration-to-mm-internalh.patch
maintainers-extend-memblock-entry-to-include-mm-initialization.patch


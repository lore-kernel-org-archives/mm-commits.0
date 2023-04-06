Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469D7C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjDFCq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbjDFCpM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970BE93CF
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A4E9642A8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EF5C4339B;
        Thu,  6 Apr 2023 02:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749109;
        bh=yIqYL/LwA4IlDTY2qpZhNJd8QJQxryfY3+E//NYM90Y=;
        h=Date:To:From:Subject:From;
        b=SoiCQ1CmXgToPElTs0OHIbUVOIgdlcTZHqY8xRAeLiueOb6NNlxj6wBwq5TJ6kgCk
         vFFl4CLItCnd1FKDL48xi1vc9olpS/xBYKBhLQtL9ALB2gHEhGfHnYpU8BCF+If1GI
         a7tzqLbbxa6Riq36j1bQVzoAGqmy6cLE/U28nWjI=
Date:   Wed, 05 Apr 2023 19:45:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch removed from -mm tree
Message-Id: <20230406024508.F1EF5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: add helper for checking if check_pages_enabled
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/page_alloc: add helper for checking if check_pages_enabled
Date: Tue, 21 Mar 2023 19:05:01 +0200

Instead of duplicating long static_branch_enabled(&check_pages_enabled)
wrap it in a helper function is_check_pages_enabled()

Link: https://lkml.kernel.org/r/20230321170513.2401534-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
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
@@ -1450,7 +1455,7 @@ static __always_inline bool free_pages_p
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			if (static_branch_unlikely(&check_pages_enabled)) {
+			if (is_check_pages_enabled()) {
 				if (unlikely(free_page_is_bad(page + i))) {
 					bad++;
 					continue;
@@ -1463,7 +1468,7 @@ static __always_inline bool free_pages_p
 		page->mapping = NULL;
 	if (memcg_kmem_online() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
-	if (static_branch_unlikely(&check_pages_enabled)) {
+	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
 			bad++;
 		if (bad)
@@ -2373,7 +2378,7 @@ static int check_new_page(struct page *p
 
 static inline bool check_new_pages(struct page *page, unsigned int order)
 {
-	if (static_branch_unlikely(&check_pages_enabled)) {
+	if (is_check_pages_enabled()) {
 		for (int i = 0; i < (1 << order); i++) {
 			struct page *p = page + i;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch added
 to -mm tree
Date: Tue, 16 Aug 2016 13:41:38 -0700
Message-ID: <57b37a82.uKUl4TgBva6OC1m8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbcHPUvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 16:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: move page_owner specific function to page_owner.c
has been added to the -mm tree.  Its filename is
     mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_owner: move page_owner specific function to page_owner.c

There is no reason that page_owner specific function resides on vmstat.c.

Link: http://lkml.kernel.org/r/1471315879-32294-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    2 
 mm/page_owner.c            |   77 +++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff -puN include/linux/page_owner.h~mm-page_owner-move-page_owner-specific-function-to-page_ownerc include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-move-page_owner-specific-function-to-page_ownerc
+++ a/include/linux/page_owner.h
@@ -14,6 +14,8 @@ extern void __split_page_owner(struct pa
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(struct page *page);
+extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
+					pg_data_t *pgdat, struct zone *zone);
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
diff -puN mm/page_owner.c~mm-page_owner-move-page_owner-specific-function-to-page_ownerc mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-move-page_owner-specific-function-to-page_ownerc
+++ a/mm/page_owner.c
@@ -8,6 +8,7 @@
 #include <linux/jump_label.h>
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
+#include <linux/seq_file.h>
 
 #include "internal.h"
 
@@ -214,6 +215,82 @@ void __copy_page_owner(struct page *oldp
 	__set_bit(PAGE_EXT_OWNER, &new_ext->flags);
 }
 
+static void pagetypeinfo_showmixedcount_print(struct seq_file *m,
+							pg_data_t *pgdat,
+							struct zone *zone)
+{
+	struct page *page;
+	struct page_ext *page_ext;
+	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
+	unsigned long end_pfn = pfn + zone->spanned_pages;
+	unsigned long count[MIGRATE_TYPES] = { 0, };
+	int pageblock_mt, page_mt;
+	int i;
+
+	/* Scan block by block. First and last block may be incomplete */
+	pfn = zone->zone_start_pfn;
+
+	/*
+	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
+	 * a zone boundary, it will be double counted between zones. This does
+	 * not matter as the mixed block count will still be correct
+	 */
+	for (; pfn < end_pfn; ) {
+		if (!pfn_valid(pfn)) {
+			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			continue;
+		}
+
+		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+		block_end_pfn = min(block_end_pfn, end_pfn);
+
+		page = pfn_to_page(pfn);
+		pageblock_mt = get_pageblock_migratetype(page);
+
+		for (; pfn < block_end_pfn; pfn++) {
+			if (!pfn_valid_within(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			if (page_zone(page) != zone)
+				continue;
+
+			if (PageBuddy(page)) {
+				pfn += (1UL << page_order(page)) - 1;
+				continue;
+			}
+
+			if (PageReserved(page))
+				continue;
+
+			page_ext = lookup_page_ext(page);
+			if (unlikely(!page_ext))
+				continue;
+
+			if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
+				continue;
+
+			page_mt = gfpflags_to_migratetype(page_ext->gfp_mask);
+			if (pageblock_mt != page_mt) {
+				if (is_migrate_cma(pageblock_mt))
+					count[MIGRATE_MOVABLE]++;
+				else
+					count[pageblock_mt]++;
+
+				pfn = block_end_pfn;
+				break;
+			}
+			pfn += (1UL << page_ext->order) - 1;
+		}
+	}
+
+	/* Print counts */
+	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
+	for (i = 0; i < MIGRATE_TYPES; i++)
+		seq_printf(m, "%12lu ", count[i]);
+	seq_putc(m, '\n');
+}
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_ext *page_ext,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-debug_pagealloc-clean-up-guard-page-handling-code.patch
mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
mm-page_ext-rename-offset-to-index.patch
mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch


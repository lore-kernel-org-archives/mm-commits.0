From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:44 -0700
Message-ID: <55f08ca4.rsYdv09g6MKLNcUk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbIITqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_isolation: make set/unset_migratetype_isolate() file-local
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm, page_isolation: make set/unset_migratetype_isolate() file-local

Nowaday, set/unset_migratetype_isolate() is defined and used only in
mm/page_isolation, so let's limit the scope within the file.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    5 -----
 mm/page_isolation.c            |    5 +++--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/page-isolation.h~mm-page_isolation-make-set-unset_migratetype_isolate-file-local include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-page_isolation-make-set-unset_migratetype_isolate-file-local
+++ a/include/linux/page-isolation.h
@@ -65,11 +65,6 @@ undo_isolate_page_range(unsigned long st
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			bool skip_hwpoisoned_pages);
 
-/*
- * Internal functions. Changes pageblock's migrate type.
- */
-int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages);
-void unset_migratetype_isolate(struct page *page, unsigned migratetype);
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
 				int **resultp);
 
diff -puN mm/page_isolation.c~mm-page_isolation-make-set-unset_migratetype_isolate-file-local mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-make-set-unset_migratetype_isolate-file-local
+++ a/mm/page_isolation.c
@@ -9,7 +9,8 @@
 #include <linux/hugetlb.h>
 #include "internal.h"
 
-int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages)
+static int set_migratetype_isolate(struct page *page,
+				bool skip_hwpoisoned_pages)
 {
 	struct zone *zone;
 	unsigned long flags, pfn;
@@ -72,7 +73,7 @@ out:
 	return ret;
 }
 
-void unset_migratetype_isolate(struct page *page, unsigned migratetype)
+static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch


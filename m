From: akpm@linux-foundation.org
Subject: - mm-introduce-probe_page.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:25 -0700
Message-ID: <200705080813.l488DP2I018915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934570AbXEHIOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     mm: introduce probe_page()
has been removed from the -mm tree.  Its filename was
     mm-introduce-probe_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: introduce probe_page()
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Introduce a pair of functions to probe the existence of file page.
	- int __probe_page(mapping, offset)
	- int probe_page(mapping, offset)

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -puN include/linux/pagemap.h~mm-introduce-probe_page include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-introduce-probe_page
+++ a/include/linux/pagemap.h
@@ -83,6 +83,8 @@ static inline struct page *page_cache_al
 
 typedef int filler_t(void *, struct page *);
 
+extern int __probe_page(struct address_space *mapping, pgoff_t offset);
+extern int probe_page(struct address_space *mapping, pgoff_t offset);
 extern struct page * find_get_page(struct address_space *mapping,
 				unsigned long index);
 extern struct page * find_lock_page(struct address_space *mapping,
diff -puN mm/filemap.c~mm-introduce-probe_page mm/filemap.c
--- a/mm/filemap.c~mm-introduce-probe_page
+++ a/mm/filemap.c
@@ -645,6 +645,29 @@ repeat:
 }
 EXPORT_SYMBOL(find_lock_page);
 
+/*
+ * Probing page existence.
+ */
+int __probe_page(struct address_space *mapping, pgoff_t offset)
+{
+	return !!radix_tree_lookup(&mapping->page_tree, offset);
+}
+
+/*
+ * Here we just do not bother to grab the page, it's meaningless anyway.
+ */
+int probe_page(struct address_space *mapping, pgoff_t offset)
+{
+	int exists;
+
+	read_lock_irq(&mapping->tree_lock);
+	exists = __probe_page(mapping, offset);
+	read_unlock_irq(&mapping->tree_lock);
+
+	return exists;
+}
+EXPORT_SYMBOL(probe_page);
+
 /**
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch

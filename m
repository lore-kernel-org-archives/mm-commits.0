Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6562417A30A
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876969; cv=none; b=J7fmTLmzx6LE/8Ba+3Clvw1nrW9OxYWHXiTdZnYd0rZxR7tDoRwxXSsOTJo9IUA4vIdrSyjNNyzK5MCgXnj6/fpBzCpeLYjeNNoioHNBIfQ1Sul9qcxvrKVH+KBJTRks3LckvC/nJH5jbIqT+Yu/EmPgboS3455j7/hV51UGp6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876969; c=relaxed/simple;
	bh=k+4RS7U1aJfHnNGrsdpVP+YYgQLvATJuRrE9p/srCw8=;
	h=Date:To:From:Subject:Message-Id; b=bb0XRdis+fwtxfLa/Jaxd0oKdr/iFCykMUAmIXRq42MB4DfYTlGXfLcUWIPqo76PSqox77hKuqXqvyl+XvN1EKML9VodaNRiewu+Z9odBR/Ebx3dtOEHjCOEIRHtgfLL1hhWeCvKl+9EcUUvEBa/ICQERJ0PM6SWos4/ZDffHXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b3+ihH2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b3+ihH2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDE01F000E9;
	Wed,  1 Jul 2026 03:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876967;
	bh=bA40DjC8RkliiEhuZ53QlmBj9FYmbilm6qoIJR3Kxys=;
	h=Date:To:From:Subject;
	b=b3+ihH2I/+E8DNrCQNq8zVneSsXknqyQCJstcRYASEmLwnMQ5s7ygozCv+dk/97FR
	 uMmQ7HQtTlX4DJUNbHhn0oA8reBXCpZvKBzBHx7KkOSKvqDjsomvi1Q4I/G6bTRrsE
	 a7pcTCHboWCwWQOyELRjPCMgnTgELt1d+qJHCFd4=
Date: Tue, 30 Jun 2026 20:36:07 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch removed from -mm tree
Message-Id: <20260701033607.BCDE01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
has been removed from the -mm tree.  Its filename was
     mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Tue, 30 Jun 2026 09:53:18 +0800

Patch series "mm/page_owner: misc cleanups", v3.

This series collects a few cleanups for mm/page_owner.c that have been
accumulated while reading through the file.  There is no functional change
-- the goal is to make the code easier to read and maintain.

Patch 1 consolidates three identical PageBuddy skip blocks into a single
skip_buddy_pages() helper, eliminating the duplication and keeping the
lockless-read comment in one place.

Patch 2 replaces the -1 magic number used for "never migrated" with a
proper MR_NEVER member in enum migrate_reason, and adds the corresponding
"never_migrated" string in the MIGRATE_REASON trace macro.

Patch 3 follows up by converting the remaining 'int reason' parameters
throughout the migration and hugetlb callchains to 'enum migrate_reason',
making the type explicit and gaining compiler checking.  The 'short
last_migrate_reason' struct field in page_owner is intentionally left as
'short' since it is per-page metadata where size matters.

Patch 4 hoists the CONFIG_MEMCG guard out of print_page_owner_memcg()'s
body so that the real implementation and the empty stub are two clearly
separate definitions, the common kernel idiom.

Patch 5 adds a missing \n to the count_threshold debugfs attribute format
string so that cat(1) output is properly terminated.

Patch 6 moves free_ts_nsec from the allocation summary line to the free
section in __dump_page_owner(), grouping it with free_pid and free_tgid
where it logically belongs.  This also makes the dump output consistent
with print_page_owner().

Patch 7 drops the redundant page_owner_ prefix from file-scoped static
symbols (stack_fops, threshold_fops, etc.).  Since they cannot collide
across translation units, the prefix carries no information.


This patch (of 7):

Three places in page_owner.c duplicate the same pattern: check if a page
is PageBuddy, read its order via buddy_order_unsafe(), advance the pfn
past the buddy block if the order is valid, and continue.

Consolidate them into a single inline helper skip_buddy_pages().  The
function returns true (skip) for any buddy page and advances @pfn past the
block when the order is valid; returns false if the page is not a buddy
page and should be processed normally.

The old init_pages_in_zone() variant used "order > 0" as an extra guard
before advancing pfn, but the continue was unconditional and (1UL << 0) -
1 == 0, so the behaviour is identical.  The comment about zone->lock is
preserved in the helper's kernel-doc.

No functional change.

Link: https://lore.kernel.org/20260630015331.147174-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260630015331.147174-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   52 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping
+++ a/mm/page_owner.c
@@ -422,6 +422,29 @@ void __folio_copy_owner(struct folio *ne
 	rcu_read_unlock();
 }
 
+/*
+ * Check if a page is a buddy page and advance @pfn past the entire buddy block.
+ * This safely reads the buddy order without the zone lock, which may cause us
+ * to skip less than the full buddy block, but that is acceptable for page owner
+ * iteration purposes.
+ *
+ * Return: true if the page was skipped (caller should continue its loop),
+ *         false if the page is not a buddy page and should be processed normally.
+ */
+static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
+{
+	unsigned long order;
+
+	if (!PageBuddy(page))
+		return false;
+
+	order = buddy_order_unsafe(page);
+	if (order <= MAX_PAGE_ORDER)
+		*pfn += (1UL << order) - 1;
+
+	return true;
+}
+
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 				       pg_data_t *pgdat, struct zone *zone)
 {
@@ -461,14 +484,8 @@ void pagetypeinfo_showmixedcount_print(s
 			if (page_zone(page) != zone)
 				continue;
 
-			if (PageBuddy(page)) {
-				unsigned long freepage_order;
-
-				freepage_order = buddy_order_unsafe(page);
-				if (freepage_order <= MAX_PAGE_ORDER)
-					pfn += (1UL << freepage_order) - 1;
+			if (skip_buddy_pages(&pfn, page))
 				continue;
-			}
 
 			if (PageReserved(page))
 				continue;
@@ -697,13 +714,8 @@ read_page_owner(struct file *file, char
 		}
 
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page)) {
-			unsigned long freepage_order = buddy_order_unsafe(page);
-
-			if (freepage_order <= MAX_PAGE_ORDER)
-				pfn += (1UL << freepage_order) - 1;
+		if (skip_buddy_pages(&pfn, page))
 			continue;
-		}
 
 		page_ext = page_ext_get(page);
 		if (unlikely(!page_ext))
@@ -798,20 +810,8 @@ static void init_pages_in_zone(struct zo
 			if (page_zone(page) != zone)
 				continue;
 
-			/*
-			 * To avoid having to grab zone->lock, be a little
-			 * careful when reading buddy page order. The only
-			 * danger is that we skip too much and potentially miss
-			 * some early allocated pages, which is better than
-			 * heavy lock contention.
-			 */
-			if (PageBuddy(page)) {
-				unsigned long order = buddy_order_unsafe(page);
-
-				if (order > 0 && order <= MAX_PAGE_ORDER)
-					pfn += (1UL << order) - 1;
+			if (skip_buddy_pages(&pfn, page))
 				continue;
-			}
 
 			if (PageReserved(page))
 				continue;
_

Patches currently in -mm which might be from ye.liu@linux.dev are

a.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch


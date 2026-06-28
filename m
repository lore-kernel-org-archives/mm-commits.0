Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA3740D569
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782614287; cv=none; b=s8ckK8Iaxc2nYlKkWyA4qDkx9NjQOMPT3FMrD8/0eTKJnGk8VNZ0ZnsnQwKJHvDToZDbrxhP9Gq2Ku3qu6dLkraq3Fe7CACBtIRV8dFABb5gDLxx64QSpZ/gHFa3eILyMsdpm8A+Iq3GXyxagTzLpeDizdt5vAfsnLEaZH7bw/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782614287; c=relaxed/simple;
	bh=dthAfLibvh4bWwal2Bx0kgqhtwOdCQ8z2RIPvf1iv/w=;
	h=Date:To:From:Subject:Message-Id; b=mN6Lr8xAjFfSA3R+wTL+ndWs0LtOWKiruglYezTakj622fZAudOWfY8FJchImFzdK7a1H8HVyNF3U5mp9v3WrqnEhp3yCmLZS7s0D3x/FDbukXNJq8eYa397bOTO5aBUd6IIlrURGbxRtmy7MFC1jz/dSZxnjM6KKdHUPqjxfyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2oX7siL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2oX7siL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5481F000E9;
	Sun, 28 Jun 2026 02:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782614285;
	bh=dFksgfgXkbhjq8UHuVZUjWS+lEP0fkNllfdbQS4LEbQ=;
	h=Date:To:From:Subject;
	b=2oX7siL+XaRmVO8kSDM+NP9TUF8h/Y8zr/6SDXY8AYzu6RnIUKKJ3APyJrw6O3kHI
	 /29Igca0tKy/wfKfHGu59iKXAdadm6MK+pQYvO7vTkVdE1Vx0xlvYVjMg2Plu7W2hH
	 8tbd//Na7oXs17k84bSYjwRYaKVSJyCwSg0uxDMc=
Date: Sat, 27 Jun 2026 19:38:04 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch added to mm-new branch
Message-Id: <20260628023805.4B5481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Fri, 26 Jun 2026 10:45:40 +0800

Patch series "mm/page_owner: misc cleanups", v2.

This series collects a few cleanups for mm/page_owner.c that have been
accumulated while reading through the file.  There is no functional change
-- the goal is to make the code easier to read and maintain.

Patch 1 consolidates three identical PageBuddy skip blocks into a single
skip_buddy_pages() helper, eliminating the duplication and keeping the
lockless-read comment in one place.

Patch 2 replaces the -1 magic number used for "never migrated" with a
local MIGRATE_REASON_NONE define, making the intent explicit at every use
site.

Patch 3 hoists the CONFIG_MEMCG guard out of print_page_owner_memcg()'s
body so that the real implementation and the empty stub are two clearly
separate definitions, the common kernel idiom.                   

Patch 4 adds a missing \n to the count_threshold debugfs attribute format
string so that cat(1) output is properly terminated.

Patch 5 moves free_ts_nsec from the allocation summary line to the free
section in __dump_page_owner(), grouping it with free_pid and free_tgid
where it logically belongs.  This also makes the dump output consistent
with print_page_owner().

Patch 6 drops the redundant page_owner_ prefix from file-scoped static
symbols (stack_fops, threshold_fops, etc.).  Since they cannot collide
across translation units, the prefix carries no information.


This patch (of 6):

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

Link: https://lore.kernel.org/20260626024550.25677-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260626024550.25677-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch


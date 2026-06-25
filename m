Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF031FBEA8
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782346834; cv=none; b=Mgdkl+uyolBd+4vYAOtyIC7j7iJ03U9bsUZWtnJBNG0EGFgcnu0A1czFRDtAk4U8qyEzMyMiLvcvJwwiyz54ZI95W87+HAuc9XkhbHY8lsoObAN4bDjePXk7C491Kam5SBEy4lSql1MFMguzP0vFk9UJYm1Hbg1bgJzdbwIGx+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782346834; c=relaxed/simple;
	bh=eGYDRhDiXOW2LQoQ++/jOgZjT6g6wVkWw/9c3+1we6A=;
	h=Date:To:From:Subject:Message-Id; b=bq9QujbzoT5wEcQZiQJuzhguHHniplePks3OKZ5Fh6FMp8eqyRYr5A3L5s4GrTzt5EXjHRaeY+ce2FKd40uQIGrPu/2EBDYuExEqNJvPQaZdWSz+EGXtGsXf5zHN8a/IerSzL0fQhojwNb3mcRHaKH0XcP6gmexjU0TUyrBj61Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ejtOSNE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ejtOSNE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209B51F000E9;
	Thu, 25 Jun 2026 00:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782346833;
	bh=WPVZF8Xjx2eq4/Ekkn8R97cfRLUfQKkFG3CfA7X2ydw=;
	h=Date:To:From:Subject;
	b=ejtOSNE+VKXIsYMMuCRK/o6r1iA+Dz7Rqeb+c6LuCYFljv+Az98QDGMn8nNRfFf5G
	 MgEvexpJfMyEAELla9AgOg7EpUguPSIvbBq4DO9Y9wCSZwgGkjtl1NHwNo6Z7hf8+a
	 kasgQ5uHa3u4Qs7RPnfzZim8ov7rn9thvM4wA9VM=
Date: Wed, 24 Jun 2026 17:20:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625002033.209B51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Tue, 23 Jun 2026 14:52:26 +0800

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

Link: https://lore.kernel.org/20260623065234.31866-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
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


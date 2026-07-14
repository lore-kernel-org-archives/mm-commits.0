Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2B83A257F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783999262; cv=none; b=F5cMzb+zoxoR2DwpnoqvSU8nXCuTo0a5h9aSoSRnUDaunuxCa1het2gbnQKtLFrFSrskVb4k3HfGEB3Ve3JH1c25+zHzcZ10I8LybJoFxZlmsL80EsdeWczslAVEtra1vdSuOYscrVtVdTEcwYnDIVzNw06wZ4Bjgad6pKpgmHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783999262; c=relaxed/simple;
	bh=8OJTy6dx5bqUgk8rJ9r0KupmYG/QDUP4tr+FRdyeNNw=;
	h=Date:To:From:Subject:Message-Id; b=Oihwiy/KGudTtncbtRcgcZ8P+q9tV4SinnTkRr/mEHI3mtL1CCkQcMCwuaADGmegVBhPzF8bbu/d0tJf/AkVHtsGCAiOy22GvqM88DXDfo786HnkFhl80leLnKfBKxATmDvNA1LQEFWAHlNalFX/Isf1EkC3N4E9wLntgPv9kyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wiHTDitN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wiHTDitN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D2B1F000E9;
	Tue, 14 Jul 2026 03:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783999260;
	bh=FQmDSsbLKbCZgcnHbcRvXdxYRIJZcfp20wMAAMAdHqE=;
	h=Date:To:From:Subject;
	b=wiHTDitNcRiJFyqNXh+kybc2h3m5wCCtEizq76Rhy+yzLGuKWUugVgedFjxeqVT1i
	 C5hkRybmziI0f+adlcd9ncyUv8dBNok363x8cg006UetGYVa1IhBgnGwW8mLexnxmx
	 h5zOIJWNN1Ti3UwdM1wAp9dkWilUr3F8asi1VFAI=
Date: Mon, 13 Jul 2026 20:21:00 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch added to mm-unstable branch
Message-Id: <20260714032100.99D2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
Date: Tue, 14 Jul 2026 09:51:07 +0800

The lockless buddy_order_unsafe() read can return a garbage order value if
the page is concurrently allocated between the PageBuddy check and the
private read.  If this bogus order is <= MAX_PAGE_ORDER,
skip_buddy_pages() would arbitrarily advance the PFN, potentially jumping
past a MAX_ORDER_NR_PAGES boundary whose pfn_valid() check would have
caught an offline memory section.

In read_page_owner(), which relies solely on boundary-aligned pfn_valid()
to guard pfn_to_page(), skipping the boundary could cause pfn_to_page() to
access an unmapped mem_section.

Clamp the advance so it never crosses the next MAX_ORDER_NR_PAGES
boundary.  This is safe for all three callers: the pageblock-iterating
ones already handle boundary transitions in their outer loops, and for
read_page_owner() the worst case is one extra PageBuddy check per 1024
pages when a bogus order would otherwise push past the boundary.

Link: https://lore.kernel.org/20260714015117.78351-9-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary
+++ a/mm/page_owner.c
@@ -428,6 +428,12 @@ void __folio_copy_owner(struct folio *ne
  * to skip less than the full buddy block, but that is acceptable for page owner
  * iteration purposes.
  *
+ * The lockless read of buddy_order_unsafe() can also return a garbage order if
+ * the page is concurrently allocated and PageBuddy is cleared between the check
+ * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
+ * that a bogus order cannot carry @pfn into an unvalidated memory section,
+ * which would break callers that rely on boundary-aligned pfn_valid() checks.
+ *
  * Return: true if the page was skipped (caller should continue its loop),
  *         false if the page is not a buddy page and should be processed normally.
  */
@@ -439,8 +445,12 @@ static inline bool skip_buddy_pages(unsi
 		return false;
 
 	order = buddy_order_unsafe(page);
-	if (order <= MAX_PAGE_ORDER)
-		*pfn += (1UL << order) - 1;
+	if (order <= MAX_PAGE_ORDER) {
+		unsigned long new_pfn = *pfn + (1UL << order);
+		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
+
+		*pfn = min(new_pfn, boundary) - 1;
+	}
 
 	return true;
 }
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch


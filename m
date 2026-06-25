Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ECA3A875E
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353080; cv=none; b=i13r5qlT3rvc15sJfJ4q1V6/QIdPejOjNA6+yQkQDAqil8jPI/6Y5hwzXj2Y0H2HjFDkWWFfotNIAMSk3GnQR/H2XLUz7eO1Y2iry8sGPjSIbnwtIqyTga4VqSUYZCnO+jZN2kiqT7XRCEII8s21TRysSik/09LvRfQo7L7KPJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353080; c=relaxed/simple;
	bh=6vaczq5sZ/+qjy0jpE0FrT1FTPiOGobzTXM390gGdXw=;
	h=Date:To:From:Subject:Message-Id; b=fA2RXfDKeKCr8ou5fn/iu1y0dRsCJEJuKhhceTlsQrJ3DZ2GOSao0z4lbGjRRhJHk6KSDv9bnZG+ysmE5xqRQDkRoeroFwZoC/c92iffzdfMq48HQ7FAws2eg2TwqHNyOFkmxhUZMaxLNEt0DRa1HY7JDiAWF7NINNr24wWYKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vpI2nIwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpI2nIwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3161F000E9;
	Thu, 25 Jun 2026 02:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353078;
	bh=Xd/0hNH7KaClVw/JbNjNo99p4J9hQkCv5SuemTUr+Rk=;
	h=Date:To:From:Subject;
	b=vpI2nIwpgG3IMBfxmz+XiOalh+AhICxu3llX68TKQzeVYrC97mzab7S8WkRDSfLXc
	 rbYuP8/nbi1+b2JKNXLq1sEsub/RpLSx8Gsknq5dRFy7kYMTU6iLl5ejDV/21Btmx5
	 BhnKqYqr7T4k9SwkcPLYM1ldfe3yWECwHWb8Ut6w=
Date: Wed, 24 Jun 2026 19:04:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch added to mm-new branch
Message-Id: <20260625020438.7E3161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch

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
Subject: mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
Date: Thu, 25 Jun 2026 09:47:04 +0800

Patch series "mm/page_owner: fix TOCTOU races in lockless page state
reading".

Fix two TOCTOU races found during review of [1].

page_owner reads page state locklessly by design.  In two places the code
reads the same metadata twice once as a guard, then again as a use and the
page can be concurrently reallocated between the two:

Patch 1: buddy_order_unsafe() in skip_buddy_pages() can return garbage if
the page is allocated between PageBuddy() and the private read, causing
the PFN to skip past a pfn_valid() boundary.  Clamp the advance at
MAX_ORDER_NR_PAGES.

Patch 2: PageMemcgKmem() in print_page_owner_memcg() re-reads
folio->memcg_data and triggers VM_BUG_ON assertions if the page became a
tail page or slab page.  Use the snapshot taken at entry.


This patch (of 2):

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
pages for a huge buddy block straddling the boundary.

Link: https://lore.kernel.org/20260625014708.87386-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260625014708.87386-2-ye.liu@linux.dev
Link: https://lore.kernel.org/all/20260623065234.31866-2-ye.liu@linux.dev/ [1]
Link: https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary
+++ a/mm/page_owner.c
@@ -435,6 +435,12 @@ void __folio_copy_owner(struct folio *ne
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
@@ -446,8 +452,12 @@ static inline bool skip_buddy_pages(unsi
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
mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch


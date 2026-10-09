Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7292B40099C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525435; cv=none; b=qWABKMYESfvp6JR21pOEAkBZwSDf+RTJ1IH+CGVtp5K3bAKPuzxkW+FYVPSVMFCs+GAhbs6oesIjD7/GUEyHt4tWJawRiauebdRdSmq1c/micKWf44fI8vbd1oLJvFFH/8IgNCpV6qivexn/zM79YlgadQ4TPzrRFEj5GJ2qn1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525435; c=relaxed/simple;
	bh=vV0gflmuZ6WPuRa30qg503dB0gxxUiuybhmnU1sbzPs=;
	h=Date:To:From:Subject:Message-Id; b=iqGqURRHyZclb8TkVAkP55XQ1dQ+ePvEvorpbOW/JPrBF7v4LbK0B44Ur+1ap1JUV9Ff1CzOjwGhuu9LUDx32VtHxtPftcv9SiMZInJBmHpDu3qO8ws8LgYowmZvdTh5CSwBa9pZk5TC2cQeyEfCzR34xS2z3iH+STCvu/tc6Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0SxI8bw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0SxI8bw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420441F00893;
	Fri,  9 Oct 2026 05:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525434;
	bh=qcp1q/NacQIIqgPqbqdPfJdF3HZGH0VsORU4HvblyKk=;
	h=Date:To:From:Subject;
	b=0SxI8bw5Bum9lymzHbQbK+2Ha388uXrm3sOJGJm2PuX8Nsqbsx2XeSDjmT7jmngq0
	 y6YqaBjBGsM3ZfMhfRiL6W0zAC9ENx924/px9kbsjKKSDO7NOHAqviiAS1UTfoOtIw
	 QyUcTqXlmvdtiZEVvA3J0zScLCMy6bwuHGuAx5J8=
Date: Thu, 08 Oct 2026 22:57:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch removed from -mm tree
Message-Id: <20261009055714.420441F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: add folio_swap_entry() and folio_page_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/swap: add folio_swap_entry() and folio_page_swap_entry()
Date: Tue, 08 Sep 2026 11:16:31 -0400

Patch series "mm: remove page_swap_entry()", v2.

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio.  The swap entry is folio
state, but the only helper for it is page-based: page_swap_entry() takes a
page and recomputes the folio its callers already hold.  Several callers
avoid it by open-coding the arithmetic on folio->swap instead.

Add folio_swap_entry() and folio_page_swap_entry(), convert all users, and
remove page_swap_entry(), with a few other cleanups along the way.


This patch (of 8):

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio.  page_swap_entry() hides
this behind a compound_head() call, and callers that already have the
folio sometimes open-code the arithmetic instead.

Add folio_swap_entry(), which takes a folio and a page index, and
folio_page_swap_entry() for callers that have the page.

[tz2294@columbia.edu: adjust folio_swap_entry() kerneldoc summary, per David]
  Link: https://lore.kernel.org/20260913-folio_swap_entry-doc-fix-1@columbia.edu
Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu
Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 include/linux/swap.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/include/linux/swap.h~mm-swap-add-folio_swap_entry-and-folio_page_swap_entry
+++ a/include/linux/swap.h
@@ -272,6 +272,39 @@ struct swap_info_struct {
 	const struct swap_ops *ops;
 };
 
+/**
+ * folio_swap_entry - Return the swap entry at a page index within a folio.
+ * @folio: The folio.
+ * @idx: The index of the page within the folio.
+ *
+ * A folio in the swap cache occupies folio_nr_pages() contiguous swap
+ * entries starting at folio->swap. The caller must ensure the folio is
+ * in the swap cache and that @idx is within the folio.
+ */
+static inline
+swp_entry_t folio_swap_entry(const struct folio *folio, unsigned long idx)
+{
+	swp_entry_t entry = folio->swap;
+
+	VM_WARN_ON_ONCE_FOLIO(idx >= folio_nr_pages(folio), folio);
+	entry.val += idx;
+	return entry;
+}
+
+/**
+ * folio_page_swap_entry - Return the swap entry of a page in a folio.
+ * @folio: The folio containing @page.
+ * @page: A page within @folio.
+ *
+ * The caller must ensure the folio is in the swap cache and that @page
+ * is part of @folio.
+ */
+static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
+		const struct page *page)
+{
+	return folio_swap_entry(folio, folio_page_idx(folio, page));
+}
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch


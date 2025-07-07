Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDAF266EFC
	for <mm-commits@vger.kernel.org>; Mon,  7 Jul 2025 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751917787; cv=none; b=PAnDBpNZyIMVKnF5Adxd99jdurpMMy6E2+BoKwgMfKRcR2fL0BKkH7n6BMyfp8tKXqQGb6izbwyBpVIa2twT1H7vwGT9BHoDqUxCZTC0A+BCVo+VNtE0OkgBILaoGXCAG55Ies0zRyVopaHkijiy2vWHFhjoTpN+ayjgweoRGZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751917787; c=relaxed/simple;
	bh=pvGcJdJo/tSp15AfYS8H6poC9L6TkECKbM+toogN7s0=;
	h=Date:To:From:Subject:Message-Id; b=e77cPNkybbSAvHkwK2+xcUkGvUUs8vNv8Hp8seuY9kS6GcuSZjiA8ELAlHoEbrOI5Vvc/D72xMMKZgtyepV1wBnsrxxtRUTa/DdDM7Yr+oCRpM4B3d0ZdDQcaUhXv0SzQLpUBBiHSYh8mkBJ0WrnsMwIi7nE5CO1s5FBGE/m2y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AxUFEUsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AxUFEUsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E6C4CEE3;
	Mon,  7 Jul 2025 19:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751917786;
	bh=pvGcJdJo/tSp15AfYS8H6poC9L6TkECKbM+toogN7s0=;
	h=Date:To:From:Subject:From;
	b=AxUFEUsRUoIYubH/3JvF+b4SEfKOqRI4Cutv/W4P7Py3dv1hMrtQ4inKT7nPBnpvl
	 uaa4z06CwLdx+edUTqnpXmUEMDtj6wisWEZJct7Je/tuIDP0P9x7uIn6sMpKcpr8t9
	 LANuHvbG+bD+5lUdUMRP/0jxulbDtAcgVUGvto0E=
Date: Mon, 07 Jul 2025 12:49:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-stable_page_flags-use-snapshot_page.patch added to mm-new branch
Message-Id: <20250707194946.5E1E6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: stable_page_flags(): use snapshot_page()
has been added to the -mm mm-new branch.  Its filename is
     fs-stable_page_flags-use-snapshot_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-stable_page_flags-use-snapshot_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: fs: stable_page_flags(): use snapshot_page()
Date: Mon, 7 Jul 2025 14:50:46 -0400

A race condition is possible in stable_page_flags() where user-space is
reading /proc/kpageflags concurrently to a folio split.  This may lead to
oopses or BUG_ON()s being triggered.

To fix this, this commit uses snapshot_page() in stable_page_flags() so
that stable_page_flags() works with a stable page and folio snapshots
instead.

Note that stable_page_flags() makes use of some functions that require the
original page or folio pointer to work properly (eg.  is_free_budy_page()
and folio_test_idle()).  Since those functions can't be used on the page
snapshot, we replace their usage with flags that were set by
snapshot_page() for this purpose.

Link: https://lkml.kernel.org/r/42122b9988871469f1311d71a608629f40c0c55d.1751914235.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/fs/proc/page.c~fs-stable_page_flags-use-snapshot_page
+++ a/fs/proc/page.c
@@ -147,6 +147,7 @@ static inline u64 kpf_copy_bit(u64 kflag
 u64 stable_page_flags(const struct page *page)
 {
 	const struct folio *folio;
+	struct page_snapshot ps;
 	unsigned long k;
 	unsigned long mapping;
 	bool is_anon;
@@ -158,7 +159,9 @@ u64 stable_page_flags(const struct page
 	 */
 	if (!page)
 		return 1 << KPF_NOPAGE;
-	folio = page_folio(page);
+
+	snapshot_page(&ps, page);
+	folio = &ps.folio_snapshot;
 
 	k = folio->flags;
 	mapping = (unsigned long)folio->mapping;
@@ -167,7 +170,7 @@ u64 stable_page_flags(const struct page
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
-	if (page_mapped(page))
+	if (folio_mapped(folio))
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
@@ -179,7 +182,7 @@ u64 stable_page_flags(const struct page
 	 * compound pages: export both head/tail info
 	 * they together define a compound page's start/end pos and order
 	 */
-	if (page == &folio->page)
+	if (ps.idx == 0)
 		u |= kpf_copy_bit(k, KPF_COMPOUND_HEAD, PG_head);
 	else
 		u |= 1 << KPF_COMPOUND_TAIL;
@@ -189,25 +192,19 @@ u64 stable_page_flags(const struct page
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
 		u |= 1 << KPF_THP;
-	} else if (is_huge_zero_folio(folio)) {
+	} else if (is_huge_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_folio(folio)) {
+	} else if (is_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
-	/*
-	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
-	 * on the head page.
-	 */
-	if (PageBuddy(page))
-		u |= 1 << KPF_BUDDY;
-	else if (page_count(page) == 0 && is_free_buddy_page(page))
+	if (ps.flags & PAGE_SNAPSHOT_PG_FREE)
 		u |= 1 << KPF_BUDDY;
 
-	if (PageOffline(page))
+	if (folio_test_offline(folio))
 		u |= 1 << KPF_OFFLINE;
-	if (PageTable(page))
+	if (folio_test_pgtable(folio))
 		u |= 1 << KPF_PGTABLE;
 	if (folio_test_slab(folio))
 		u |= 1 << KPF_SLAB;
@@ -215,7 +212,7 @@ u64 stable_page_flags(const struct page
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
 #else
-	if (folio_test_idle(folio))
+	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
 		u |= 1 << KPF_IDLE;
 #endif
 
@@ -241,7 +238,7 @@ u64 stable_page_flags(const struct page
 	if (u & (1 << KPF_HUGE))
 		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 	else
-		u |= kpf_copy_bit(page->flags, KPF_HWPOISON,	PG_hwpoison);
+		u |= kpf_copy_bit(ps.page_snapshot.flags, KPF_HWPOISON, PG_hwpoison);
 #endif
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-util-introduce-snapshot_page.patch
proc-kpagecount-use-snapshot_page.patch
fs-stable_page_flags-use-snapshot_page.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154B21773F
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409703; cv=none; b=ktkdv5zo91t2ztURNPSyqiaa8zFMclbf27Qs2fxXBtDyNg6pYMWVJrBNJi+dAwe8MmjQZnSpEE9pF5Vf8jtLlb4CMTwvU1tbTmwwhI9tpB6s5j5lMDloxfAj9XFj5b1aHaaaFuIw5eCjQzuDUq63sN3sqhviESjTm2ISFGogoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409703; c=relaxed/simple;
	bh=qv2fD88N1gyB/L38PpZbwnaZtilqcA2p7K+1u6hDpa8=;
	h=Date:To:From:Subject:Message-Id; b=PbtyAdtNCRbHW9VW6CfSCyv7e1Z/9MxlPA2/MdW79jd8PfNfgU7abAVNDecaDr42qOvhv2RlHYxIHUDd0gYWgAbAVJa4Vgq5nFFrq81YiN1Kqbqp63wcZbdvqU3ioeKEjYqUKNG67t+HE6Hto3846NZo7B0FXcA0LkEXzcIo3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PjtgMC+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PjtgMC+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E57C4CEED;
	Fri, 25 Jul 2025 02:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409703;
	bh=qv2fD88N1gyB/L38PpZbwnaZtilqcA2p7K+1u6hDpa8=;
	h=Date:To:From:Subject:From;
	b=PjtgMC+DLMT0E4EA+31Xi7ptV1UaREQJj4vLAiY3wM5U2eiKnqwcRcsAVZKsTJPtF
	 xBiUTFnAOxXC1xjUMHNdiSZBlW+LFYJFGyyp6tzItEtI3fiF8LTuphcbb1Q9Mn1nzb
	 kzKYX5QpxWwoj1O32gfLWj/medLv2eEg4EsrFkLE=
Date: Thu, 24 Jul 2025 19:15:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,harry.yoo@oracle.com,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-stable_page_flags-use-snapshot_page.patch removed from -mm tree
Message-Id: <20250725021503.A6E57C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: stable_page_flags(): use snapshot_page()
has been removed from the -mm tree.  Its filename was
     fs-stable_page_flags-use-snapshot_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: fs: stable_page_flags(): use snapshot_page()
Date: Mon, 14 Jul 2025 09:16:54 -0400

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

Link: https://lkml.kernel.org/r/52c16c0f00995a812a55980c2f26848a999a34ab.1752499009.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
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
+	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
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



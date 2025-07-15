Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC233F6
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 00:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752537811; cv=none; b=ngKoK/TRqK90A4GSgvWCUJHm+b1pehqi5BulBKT1GDfXPbxg4nvtaPHm0cgNgrdL/PqJzKEsbNK2ukkLyyg3ejPXV6svP0QnRznM8gaWQrrPUYBBYrP/lxo6VBUQzg1Nl0FiotPntmSHbjFIsFN8jn6Ox7HaMT61VGspdBe76Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752537811; c=relaxed/simple;
	bh=PN31yWRDCWsX/UKgPM1JizTU6CHMa2SqDaL1IKAWpAg=;
	h=Date:To:From:Subject:Message-Id; b=khonIBObRpFm6cfhRxyqLg0g+svlT144jVXT6X8K6AxNL3gpLMMX5f7JqGGVPEuplHl0S7iI3mfdOa0e40gFf0Xu/IH8hXAOMyWJDJM+7EpwWenizelixgNwoVKgNvzP+GhSeYZ/mTt/h11l2csJ34FJWVYas8uo4lqWSaztv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPy6pVoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPy6pVoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D83FC4CEF0;
	Tue, 15 Jul 2025 00:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752537810;
	bh=PN31yWRDCWsX/UKgPM1JizTU6CHMa2SqDaL1IKAWpAg=;
	h=Date:To:From:Subject:From;
	b=YPy6pVoPXrZFALDPmoF01MaLITcuIE8PpuRcSkwS/jyUqtHdNo8czx5gVQqlkSL4H
	 pxS7ChNwC/fgpdaUNY/hKyCIMXoSmlINPH5frGKMSotugFTIWP3pdUFFl8EqcaEjFp
	 jTvrhi+VKfmOwmBtij7QPhXz7QudZKSy/KaUG3S8=
Date: Mon, 14 Jul 2025 17:03:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-introduce-snapshot_page.patch added to mm-new branch
Message-Id: <20250715000330.9D83FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util: introduce snapshot_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-util-introduce-snapshot_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-introduce-snapshot_page.patch

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
Subject: mm/util: introduce snapshot_page()
Date: Mon, 14 Jul 2025 09:16:52 -0400

This commit refactors __dump_page() into snapshot_page().

snapshot_page() tries to take a faithful snapshot of a page and its folio
representation.  The snapshot is returned in the struct page_snapshot
parameter along with additional flags that are best retrieved at snapshot
creation time to reduce race windows.

This function is intended to be used by callers that need a stable
representation of a struct page and struct folio so that pointers or page
information doesn't change while working on a page.

The idea and original implementation of snapshot_page() comes from Matthew
Wilcox with suggestions for improvements from David Hildenbrand.  All bugs
and misconceptions are mine.

Link: https://lkml.kernel.org/r/637a03a05cb2e3df88f84ff9e9f9642374ef813a.1752499009.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 ++++++++++
 mm/debug.c         |   42 ++---------------------
 mm/util.c          |   77 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 38 deletions(-)

--- a/include/linux/mm.h~mm-util-introduce-snapshot_page
+++ a/include/linux/mm.h
@@ -4199,4 +4199,23 @@ static inline bool page_pool_page_is_pp(
 }
 #endif
 
+#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
+#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
+#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+
+struct page_snapshot {
+	struct folio folio_snapshot;
+	struct page page_snapshot;
+	unsigned long pfn;
+	unsigned long idx;
+	unsigned long flags;
+};
+
+static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
+{
+	return ps->flags & PAGE_SNAPSHOT_FAITHFUL;
+}
+
+void snapshot_page(struct page_snapshot *ps, const struct page *page);
+
 #endif /* _LINUX_MM_H */
--- a/mm/debug.c~mm-util-introduce-snapshot_page
+++ a/mm/debug.c
@@ -129,47 +129,13 @@ static void __dump_folio(struct folio *f
 
 static void __dump_page(const struct page *page)
 {
-	struct folio *foliop, folio;
-	struct page precise;
-	unsigned long head;
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long idx, nr_pages = 1;
-	int loops = 5;
+	struct page_snapshot ps;
 
-again:
-	memcpy(&precise, page, sizeof(*page));
-	head = precise.compound_head;
-	if ((head & 1) == 0) {
-		foliop = (struct folio *)&precise;
-		idx = 0;
-		if (!folio_test_large(foliop))
-			goto dump;
-		foliop = (struct folio *)page;
-	} else {
-		foliop = (struct folio *)(head - 1);
-		idx = folio_page_idx(foliop, page);
-	}
-
-	if (idx < MAX_FOLIO_NR_PAGES) {
-		memcpy(&folio, foliop, 2 * sizeof(struct page));
-		nr_pages = folio_nr_pages(&folio);
-		if (nr_pages > 1)
-			memcpy(&folio.__page_2, &foliop->__page_2,
-			       sizeof(struct page));
-		foliop = &folio;
-	}
-
-	if (idx > nr_pages) {
-		if (loops-- > 0)
-			goto again;
+	snapshot_page(&ps, page);
+	if (!snapshot_page_is_faithful(&ps))
 		pr_warn("page does not match folio\n");
-		precise.compound_head &= ~1UL;
-		foliop = (struct folio *)&precise;
-		idx = 0;
-	}
 
-dump:
-	__dump_folio(foliop, &precise, pfn, idx);
+	__dump_folio(&ps.folio_snapshot, &ps.page_snapshot, ps.pfn, ps.idx);
 }
 
 void dump_page(const struct page *page, const char *reason)
--- a/mm/util.c~mm-util-introduce-snapshot_page
+++ a/mm/util.c
@@ -25,6 +25,7 @@
 #include <linux/sizes.h>
 #include <linux/compat.h>
 #include <linux/fsnotify.h>
+#include <linux/page_idle.h>
 
 #include <linux/uaccess.h>
 
@@ -1172,6 +1173,82 @@ int compat_vma_mmap_prepare(struct file
 }
 EXPORT_SYMBOL(compat_vma_mmap_prepare);
 
+static void set_flags(struct page_snapshot *ps, const struct folio *folio,
+		      const struct page *page)
+{
+	/*
+	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
+	 * on the head page.
+	 */
+	if (PageBuddy(page))
+		ps->flags |= PAGE_SNAPSHOT_PG_FREE;
+	else if (page_count(page) == 0 && is_free_buddy_page(page))
+		ps->flags |= PAGE_SNAPSHOT_PG_FREE;
+
+	if (folio_test_idle(folio))
+		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
+}
+
+/*
+ * Create a snapshot of a page and store its struct page and struct folio
+ * representations in a struct page_snapshot.
+ *
+ * @ps: struct page_snapshot to store the page snapshot
+ * @page: the page we want to snapshot
+ *
+ * Note that creating a faithful snapshot of a page may fail if the page
+ * compound keeps changing (eg. due to folio split). In this case we set
+ * ps->faithful to false and the snapshot will assume that @page refers
+ * to a single page.
+ */
+void snapshot_page(struct page_snapshot *ps, const struct page *page)
+{
+	unsigned long head, nr_pages = 1;
+	struct folio *foliop, folio;
+	int loops = 5;
+
+	ps->pfn = page_to_pfn(page);
+	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
+
+again:
+	memcpy(&ps->page_snapshot, page, sizeof(*page));
+	head = ps->page_snapshot.compound_head;
+	if ((head & 1) == 0) {
+		foliop = (struct folio *)&ps->page_snapshot;
+		ps->idx = 0;
+		if (!folio_test_large(foliop)) {
+			set_flags(ps, page_folio(page), page);
+			goto out;
+		}
+		foliop = (struct folio *)page;
+	} else {
+		foliop = (struct folio *)(page->compound_head - 1);
+		ps->idx = folio_page_idx(foliop, page);
+	}
+
+	if (ps->idx < MAX_FOLIO_NR_PAGES) {
+		memcpy(&folio, foliop, 2 * sizeof(struct page));
+		nr_pages = folio_nr_pages(&folio);
+		if (nr_pages > 1)
+			memcpy(&folio.__page_2, &foliop->__page_2,
+			       sizeof(struct page));
+		set_flags(ps, foliop, page);
+		foliop = &folio;
+	}
+
+	if (ps->idx > nr_pages) {
+		if (loops-- > 0)
+			goto again;
+		ps->page_snapshot.compound_head &= ~1UL;
+		foliop = (struct folio *)&ps->page_snapshot;
+		ps->flags = 0;
+		ps->idx = 0;
+	}
+
+out:
+	memcpy(&ps->folio_snapshot, foliop, sizeof(struct folio));
+}
+
 #ifdef CONFIG_MMU
 /**
  * folio_pte_batch - detect a PTE batch for a large folio
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-util-introduce-snapshot_page.patch
proc-kpagecount-use-snapshot_page.patch
fs-stable_page_flags-use-snapshot_page.patch


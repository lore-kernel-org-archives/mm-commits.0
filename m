Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB2A2D46CE
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959472; cv=none; b=jSknh9J06ItBXH9/ZOLaN4Tz30C54H8wSIVaMvgvfyhU8+QdRyCoiUlcA3m4qrz64IY4qDuOmnoDktPOGIJiXI2ew1l8SyvtAdmHrxKY4PRAGWrKlGKNMvVOdYEseBHaAWx8mivYTpraT3+3i0ZxMrF7BlXW5oXGcmzTXzS6aMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959472; c=relaxed/simple;
	bh=Af+LetukyatzcA7PopemVuoZVVID5ybJxLLUSsg3OhM=;
	h=Date:To:From:Subject:Message-Id; b=DkThnU6e9mXcE0eF866WGoeQXQUgxJf65Ri+nO9iabcEdpHlNjDX2NQ4YQUUxKb+ZvRw27cnjJUTolsGEC9cDXqk/Cx1rqr9qkKWFRVJIYjonY+LLc1NUsVFWvqvN9vJB47lzQc8VCjhLpzYuKIwZdalcpyRYQiUK19BEyZLDFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtoiG0Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtoiG0Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38DCC4CEED;
	Tue, 12 Aug 2025 00:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959472;
	bh=Af+LetukyatzcA7PopemVuoZVVID5ybJxLLUSsg3OhM=;
	h=Date:To:From:Subject:From;
	b=ZtoiG0WsUnlAfAy6VtaL8Dctf8YU9nFbmY0ITtnDhZbYayPxZm0C+L2wha7EF6I23
	 bZ4rKog7JLIk6zWsLM7QBQwFcaU4jORX1dW/GFoLQlXJbRb66ED4oDpBR4NGJrsxnC
	 C7zLu2H/xyvNTiL+6+B0fTGf2wZrY87ypjbXJI2s=
Date: Mon, 11 Aug 2025 17:44:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,npache@redhat.com,mhocko@suse.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hch@lst.de,djwong@kernel.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,axboe@kernel.dk,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-persistent-huge-zero-folio.patch added to mm-new branch
Message-Id: <20250812004431.F38DCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add persistent huge zero folio
has been added to the -mm mm-new branch.  Its filename is
     mm-add-persistent-huge-zero-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-persistent-huge-zero-folio.patch

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
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mm: add persistent huge zero folio
Date: Mon, 11 Aug 2025 10:41:11 +0200

Many places in the kernel need to zero out larger chunks, but the maximum
segment that can be zeroed out at a time by ZERO_PAGE is limited by
PAGE_SIZE.

This is especially annoying in block devices and filesystems where
multiple ZERO_PAGEs are attached to the bio in different bvecs.  With
multipage bvec support in block layer, it is much more efficient to send
out larger zero pages as a part of single bvec.

This concern was raised during the review of adding Large Block Size
support to XFS[1][2].

Usually huge_zero_folio is allocated on demand, and it will be deallocated
by the shrinker if there are no users of it left.  At moment,
huge_zero_folio infrastructure refcount is tied to the process lifetime
that created it.  This might not work for bio layer as the completions can
be async and the process that created the huge_zero_folio might no longer
be alive.  And, one of the main points that came up during discussion is
to have something bigger than zero page as a drop-in replacement.

Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will result in
allocating the huge zero folio during early init and never free the memory
by disabling the shrinker.  This makes using the huge_zero_folio without
having to pass any mm struct and does not tie the lifetime of the zero
folio to anything, making it a drop-in replacement for ZERO_PAGE.

If PERSISTENT_HUGE_ZERO_FOLIO config option is enabled, then
mm_get_huge_zero_folio() will simply return the allocated page instead of
dynamically allocating a new PMD page.

Use this option carefully in resource constrained systems as it uses one
full PMD sized page for zeroing purposes.

[1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
[2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/

Link: https://lkml.kernel.org/r/20250811084113.647267-4-kernel@pankajraghav.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   16 +++++++++++++++
 mm/Kconfig              |   16 +++++++++++++++
 mm/huge_memory.c        |   40 ++++++++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 10 deletions(-)

--- a/include/linux/huge_mm.h~mm-add-persistent-huge-zero-folio
+++ a/include/linux/huge_mm.h
@@ -495,6 +495,17 @@ static inline bool is_huge_zero_pmd(pmd_
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
+static inline struct folio *get_persistent_huge_zero_folio(void)
+{
+	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return NULL;
+
+	if (unlikely(!huge_zero_folio))
+		return NULL;
+
+	return huge_zero_folio;
+}
+
 static inline bool thp_migration_supported(void)
 {
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
@@ -685,6 +696,11 @@ static inline int change_huge_pud(struct
 {
 	return 0;
 }
+
+static inline struct folio *get_persistent_huge_zero_folio(void)
+{
+	return NULL;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
--- a/mm/huge_memory.c~mm-add-persistent-huge-zero-folio
+++ a/mm/huge_memory.c
@@ -248,6 +248,9 @@ static void put_huge_zero_folio(void)
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 {
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return huge_zero_folio;
+
 	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
@@ -262,6 +265,9 @@ struct folio *mm_get_huge_zero_folio(str
 
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return;
+
 	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		put_huge_zero_folio();
 }
@@ -849,16 +855,34 @@ static inline void hugepage_exit_sysfs(s
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_folio_shrinker)
-		return -ENOMEM;
-
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						 SHRINKER_MEMCG_AWARE |
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
-	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_folio_shrinker);
+	if (!deferred_split_shrinker)
+		return -ENOMEM;
+
+	deferred_split_shrinker->count_objects = deferred_split_count;
+	deferred_split_shrinker->scan_objects = deferred_split_scan;
+	shrinker_register(deferred_split_shrinker);
+
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
+		/*
+		 * Bump the reference of the huge_zero_folio and do not
+		 * initialize the shrinker.
+		 *
+		 * huge_zero_folio will always be NULL on failure. We assume
+		 * that get_huge_zero_folio() will most likely not fail as
+		 * thp_shrinker_init() is invoked early on during boot.
+		 */
+		if (!get_huge_zero_folio())
+			pr_warn("Allocating persistent huge zero folio failed\n");
+		return 0;
+	}
+
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker) {
+		shrinker_free(deferred_split_shrinker);
 		return -ENOMEM;
 	}
 
@@ -866,10 +890,6 @@ static int __init thp_shrinker_init(void
 	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
 	shrinker_register(huge_zero_folio_shrinker);
 
-	deferred_split_shrinker->count_objects = deferred_split_count;
-	deferred_split_shrinker->scan_objects = deferred_split_scan;
-	shrinker_register(deferred_split_shrinker);
-
 	return 0;
 }
 
--- a/mm/Kconfig~mm-add-persistent-huge-zero-folio
+++ a/mm/Kconfig
@@ -823,6 +823,22 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
+config PERSISTENT_HUGE_ZERO_FOLIO
+	bool "Allocate a PMD sized folio for zeroing"
+	depends on TRANSPARENT_HUGEPAGE
+	help
+	  Enable this option to reduce the runtime refcounting overhead
+	  of the huge zero folio and expand the places in the kernel
+	  that can use huge zero folios. For instance, block I/O benefits
+	  from access to large folios for zeroing memory.
+
+	  With this option enabled, the huge zero folio is allocated
+	  once and never freed. One full huge page's worth of memory shall
+	  be used.
+
+	  Say Y if your system has lots of memory. Say N if you are
+	  memory constrained.
+
 config MM_ID
 	def_bool n
 
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-rename-huge_zero_page-to-huge_zero_folio.patch
mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
mm-add-persistent-huge-zero-folio.patch
mm-add-largest_zero_folio-routine.patch
block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch


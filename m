Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96DA1C5499
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274552; cv=none; b=kT1SQzD4XiNcTlDgSJmP+lILb7jf84lkLcjcxq73WsHKBCq6EayLqrsZQAfZopDGlW3YQUwbw3dzNBNrjgHzfLSJc2wv0OG+jCtRDdxJHW1CmGoPZ+g7V/p6rr/CgXDKMRq1Gm4CvGpMZ5BrniJxlj2h8cmvtf6xLFq6bnqYtfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274552; c=relaxed/simple;
	bh=wPUV82F8LZs+1v9F3wrfb20MK5Jo5q/ZX642jm3UZ7c=;
	h=Date:To:From:Subject:Message-Id; b=tp/sTiIQb1rCiQjrhZ+AwQDdDIHQ6oCxeso8V0JPxEbzu3VgQIuUhd5ts4jEGWnEnNBwToXRr7jlry5D10adCRmzKeBOTUVUTYaeujm4K3OfCyft1dvZ0z217dbhxl+jDSGVa0SvvlOyOsTXRgvX9lP3UksDpINWZN7cK4HtTcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D8JzpLFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D8JzpLFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D61BC4CEDD;
	Tue, 18 Mar 2025 05:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274552;
	bh=wPUV82F8LZs+1v9F3wrfb20MK5Jo5q/ZX642jm3UZ7c=;
	h=Date:To:From:Subject:From;
	b=D8JzpLFAOhNA1TTcrqQpTOxdPuFejt8d+FfMYieTPnZPjAq2lwvTrH1UPUZk0qykg
	 8JLDYa6ZWdZptDWhKhIh6aJ8ViP+ynrFHUaY9C8d8PXJ56PRnxRBnO2N3vxwEDw3Gj
	 e4emYGMwJwKu3Ti5w4wEWSL9QQfZWQeWcq6sox2c=
Date: Mon, 17 Mar 2025 22:09:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch removed from -mm tree
Message-Id: <20250318050912.8D61BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: remove per-page mapcount dependency for smaps/smaps_rollup (CONFIG_NO_PAGE_MAPCOUNT)
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: remove per-page mapcount dependency for smaps/smaps_rollup (CONFIG_NO_PAGE_MAPCOUNT)
Date: Mon, 3 Mar 2025 17:30:12 +0100

Let's implement an alternative when per-page mapcounts in large folios are
no longer maintained -- soon with CONFIG_NO_PAGE_MAPCOUNT.

When computing the output for smaps / smaps_rollups, in particular when
calculating the USS (Unique Set Size) and the PSS (Proportional Set Size),
we still rely on per-page mapcounts.

To determine private vs.  shared, we'll use folio_likely_mapped_shared(),
similar to how we handle PM_MMAP_EXCLUSIVE.  Similarly, we might now
under-estimate the USS and count pages towards "shared" that are actually
"private" ("exclusively mapped").

When calculating the PSS, we'll now also use the average per-page mapcount
for large folios: this can result in both, an over-estimation and an
under-estimation of the PSS.  The difference is not expected to matter
much in practice, but we'll have to learn as we go.

We can now provide folio_precise_page_mapcount() only with
CONFIG_PAGE_MAPCOUNT, and remove one of the last users of per-page
mapcounts when CONFIG_NO_PAGE_MAPCOUNT is enabled.

Document the new behavior.

Link: https://lkml.kernel.org/r/20250303163014.1128035-20-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   22 +++++++++++++++++++---
 fs/proc/internal.h                 |    8 ++++++++
 fs/proc/task_mmu.c                 |   17 +++++++++++++++--
 3 files changed, 42 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/proc.rst~fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount
+++ a/Documentation/filesystems/proc.rst
@@ -502,9 +502,25 @@ process, its PSS will be 1500.  "Pss_Dir
 consists of dirty pages.  ("Pss_Clean" is not included, but it can be
 calculated by subtracting "Pss_Dirty" from "Pss".)
 
-Note that even a page which is part of a MAP_SHARED mapping, but has only
-a single pte mapped, i.e.  is currently used by only one process, is accounted
-as private and not as shared.
+Traditionally, a page is accounted as "private" if it is mapped exactly once,
+and a page is accounted as "shared" when mapped multiple times, even when
+mapped in the same process multiple times. Note that this accounting is
+independent of MAP_SHARED.
+
+In some kernel configurations, the semantics of pages part of a larger
+allocation (e.g., THP) can differ: a page is accounted as "private" if all
+pages part of the corresponding large allocation are *certainly* mapped in the
+same process, even if the page is mapped multiple times in that process. A
+page is accounted as "shared" if any page page of the larger allocation
+is *maybe* mapped in a different process. In some cases, a large allocation
+might be treated as "maybe mapped by multiple processes" even though this
+is no longer the case.
+
+Some kernel configurations do not track the precise number of times a page part
+of a larger allocation is mapped. In this case, when calculating the PSS, the
+average number of mappings per page in this larger allocation might be used
+as an approximation for the number of mappings of a page. The PSS calculation
+will be imprecise in this case.
 
 "Referenced" indicates the amount of memory currently marked as referenced or
 accessed.
--- a/fs/proc/internal.h~fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount
+++ a/fs/proc/internal.h
@@ -157,6 +157,7 @@ unsigned name_to_int(const struct qstr *
 /* Worst case buffer size needed for holding an integer. */
 #define PROC_NUMBUF 13
 
+#ifdef CONFIG_PAGE_MAPCOUNT
 /**
  * folio_precise_page_mapcount() - Number of mappings of this folio page.
  * @folio: The folio.
@@ -187,6 +188,13 @@ static inline int folio_precise_page_map
 
 	return mapcount;
 }
+#else /* !CONFIG_PAGE_MAPCOUNT */
+static inline int folio_precise_page_mapcount(struct folio *folio,
+		struct page *page)
+{
+	BUILD_BUG();
+}
+#endif /* CONFIG_PAGE_MAPCOUNT */
 
 /**
  * folio_average_page_mapcount() - Average number of mappings per page in this
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount
+++ a/fs/proc/task_mmu.c
@@ -707,6 +707,8 @@ static void smaps_account(struct mem_siz
 	struct folio *folio = page_folio(page);
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
+	bool exclusive;
+	int mapcount;
 
 	/*
 	 * First accumulate quantities that depend only on |size| and the type
@@ -747,18 +749,29 @@ static void smaps_account(struct mem_siz
 				      dirty, locked, present);
 		return;
 	}
+
+	if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
+		mapcount = folio_average_page_mapcount(folio);
+		exclusive = !folio_maybe_mapped_shared(folio);
+	}
+
 	/*
 	 * We obtain a snapshot of the mapcount. Without holding the folio lock
 	 * this snapshot can be slightly wrong as we cannot always read the
 	 * mapcount atomically.
 	 */
 	for (i = 0; i < nr; i++, page++) {
-		int mapcount = folio_precise_page_mapcount(folio, page);
 		unsigned long pss = PAGE_SIZE << PSS_SHIFT;
+
+		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT)) {
+			mapcount = folio_precise_page_mapcount(folio, page);
+			exclusive = mapcount < 2;
+		}
+
 		if (mapcount >= 2)
 			pss /= mapcount;
 		smaps_page_accumulate(mss, folio, PAGE_SIZE, pss,
-				dirty, locked, mapcount < 2);
+				dirty, locked, exclusive);
 	}
 }
 
_

Patches currently in -mm which might be from david@redhat.com are



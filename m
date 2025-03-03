Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A402023814F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042594; cv=none; b=NStXdFNRyMcDrJDJOtb+mvPphKSqJu3gttzvKT6fPt+xS4M7aLqg1UgOSGJXnllHfQJ97JbHsfcBPGgd5JMSRbDG6cw/CBnqXK0kLFoOlzJjPjTcqCLiCBhFKC5pPYA0soVx0qnqZc667scHVG+DLGG0O990qob8IH/854AlIFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042594; c=relaxed/simple;
	bh=0yzGsAri5c2YHSXL9wVXnvvLjNfqCJpf5mkOyQAWoo0=;
	h=Date:To:From:Subject:Message-Id; b=uUSoPQEp6wvjYB/089KK756/wTyABJEFoR7QPk6GEM60j3SG2u0mJeZe7zNy6YWdcawJpHj3NJmTuJT93NzAL8ulA7yhNn0rqTEmsXaFaoHIpz0iZyMt7jOauCGXiXQZ0KWjPq5FqKwVYnN8kLL07wAViIOU4ax0Eo+5QeHOtII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yq+KYnlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yq+KYnlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DD1C4CEE8;
	Mon,  3 Mar 2025 22:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042594;
	bh=0yzGsAri5c2YHSXL9wVXnvvLjNfqCJpf5mkOyQAWoo0=;
	h=Date:To:From:Subject:From;
	b=Yq+KYnlHlc23aOzufaRXlumMie3gWLZ/eHz+iDSlob7OCD5GDOGf17ItbeiW+83+V
	 L/g59R6KVVNzgQBj8nn7mzpsEApsQnT9wTnbbZGtTdq1svJ8JtAxKfqpX8m8eSjBHA
	 A1bc6wTae/jAQKY5wNQykBvJZ+EWNwuAn6woufy4=
Date: Mon, 03 Mar 2025 14:56:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch added to mm-unstable branch
Message-Id: <20250303225634.13DD1C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: remove per-page mapcount dependency for smaps/smaps_rollup (CONFIG_NO_PAGE_MAPCOUNT)
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -143,6 +143,7 @@ unsigned name_to_int(const struct qstr *
 /* Worst case buffer size needed for holding an integer. */
 #define PROC_NUMBUF 13
 
+#ifdef CONFIG_PAGE_MAPCOUNT
 /**
  * folio_precise_page_mapcount() - Number of mappings of this folio page.
  * @folio: The folio.
@@ -173,6 +174,13 @@ static inline int folio_precise_page_map
 
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

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch
lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch
mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch
mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch
mm-memory-document-restore_exclusive_pte.patch
mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch
mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A151238D27
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042559; cv=none; b=CzBkK3/dhraXq96/yCZ7ldcB8zxhxj9O8EcCJ+WS9zUxhyxq9UHyTAJx3hVIQ/t/oKaueG2q0s5zFMEp/Piypx1egH+RASNs1HxvyJqEOXyWXycC8IxJWZuopTQMm9tn8ylNOhUbEQ/qNhF1illS6DjmyGtplCGHtvsKt+bKy0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042559; c=relaxed/simple;
	bh=OPFWfTfDBgwRL0gghCL8uDJeBCOfRuyxxfz6MiC+7KA=;
	h=Date:To:From:Subject:Message-Id; b=BaDpYwzoIDp4PktFcrCp/dwsA1g7l0KUfviGLYO4dJBXD8cczSpzIy5IdOGde1fHbz89AHpAzEFAkotB+GFXBgV5MMr0QblIB9B6BMBM75QJqGSWK6NVFNl5IiYD51QMJtL/4KwiLSA/YWvtilzYYxI4fgHIGN4ZSD6LKDx5DZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHhb7uvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHhb7uvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA94C4CEE8;
	Mon,  3 Mar 2025 22:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741042559;
	bh=OPFWfTfDBgwRL0gghCL8uDJeBCOfRuyxxfz6MiC+7KA=;
	h=Date:To:From:Subject:From;
	b=lHhb7uvtailt3E5LkpZK2eU9pBuxELwZiJMZeZE1RP7BO5x5a7IHtZvOQKM8MvlFy
	 MumHi7YxisB8WvyFMmQ+ZglVgxQemV4LropDrzAnoaftl9PgIUMXQ0X5Lvbd7+60rR
	 agevanimDZ5aFioShvnJorpylMYb3L9wHJeKDBIg=
Date: Mon, 03 Mar 2025 14:55:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch added to mm-unstable branch
Message-Id: <20250303225559.1DA94C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: abstract large mapcount operations for large folios (!hugetlb)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch

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
Subject: mm/rmap: abstract large mapcount operations for large folios (!hugetlb)
Date: Mon, 3 Mar 2025 17:30:02 +0100

Let's abstract the operations so we can extend these operations easily.

Link: https://lkml.kernel.org/r/20250303163014.1128035-10-david@redhat.com
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

 include/linux/rmap.h |   32 ++++++++++++++++++++++++++++----
 mm/rmap.c            |   14 ++++++--------
 2 files changed, 34 insertions(+), 12 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb
+++ a/include/linux/rmap.h
@@ -173,6 +173,30 @@ static inline void anon_vma_merge(struct
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
+static inline void folio_set_large_mapcount(struct folio *folio, int mapcount,
+		struct vm_area_struct *vma)
+{
+	/* Note: mapcounts start at -1. */
+	atomic_set(&folio->_large_mapcount, mapcount - 1);
+}
+
+static inline void folio_add_large_mapcount(struct folio *folio,
+		int diff, struct vm_area_struct *vma)
+{
+	atomic_add(diff, &folio->_large_mapcount);
+}
+
+static inline void folio_sub_large_mapcount(struct folio *folio,
+		int diff, struct vm_area_struct *vma)
+{
+	atomic_sub(diff, &folio->_large_mapcount);
+}
+
+#define folio_inc_large_mapcount(folio, vma) \
+	folio_add_large_mapcount(folio, 1, vma)
+#define folio_dec_large_mapcount(folio, vma) \
+	folio_sub_large_mapcount(folio, 1, vma)
+
 /* RMAP flags, currently only relevant for some anon rmap operations. */
 typedef int __bitwise rmap_t;
 
@@ -352,12 +376,12 @@ static __always_inline void __folio_dup_
 		do {
 			atomic_inc(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
-		atomic_add(orig_nr_pages, &folio->_large_mapcount);
+		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
 	case RMAP_LEVEL_PMD:
 	case RMAP_LEVEL_PUD:
 		atomic_inc(&folio->_entire_mapcount);
-		atomic_inc(&folio->_large_mapcount);
+		folio_inc_large_mapcount(folio, dst_vma);
 		break;
 	}
 }
@@ -451,7 +475,7 @@ static __always_inline int __folio_try_d
 				ClearPageAnonExclusive(page);
 			atomic_inc(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
-		atomic_add(orig_nr_pages, &folio->_large_mapcount);
+		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
 	case RMAP_LEVEL_PMD:
 	case RMAP_LEVEL_PUD:
@@ -461,7 +485,7 @@ static __always_inline int __folio_try_d
 			ClearPageAnonExclusive(page);
 		}
 		atomic_inc(&folio->_entire_mapcount);
-		atomic_inc(&folio->_large_mapcount);
+		folio_inc_large_mapcount(folio, dst_vma);
 		break;
 	}
 	return 0;
--- a/mm/rmap.c~mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb
+++ a/mm/rmap.c
@@ -1266,7 +1266,7 @@ static __always_inline unsigned int __fo
 		    atomic_add_return_relaxed(first, mapped) < ENTIRELY_MAPPED)
 			nr = first;
 
-		atomic_add(orig_nr_pages, &folio->_large_mapcount);
+		folio_add_large_mapcount(folio, orig_nr_pages, vma);
 		break;
 	case RMAP_LEVEL_PMD:
 	case RMAP_LEVEL_PUD:
@@ -1290,7 +1290,7 @@ static __always_inline unsigned int __fo
 				nr = 0;
 			}
 		}
-		atomic_inc(&folio->_large_mapcount);
+		folio_inc_large_mapcount(folio, vma);
 		break;
 	}
 	return nr;
@@ -1556,14 +1556,12 @@ void folio_add_new_anon_rmap(struct foli
 				SetPageAnonExclusive(page);
 		}
 
-		/* increment count (starts at -1) */
-		atomic_set(&folio->_large_mapcount, nr - 1);
+		folio_set_large_mapcount(folio, nr, vma);
 		atomic_set(&folio->_nr_pages_mapped, nr);
 	} else {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_entire_mapcount, 0);
-		/* increment count (starts at -1) */
-		atomic_set(&folio->_large_mapcount, 0);
+		folio_set_large_mapcount(folio, 1, vma);
 		atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
 		if (exclusive)
 			SetPageAnonExclusive(&folio->page);
@@ -1665,7 +1663,7 @@ static __always_inline void __folio_remo
 			break;
 		}
 
-		atomic_sub(nr_pages, &folio->_large_mapcount);
+		folio_sub_large_mapcount(folio, nr_pages, vma);
 		do {
 			last += atomic_add_negative(-1, &page->_mapcount);
 		} while (page++, --nr_pages > 0);
@@ -1678,7 +1676,7 @@ static __always_inline void __folio_remo
 		break;
 	case RMAP_LEVEL_PMD:
 	case RMAP_LEVEL_PUD:
-		atomic_dec(&folio->_large_mapcount);
+		folio_dec_large_mapcount(folio, vma);
 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
 			nr = atomic_sub_return_relaxed(ENTIRELY_MAPPED, mapped);
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


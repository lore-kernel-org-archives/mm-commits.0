Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC75B42A82
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663223; cv=none; b=S55Dxl2Mbtx9d5v1F+1KCkXTrSehS7S9nCIPLckBPqA1nbxpEsFT8hn0i8YHrCnG/w9imfPoEGRp7AfvXn5t1T6yx030BY1RaRfZbhO3XB7OiGHej7CFncpKnvovBSgCcELYWUQ6lN47J5ypOHGIhKUScCixY/E3JHqO3AQuMxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663223; c=relaxed/simple;
	bh=Fw8zmEHDi82OSYyTen5MKArz8WC+2ZJ4A+IyYKHwLkk=;
	h=Date:To:From:Subject:Message-Id; b=t89r+1zgECn+RJxqK1Jpm3zOnySJta+CNpWury0mNBWFj51lhYzXTZY2mGJ+fqmBYU0sPWkziDGV58Nn9tpRdyl5OZfQcQ0Gdz2qZ4e5HF2G8Iau7pNpl1aXiyFCBJY5GaTLn75NzvV6pC2RMM1WfRmd4S2/ylr1nC3Ae2jiytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUz3lG/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUz3lG/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265C5C116B1;
	Sat,  3 Aug 2024 05:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663223;
	bh=Fw8zmEHDi82OSYyTen5MKArz8WC+2ZJ4A+IyYKHwLkk=;
	h=Date:To:From:Subject:From;
	b=nUz3lG/OOmACt2mBlQox362DLU6r3VeO13YQtXIalb6Gn3Y62bL9D2tSSCIDqnjox
	 ylGXFOTIJDSoKL46TEN/9JPTHo0Qo7xhPggxO6XyypT+s8rXMbmiTM1HCMhsBqmmrw
	 BM9ePHjFNfwNNeQigUzsz80dkTUeI5dZbedCBD34=
Date: Fri, 02 Aug 2024 22:33:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053343.265C5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: convert get_mergeable_page() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch

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
Subject: mm/ksm: convert get_mergeable_page() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:18 +0200

Let's use folio_walk instead, for example avoiding taking temporary folio
references if the folio does not even apply and getting rid of one more
follow_page() user.

Note that zeropages obviously don't apply: old code could just have
specified FOLL_DUMP.  Anon folios are never secretmem, so we don't care
about losing the check in follow_page().

Link: https://lkml.kernel.org/r/20240802155524.517137-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/mm/ksm.c~mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk
+++ a/mm/ksm.c
@@ -767,26 +767,28 @@ static struct page *get_mergeable_page(s
 	struct mm_struct *mm = rmap_item->mm;
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
-	struct page *page;
+	struct page *page = NULL;
+	struct folio_walk fw;
+	struct folio *folio;
 
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (!vma)
 		goto out;
 
-	page = follow_page(vma, addr, FOLL_GET);
-	if (IS_ERR_OR_NULL(page))
-		goto out;
-	if (is_zone_device_page(page))
-		goto out_putpage;
-	if (PageAnon(page)) {
+	folio = folio_walk_start(&fw, vma, addr, 0);
+	if (folio) {
+		if (!folio_is_zone_device(folio) &&
+		    folio_test_anon(folio)) {
+			folio_get(folio);
+			page = fw.page;
+		}
+		folio_walk_end(&fw, vma);
+	}
+out:
+	if (page) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
-	} else {
-out_putpage:
-		put_page(page);
-out:
-		page = NULL;
 	}
 	mmap_read_unlock(mm);
 	return page;
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch


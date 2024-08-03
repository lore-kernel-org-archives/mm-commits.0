Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537CB42A82
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663225; cv=none; b=IYbuj4mpbB7ukuq5tfhktrFeFnyUEqohfnzDxRNp77wtaybkvEJ0cjprHWSxmXLk34pYq+7qd/2m5R1hEURp0rWSZanwBOHDQlBalojWiSXCwvN6SDUqGsC+H2HhOmzbIh2kk5O8ElAhWUe1Z32bSMcW/QW9unsphek4Xjhb85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663225; c=relaxed/simple;
	bh=DvBs4qYOwk1/SNLro845sqJ378w6IzAHG2LiZKnraeQ=;
	h=Date:To:From:Subject:Message-Id; b=kQZ0yEOhMif3dMurkpnETxJjtP3vKvkY0MAGCwJO31tmV/6VS+eDvsJnXA45mnCelzyLUM27xhxpAgGz/+LhXSi71t8EnoYBS6aQZ/PAHBFiKAUFM9IiFui7xl1+NhmcNAKKAA15WxXCgEcOlwEDl5ODyNXpNck7L1VPOzEfhyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=COTk6i0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="COTk6i0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F0C116B1;
	Sat,  3 Aug 2024 05:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663224;
	bh=DvBs4qYOwk1/SNLro845sqJ378w6IzAHG2LiZKnraeQ=;
	h=Date:To:From:Subject:From;
	b=COTk6i0Lp83cIO7ORfYpAqe9DxCuKCHsiQ/4cOB5saOkqouBsYanPB7Z1nVNzcW8Y
	 WfSNaQYHNzW874AmE9DtgWBxR5VvwhyYe/s0mq58XQVCL9MWyvuZrW96AV9JT3Auq5
	 q6MfHPklyHQazFtpO4a1uQSZKSHFtRJJBUIuPLeQ=
Date: Fri, 02 Aug 2024 22:33:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053344.AB8F0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: convert scan_get_next_rmap_item() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch

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
Subject: mm/ksm: convert scan_get_next_rmap_item() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:19 +0200

Let's use folio_walk instead, for example avoiding taking temporary folio
references if the folio does obviously not even apply and getting rid of
one more follow_page() user.  We cannot move all handling under the PTL,
so leave the rmap handling (which implies an allocation) out.

Note that zeropages obviously don't apply: old code could just have
specified FOLL_DUMP.  Further, we don't care about losing the secretmem
check in follow_page(): these are never anon pages and
vma_ksm_compatible() would never consider secretmem vmas (VM_SHARED |
VM_MAYSHARE must be set for secretmem, see secretmem_mmap()).

Link: https://lkml.kernel.org/r/20240802155524.517137-7-david@redhat.com
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

 mm/ksm.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/mm/ksm.c~mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk
+++ a/mm/ksm.c
@@ -2564,36 +2564,46 @@ next_mm:
 			ksm_scan.address = vma->vm_end;
 
 		while (ksm_scan.address < vma->vm_end) {
+			struct page *tmp_page = NULL;
+			struct folio_walk fw;
+			struct folio *folio;
+
 			if (ksm_test_exit(mm))
 				break;
-			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
-			if (IS_ERR_OR_NULL(*page)) {
-				ksm_scan.address += PAGE_SIZE;
-				cond_resched();
-				continue;
+
+			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
+			if (folio) {
+				if (!folio_is_zone_device(folio) &&
+				     folio_test_anon(folio)) {
+					folio_get(folio);
+					tmp_page = fw.page;
+				}
+				folio_walk_end(&fw, vma);
 			}
-			if (is_zone_device_page(*page))
-				goto next_page;
-			if (PageAnon(*page)) {
-				flush_anon_page(vma, *page, ksm_scan.address);
-				flush_dcache_page(*page);
+
+			if (tmp_page) {
+				flush_anon_page(vma, tmp_page, ksm_scan.address);
+				flush_dcache_page(tmp_page);
 				rmap_item = get_next_rmap_item(mm_slot,
 					ksm_scan.rmap_list, ksm_scan.address);
 				if (rmap_item) {
 					ksm_scan.rmap_list =
 							&rmap_item->rmap_list;
 
-					if (should_skip_rmap_item(*page, rmap_item))
+					if (should_skip_rmap_item(tmp_page, rmap_item)) {
+						folio_put(folio);
 						goto next_page;
+					}
 
 					ksm_scan.address += PAGE_SIZE;
-				} else
-					put_page(*page);
+					*page = tmp_page;
+				} else {
+					folio_put(folio);
+				}
 				mmap_read_unlock(mm);
 				return rmap_item;
 			}
 next_page:
-			put_page(*page);
 			ksm_scan.address += PAGE_SIZE;
 			cond_resched();
 		}
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A67846434
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247747; cv=none; b=Pxo/jgATQoh1SWFRnUKQtWl6WjncWDXSL+MV8Fuk6gwN7KEr+AJZjGJUZ+JYouiycN35CLmVdCIEx1XFyKbKBWvSEd5RjDXCldP6VpRYlHlKH1CSsHYqPxOPff+v4E0lHyebwSfPdViQ4qK0tTb94CHs9PLoAHSwNPVcye5nJXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247747; c=relaxed/simple;
	bh=/2coSj8R3Q8+OICIj7CoseYOfeiVxv7gDtEOWZNMxnk=;
	h=Date:To:From:Subject:Message-Id; b=DAA1o2gF2KvqbsIop9Tm057wzQCUXjKh80eGzejy+zw2ZwzfaTzB3Y7WzldBCjroCdFQgDzfvlY2WdN9MuekNYAqFSWmN9BU2K1Oa41WU1lLK/XRKvV5Sz7jx1vtBS5AvPM/3HnJIXWIWDyQRyKmSJsA2QAXAQxPwMBjKa4NvrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C9z5Zr9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C9z5Zr9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66459C4CEC2;
	Mon,  2 Sep 2024 03:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247747;
	bh=/2coSj8R3Q8+OICIj7CoseYOfeiVxv7gDtEOWZNMxnk=;
	h=Date:To:From:Subject:From;
	b=C9z5Zr9i8gw52+nQKCM5IaRjutiUlp6vRWaW3hw2Tmn7mNss2BevHI/GHSnhTyTK0
	 tR9MM+1iahsvOlnIIEWHmaGEuLS/AxxqqQHpWjU6AERvnfgLYDuY3nbsOQXvM44GP8
	 HVK9WtGhTSZR6kWzLwtGWNsz7k93rEYag8jokvZ4=
Date: Sun, 01 Sep 2024 20:29:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032907.66459C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: convert scan_get_next_rmap_item() from follow_page() to folio_walk
has been removed from the -mm tree.  Its filename was
     mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch


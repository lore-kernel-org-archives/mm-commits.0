Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4CC5475C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247746; cv=none; b=YWEeW5X6k18xCvmj227/0FYjlNouM2F37C3dO9Vp7S0QVQO6e0QjGgFgMFOvwYBqQzPqq+RDsBNhA48zVhtMdua7Ozj4P7a1jJ/ABrYNkbsj366vNFHF5W7OvtdbPEZ/0eZe8IJOwHbxXxB9r6ebVyTebm58i02HWa/DYwN0gao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247746; c=relaxed/simple;
	bh=ES0y6LBlnbS9Wnp9tEsbfQbejzsANY6SisNcCpuUH6I=;
	h=Date:To:From:Subject:Message-Id; b=KgfCwXnUyiDXSDc7jY4T6GTYGiC4BEIk3oJT6anj4xFP5ITacDMowCDBMwc7JCXdWWqAh95N7uaUiFkGeUa2AFUyd/gojfbESnZchWRWiEDsobn0a3KdCp2OifYS3ie7g92ZhZINRwejgpVQhvFbvsvQLXIBe4NDQ+BfKkdacIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qLXS0WxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qLXS0WxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C38C4CEC2;
	Mon,  2 Sep 2024 03:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247746;
	bh=ES0y6LBlnbS9Wnp9tEsbfQbejzsANY6SisNcCpuUH6I=;
	h=Date:To:From:Subject:From;
	b=qLXS0WxSXUcUD7A0BKBR69D9L2L5qXJZPrTQO/+jcHUzlQIHnEyhu7ox55qbuAbJL
	 5SJrPzY+3oog3pNAPTvdxXPZWeNpQYCQ2kloDeIqhPU3Za+7rWuT76K/qdAsqRgU5G
	 1cbDhqpeOFHSQkaMvlBsXHhiSF/l5ul/NaZ3TB4A=
Date: Sun, 01 Sep 2024 20:29:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032906.35C38C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: convert get_mergeable_page() from follow_page() to folio_walk
has been removed from the -mm tree.  Its filename was
     mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch


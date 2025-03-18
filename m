Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF471C5F1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274617; cv=none; b=T4slOYW9DROeUxWxDGEgSeCQ50766hN+pHhqxtuXLnQecnJRTv6g2ugMhMeucLo1rQGyBNSNmttSI8t+AcaouuUmQZrtirxghod9edNSTNHdxW08bkzLMrCtBdEqnivEbXwk3LSuWHiNgO+3WsvnvjPtoSBm13igmObIkHVdMIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274617; c=relaxed/simple;
	bh=ZtcWt98zPjf5an8VHUuKPS06RrTob3cKbGsukqGFQRA=;
	h=Date:To:From:Subject:Message-Id; b=cpdNnoBs67J8OOkYzU1N3TpB8ueV5bpaX4WqZyxQUrfjr08Uo+3Tp7HGiVNGYmygn+Xgi6inheOgvzMnOSWStzWz8JkEjZLs++DIfdl2711bng3t+SPuYSfWBDdLvJj9EuKTHx8rG4iRU7aTzCtUiOrM0y02Tr/w+/4FPLwdpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Qm1J32B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Qm1J32B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6637C4CEDD;
	Tue, 18 Mar 2025 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274616;
	bh=ZtcWt98zPjf5an8VHUuKPS06RrTob3cKbGsukqGFQRA=;
	h=Date:To:From:Subject:From;
	b=1Qm1J32Bn9e4iiI/56fW2nYJEMRP/VnLzraSuVWATqNtJZx7tsMts0232DQELHEAk
	 F4Lcop3Ym3IfVGChvgRLTdzaoj8s03mtai1EOfpPTcWkhdVcvmbalkYEKFJChgpByC
	 9lugZf9+sHZC5GwIKiKYhQ1/3hIEEFkpGPXFKaCM=
Date: Mon, 17 Mar 2025 22:10:16 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250318051016.B6637C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: convert adjust_range_hwpoison() to take a folio
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: convert adjust_range_hwpoison() to take a folio
Date: Wed, 26 Feb 2025 16:31:30 +0000

Remove a use of folio->page by passing the folio into
adjust_range_hwpoison().  We need to convert to a page eventually, but
that can happen inside adjust_range_hwpoison().

Link: https://lkml.kernel.org/r/20250226163131.3795869-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-convert-adjust_range_hwpoison-to-take-a-folio
+++ a/fs/hugetlbfs/inode.c
@@ -193,19 +193,21 @@ hugetlb_get_unmapped_area(struct file *f
 }
 
 /*
- * Someone wants to read @bytes from a HWPOISON hugetlb @page from @offset.
+ * Someone wants to read @bytes from a HWPOISON hugetlb @folio from @offset.
  * Returns the maximum number of bytes one can read without touching the 1st raw
- * HWPOISON subpage.
+ * HWPOISON page.
  *
  * The implementation borrows the iteration logic from copy_page_to_iter*.
  */
-static size_t adjust_range_hwpoison(struct page *page, size_t offset, size_t bytes)
+static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
+		size_t bytes)
 {
+	struct page *page;
 	size_t n = 0;
 	size_t res = 0;
 
-	/* First subpage to start the loop. */
-	page = nth_page(page, offset / PAGE_SIZE);
+	/* First page to start the loop. */
+	page = folio_page(folio, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
 	while (1) {
 		if (is_raw_hwpoison_page_in_hugepage(page))
@@ -278,10 +280,10 @@ static ssize_t hugetlbfs_read_iter(struc
 			else {
 				/*
 				 * Adjust how many bytes safe to read without
-				 * touching the 1st raw HWPOISON subpage after
+				 * touching the 1st raw HWPOISON page after
 				 * offset.
 				 */
-				want = adjust_range_hwpoison(&folio->page, offset, nr);
+				want = adjust_range_hwpoison(folio, offset, nr);
 				if (want == 0) {
 					folio_put(folio);
 					retval = -EIO;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch


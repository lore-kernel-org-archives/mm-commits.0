Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B0628DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489826; cv=none; b=W7QPEewoL+dyQf+PAf45GbO5aZaimIKELP1unDa6PB9p2/6ucglkrjMX6rmlFtaL0PU4rUxAxeFeAbhoWdInnscdzeelP0EfMffQzL2rGmCxt+zFBaXryD5cAJIVjgiIEIKKU6kwwUopFUUgIv0wQTBMTZyBGo8rmefkWecjl08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489826; c=relaxed/simple;
	bh=MA663ADIQJdpMncUSe91iWTYFBF4wmGUpgDhKDOG9Kk=;
	h=Date:To:From:Subject:Message-Id; b=Op/n4o0HwW0voAVJq208G8yvapBXG20R/2n+cxcTUAAoBRKmSye+uDGOpSvdQlZAD2A1khepov8uC2Jv0QUBHlZWjvCHQKA5dA7bgFHU1TgVQGi6PjYsC+RiFbUbG7ubuXZoKLVV+JezrvTPLTiyEnLZdy1JFjiUtYyubux3LHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7Pvv/Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7Pvv/Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7DC4CEE7;
	Sun, 21 Sep 2025 21:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489826;
	bh=MA663ADIQJdpMncUSe91iWTYFBF4wmGUpgDhKDOG9Kk=;
	h=Date:To:From:Subject:From;
	b=h7Pvv/HnRXiY7q47wJSW/oP51O2bWNWKY7aEy3yPrfis8//2P8HIN2vipix/iwPxq
	 FQ7FWVL61dfhCgch1KB6YZxlMD/p23zjJR8syXfVmVUJoS7zt8At8Ms24GmycgKS76
	 vJKTnm0anjlRIshx92bMmPP/w+OGDeUbCDtm4KyQ=
Date: Sun, 21 Sep 2025 14:23:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison.patch removed from -mm tree
Message-Id: <20250921212346.17A7DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()
Date: Mon, 1 Sep 2025 17:03:37 +0200

Let's cleanup and simplify the function a bit.

Link: https://lkml.kernel.org/r/20250901150359.867252-17-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison
+++ a/fs/hugetlbfs/inode.c
@@ -192,37 +192,25 @@ hugetlb_get_unmapped_area(struct file *f
  * Someone wants to read @bytes from a HWPOISON hugetlb @folio from @offset.
  * Returns the maximum number of bytes one can read without touching the 1st raw
  * HWPOISON page.
- *
- * The implementation borrows the iteration logic from copy_page_to_iter*.
  */
 static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 		size_t bytes)
 {
-	struct page *page;
-	size_t n = 0;
-	size_t res = 0;
+	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t safe_bytes;
 
-	/* First page to start the loop. */
-	page = folio_page(folio, offset / PAGE_SIZE);
-	offset %= PAGE_SIZE;
-	while (1) {
-		if (is_raw_hwpoison_page_in_hugepage(page))
-			break;
+	if (is_raw_hwpoison_page_in_hugepage(page))
+		return 0;
+	/* Safe to read the remaining bytes in this page. */
+	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
+	page++;
 
-		/* Safe to read n bytes without touching HWPOISON subpage. */
-		n = min(bytes, (size_t)PAGE_SIZE - offset);
-		res += n;
-		bytes -= n;
-		if (!bytes || !n)
+	/* Check each remaining page as long as we are not done yet. */
+	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
+		if (is_raw_hwpoison_page_in_hugepage(page))
 			break;
-		offset += n;
-		if (offset == PAGE_SIZE) {
-			page++;
-			offset = 0;
-		}
-	}
 
-	return res;
+	return min(safe_bytes, bytes);
 }
 
 /*
_

Patches currently in -mm which might be from david@redhat.com are



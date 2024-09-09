Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFCC18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925214; cv=none; b=X+JZEZ61kkk5V/rWOQPcZmZ2o/7oZGVA4QBSZPZRHo3yv+/9QeuTv+H8882RNvy3XVp+ojpHyvURHC4YXyhF222criKULBuSWQVXQxg8sVUBgmOlPSkOhNo/JHW/Ya2yex+ddt9Vhe+mqF0sV40aLj89OF/NXBr6K495Uv7ohng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925214; c=relaxed/simple;
	bh=hAXgghNS623rALZdA4dujhmp26sEb8PAQqWSZVhoY9w=;
	h=Date:To:From:Subject:Message-Id; b=FWAbGu+r9I5wGrGiZP0+UJjldWGtuszTYyNTZ/ciAmPJnjeobFl6t6oB6rPY2JDXwGAwHifpIkWJJRK6nAZ8u1zSkkSDqH3rYOvhxZx4xW5BAdS7oMeiDEgMh2GkvZ2emb0Ws5jktpZkYV5+4ubIMSF8uIm3kHjBUqT+BfLmOg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xl9cBf8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xl9cBf8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227EC4CEC5;
	Mon,  9 Sep 2024 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925213;
	bh=hAXgghNS623rALZdA4dujhmp26sEb8PAQqWSZVhoY9w=;
	h=Date:To:From:Subject:From;
	b=xl9cBf8wTEUcRnyI/gXCOTy9sDifjTBIe/DmsZp9xS0Fqw00TwCLDyWwBUnop/TLr
	 7F2bMuQE+ejQ7atwWeSM/G1O1mGlGJdaK0uNT3XtR+z4Z/ng+0Oc/hq6PQwOyTF2Wp
	 5lrBJnanHLsEUvrGrrFUm6m4l39T3MbkHaqayX38=
Date: Mon, 09 Sep 2024 16:40:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-convert-swapon-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240909234013.8227EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: swap: convert swapon() to use a folio
has been removed from the -mm tree.  Its filename was
     swap-convert-swapon-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: convert swapon() to use a folio
Date: Mon, 26 Aug 2024 21:21:35 +0100

Retrieve a folio from the page cache rather than a page.  Saves a couple
of conversions between page & folio.

Link: https://lkml.kernel.org/r/20240826202138.3804238-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/swapfile.c~swap-convert-swapon-to-use-a-folio
+++ a/mm/swapfile.c
@@ -3357,7 +3357,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	unsigned char *swap_map = NULL;
 	unsigned long *zeromap = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
 
@@ -3415,12 +3415,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
-	page = read_mapping_page(mapping, 0, swap_file);
-	if (IS_ERR(page)) {
-		error = PTR_ERR(page);
+	folio = read_mapping_folio(mapping, 0, swap_file);
+	if (IS_ERR(folio)) {
+		error = PTR_ERR(folio);
 		goto bad_swap_unlock_inode;
 	}
-	swap_header = kmap(page);
+	swap_header = kmap_local_folio(folio, 0);
 
 	maxpages = read_swap_header(si, swap_header, inode);
 	if (unlikely(!maxpages)) {
@@ -3574,10 +3574,8 @@ bad_swap:
 	if (swap_file)
 		filp_close(swap_file, NULL);
 out:
-	if (page && !IS_ERR(page)) {
-		kunmap(page);
-		put_page(page);
-	}
+	if (!IS_ERR_OR_NULL(folio))
+		folio_release_kmap(folio, swap_header);
 	if (name)
 		putname(name);
 	if (inode)
_

Patches currently in -mm which might be from willy@infradead.org are



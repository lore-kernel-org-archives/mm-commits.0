Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40F03B79F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958111; cv=none; b=tH4p43EqIzGhi3k4j41RiIgY+4junfOt5g12GS0FzQwNqdd8J8EcPEd5y5PeMpEZ71CHhLvyv5SNxwWOclNUb2Lh1ds80pmZ9EllxW/eSBCxVYkqWk58Y2RHIEqBJF32prpUr5Mt8uLBoYXebOyRcq4zSdUYyop7dP0Nt7O4s0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958111; c=relaxed/simple;
	bh=B3po5PFqS6A/wt2nsvqBF22X3Im1UdGXOXUUT8UFWh0=;
	h=Date:To:From:Subject:Message-Id; b=rgkkxz4izL/u1t3mdO+OaD8CFStzKt9thr5xWKARiYt7arRaHHoGm0N1ZHZydpdAbeU35OfJpPsy3+4wb+0SKASI18AKKKlWopf7iSQpmg78f3XWdatYFJ1Fd+IEtIXpSpD0Z68FZ6IU0eF3R88HJKVjMky8jQ2p2EEzendLGPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1E7bDLGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1E7bDLGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B151DC113CC;
	Mon,  6 May 2024 01:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958110;
	bh=B3po5PFqS6A/wt2nsvqBF22X3Im1UdGXOXUUT8UFWh0=;
	h=Date:To:From:Subject:From;
	b=1E7bDLGchNc/fHmA2MN/7bxoV3uQ/OOW7UGO7ebIK2Ih6gLLKOODwfN5TAKJjUilf
	 Akke7thqVHAe+qt8y8IohPIq6mstnrgYFkIc3aWUOfBkCLlbITHL34F6s0QHVNIp8H
	 srGKAgWhU4oOBtWhFn5GOlY/zbXJGXOiEWfTr0fA=
Date: Sun, 05 May 2024 18:15:10 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-remove-calls-to-set-the-folio-error-flag.patch removed from -mm tree
Message-Id: <20240506011510.B151DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: remove calls to set the folio error flag
has been removed from the -mm tree.  Its filename was
     squashfs-remove-calls-to-set-the-folio-error-flag.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: remove calls to set the folio error flag
Date: Sat, 20 Apr 2024 03:50:18 +0100

Nobody checks the error flag on squashfs folios, so stop setting it.

Link: https://lkml.kernel.org/r/20240420025029.2166544-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |    6 +-----
 fs/squashfs/file_direct.c |    3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/fs/squashfs/file.c~squashfs-remove-calls-to-set-the-folio-error-flag
+++ a/fs/squashfs/file.c
@@ -375,8 +375,6 @@ void squashfs_fill_page(struct page *pag
 	flush_dcache_page(page);
 	if (copied == avail)
 		SetPageUptodate(page);
-	else
-		SetPageError(page);
 }
 
 /* Copy data into page cache  */
@@ -471,7 +469,7 @@ static int squashfs_read_folio(struct fi
 
 		res = read_blocklist(inode, index, &block);
 		if (res < 0)
-			goto error_out;
+			goto out;
 
 		if (res == 0)
 			res = squashfs_readpage_sparse(page, expected);
@@ -483,8 +481,6 @@ static int squashfs_read_folio(struct fi
 	if (!res)
 		return 0;
 
-error_out:
-	SetPageError(page);
 out:
 	pageaddr = kmap_atomic(page);
 	memset(pageaddr, 0, PAGE_SIZE);
--- a/fs/squashfs/file_direct.c~squashfs-remove-calls-to-set-the-folio-error-flag
+++ a/fs/squashfs/file_direct.c
@@ -106,14 +106,13 @@ int squashfs_readpage_block(struct page
 	return 0;
 
 mark_errored:
-	/* Decompression failed, mark pages as errored.  Target_page is
+	/* Decompression failed.  Target_page is
 	 * dealt with by the caller
 	 */
 	for (i = 0; i < pages; i++) {
 		if (page[i] == NULL || page[i] == target_page)
 			continue;
 		flush_dcache_page(page[i]);
-		SetPageError(page[i]);
 		unlock_page(page[i]);
 		put_page(page[i]);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


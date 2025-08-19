Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9E021B9D2
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755644757; cv=none; b=kEHarfcga11z91pqwo8TNjduqJeBHcD93rh5jb3NIWNwv8zuCNisKg1nWoBk0bo7jhFl4Sa3Lre2uoOtvGq/LvjDhVNl9Gfs113rAvv5r7SBJatt6YcCmikvNbylo50iNrFWXKJKh5DNw7kKWJXlUmiiSScGx5396Q7YHeMKFkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755644757; c=relaxed/simple;
	bh=vBowL3B09w6L0sIyfifKbg/amcHNJ0gB0nKRNZIg/W4=;
	h=Date:To:From:Subject:Message-Id; b=gHKuH6rT7Pp+OtvKRB6n71NN8Y1gpt1H5adWPrBVIH9FwJwNlGvCImiaPMjxqmbBU8uXwv6wJf0ixmEJjnZFmzFZJmk+QOm811k8dyGhx/WJzXej2tpdVJwVs9mVfIM94oSrFjZTFht6c3bK52ygR9IkbwsnbsgPi8LgmgLEb0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ynkUiIfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ynkUiIfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819B8C4CEF1;
	Tue, 19 Aug 2025 23:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755644756;
	bh=vBowL3B09w6L0sIyfifKbg/amcHNJ0gB0nKRNZIg/W4=;
	h=Date:To:From:Subject:From;
	b=ynkUiIfsZw9H5qHk7CdgAc3Uthy7J8oilffgSEBo0r9gAXsLzcWMiz+ZnSDCNzUSQ
	 A/oaVqF+2r/rjy6dh7tIeTYBWOnSGjx8pBNZA2RG0nUKQm9PyNlwrku4vmQNQGwLKT
	 a2kCHeOGh6NNuaKsHfo5eRodTsh+p3jlM82Eq1h8=
Date: Tue, 19 Aug 2025 16:05:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kent.overstreet@linux.dev,david@redhat.com,almaz.alexandrovich@paragon-software.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-stop-using-write_cache_pages.patch added to mm-new branch
Message-Id: <20250819230556.819B8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ntfs3: stop using write_cache_pages
has been added to the -mm mm-new branch.  Its filename is
     ntfs3-stop-using-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-stop-using-write_cache_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Christoph Hellwig <hch@lst.de>
Subject: ntfs3: stop using write_cache_pages
Date: Mon, 18 Aug 2025 08:10:08 +0200

Patch series "remove write_cache_pages()".

Kill off write_cache_pages() after converting the last two users to the
iterator.


This patch (of 3):

Stop using the obsolete write_cache_pages and use writeback_iter directly.

Link: https://lkml.kernel.org/r/20250818061017.1526853-1-hch@lst.de
Link: https://lkml.kernel.org/r/20250818061017.1526853-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/inode.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/inode.c~ntfs3-stop-using-write_cache_pages
+++ a/fs/ntfs3/inode.c
@@ -871,9 +871,9 @@ out:
 }
 
 static int ntfs_resident_writepage(struct folio *folio,
-				   struct writeback_control *wbc, void *data)
+				   struct writeback_control *wbc)
 {
-	struct address_space *mapping = data;
+	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
 	struct ntfs_inode *ni = ntfs_i(inode);
 	int ret;
@@ -907,9 +907,14 @@ static int ntfs_writepages(struct addres
 	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
-	if (is_resident(ntfs_i(inode)))
-		return write_cache_pages(mapping, wbc, ntfs_resident_writepage,
-					 mapping);
+	if (is_resident(ntfs_i(inode))) {
+		struct folio *folio = NULL;
+		int error;
+
+		while ((folio = writeback_iter(mapping, wbc, folio, &error)))
+			error = ntfs_resident_writepage(folio, wbc);
+		return error;
+	}
 	return mpage_writepages(mapping, wbc, ntfs_get_block);
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

mempool-rename-struct-mempool_s-to-struct-mempool.patch
ntfs3-stop-using-write_cache_pages.patch
bcachefs-stop-using-write_cache_pages.patch
mm-remove-write_cache_pages.patch


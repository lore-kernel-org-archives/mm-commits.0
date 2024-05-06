Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC0F38F91
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958109; cv=none; b=rl0/7Q5Nhpc5THk8fROdGqfk7K75FB54k/TiRgHB9KZkFVpJnCRnStpN7jW4vv+rQF3LArfg9AhlZZ/lfTpAtRtn1XPAFss4mv87jDOhRZN8ZEvjOVM2Liu01ZM0TuoFQ1rx8+g+RlzoeD4UvkaokjgUL18ojtuU1ISb6CFjd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958109; c=relaxed/simple;
	bh=VKww8agtG7Ql5wVBbFKigRwdMtJl6W+RcqSEI00d/Uk=;
	h=Date:To:From:Subject:Message-Id; b=mRy4Jry35RP7yn+D3bc6IgDtQgnXZQbJa37dQye5XsPPqbuprA+ovwKnY+0hDB3t2NFq8FfA/lDr5CoZ41wRQI7D9J3I1WLs56nPdIIn5YUSdr3lzSpKv0NMjFz7FSF8mbbf/JwIAU2mfGMTsMGhF302tlAJN3OctRhNAn9sSiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iVkVhXrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iVkVhXrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3B0C116B1;
	Mon,  6 May 2024 01:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958109;
	bh=VKww8agtG7Ql5wVBbFKigRwdMtJl6W+RcqSEI00d/Uk=;
	h=Date:To:From:Subject:From;
	b=iVkVhXrhKzSZ1AXmDyddKUIkaDNXRqmb7lXZqKECNurcW9fvSOd/BB40NqEg3bc2j
	 Irr5GEl9e17jtBvwTFhhKuBXBzEPhTefK/6kQIpDPgofXLgfFKR+touUd0BRqzFC6o
	 jwY6plVYAtTlwftWNQAYYDTsM5HsDCNIlXtncTb4=
Date: Sun, 05 May 2024 18:15:09 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch removed from -mm tree
Message-Id: <20240506011509.AC3B0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: convert squashfs_symlink_read_folio to use folio APIs
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: convert squashfs_symlink_read_folio to use folio APIs
Date: Sat, 20 Apr 2024 03:50:17 +0100

Remove use of page APIs, return the errno instead of 0, switch from
kmap_atomic to kmap_local and use folio_end_read() to unify the two exit
paths.

Link: https://lkml.kernel.org/r/20240420025029.2166544-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/symlink.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/fs/squashfs/symlink.c~squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis
+++ a/fs/squashfs/symlink.c
@@ -32,20 +32,19 @@
 
 static int squashfs_symlink_read_folio(struct file *file, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int index = page->index << PAGE_SHIFT;
+	int index = folio_pos(folio);
 	u64 block = squashfs_i(inode)->start;
 	int offset = squashfs_i(inode)->offset;
 	int length = min_t(int, i_size_read(inode) - index, PAGE_SIZE);
-	int bytes, copied;
+	int bytes, copied, error;
 	void *pageaddr;
 	struct squashfs_cache_entry *entry;
 
 	TRACE("Entered squashfs_symlink_readpage, page index %ld, start block "
-			"%llx, offset %x\n", page->index, block, offset);
+			"%llx, offset %x\n", folio->index, block, offset);
 
 	/*
 	 * Skip index bytes into symlink metadata.
@@ -57,14 +56,15 @@ static int squashfs_symlink_read_folio(s
 			ERROR("Unable to read symlink [%llx:%x]\n",
 				squashfs_i(inode)->start,
 				squashfs_i(inode)->offset);
-			goto error_out;
+			error = bytes;
+			goto out;
 		}
 	}
 
 	/*
 	 * Read length bytes from symlink metadata.  Squashfs_read_metadata
 	 * is not used here because it can sleep and we want to use
-	 * kmap_atomic to map the page.  Instead call the underlying
+	 * kmap_local to map the folio.  Instead call the underlying
 	 * squashfs_cache_get routine.  As length bytes may overlap metadata
 	 * blocks, we may need to call squashfs_cache_get multiple times.
 	 */
@@ -75,29 +75,26 @@ static int squashfs_symlink_read_folio(s
 				squashfs_i(inode)->start,
 				squashfs_i(inode)->offset);
 			squashfs_cache_put(entry);
-			goto error_out;
+			error = entry->error;
+			goto out;
 		}
 
-		pageaddr = kmap_atomic(page);
+		pageaddr = kmap_local_folio(folio, 0);
 		copied = squashfs_copy_data(pageaddr + bytes, entry, offset,
 								length - bytes);
 		if (copied == length - bytes)
 			memset(pageaddr + length, 0, PAGE_SIZE - length);
 		else
 			block = entry->next_index;
-		kunmap_atomic(pageaddr);
+		kunmap_local(pageaddr);
 		squashfs_cache_put(entry);
 	}
 
-	flush_dcache_page(page);
-	SetPageUptodate(page);
-	unlock_page(page);
-	return 0;
-
-error_out:
-	SetPageError(page);
-	unlock_page(page);
-	return 0;
+	flush_dcache_folio(folio);
+	error = 0;
+out:
+	folio_end_read(folio, error == 0);
+	return error;
 }
 
 
_

Patches currently in -mm which might be from willy@infradead.org are

nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


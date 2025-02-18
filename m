Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC9A933
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847380; cv=none; b=rEWCB7QAkTt+JkGKFMf2Ob/wQcoz7OBX/A0sUwdCKS99idzAmqPlKg8/q3rnouPD9T5XdlHtTlTJR+TcBwoyx1zvtx1fm7NlDwlV0o51SuxnWSIxbsAaPU5pxNKaSNJme9bLsJpVzFdj0WV1SuHwr3ybCZF4pa2gqPl8pU3B77Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847380; c=relaxed/simple;
	bh=3CsEhnj6ki1LRNVop/Jrxgosykbo78owS8wa2X5pMAg=;
	h=Date:To:From:Subject:Message-Id; b=iWAiZaMiFBw9uHqNI8Vfl/5lU5HspKUwr8oCDaFBh4JfY2FagDGqX/pViXsQE1qgiiregoZu5ojoCoLC13/FYlyyay3yb8UbFLz0c9NmOvHrqPuOanRMj02cUnKbYmEbpJDRsIgtD7iL/7v4g9T9H33eK4Jf7NDIP74qgUbg7Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObzNG/u+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObzNG/u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DFFC4CEE9;
	Tue, 18 Feb 2025 02:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847379;
	bh=3CsEhnj6ki1LRNVop/Jrxgosykbo78owS8wa2X5pMAg=;
	h=Date:To:From:Subject:From;
	b=ObzNG/u+8kSjISHS0waVyMmYk5pDzuFuIaAwcNkdrCM7vKFZxhq5ZrrahVpUzBnkT
	 EzGsqxI9A0YC0AdsF47mS3TncqV+s+atHxmv+imGmQyw0QyklQpLAW+MPsv/LPZvqr
	 G8TfRBeQUgV/6s0f/SM1atRQK7iy1Zh7Q4OiitgE=
Date: Mon, 17 Feb 2025 18:56:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-block_commit_write-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20250218025619.52DFFC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: convert block_commit_write() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     fs-convert-block_commit_write-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-block_commit_write-to-take-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: convert block_commit_write() to take a folio
Date: Mon, 17 Feb 2025 19:20:06 +0000

All callers now have a folio, so pass it in instead of converting
folio->page->folio.

Link: https://lkml.kernel.org/r/20250217192009.437916-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   14 ++++----------
 fs/ext4/inline.c            |    2 +-
 fs/ext4/move_extent.c       |    2 +-
 fs/iomap/buffered-io.c      |    2 +-
 fs/ocfs2/aops.c             |    4 ++--
 fs/ocfs2/file.c             |    2 +-
 fs/udf/file.c               |    2 +-
 include/linux/buffer_head.h |    2 +-
 8 files changed, 12 insertions(+), 18 deletions(-)

--- a/fs/buffer.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/buffer.c
@@ -2166,7 +2166,7 @@ int __block_write_begin(struct folio *fo
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static void __block_commit_write(struct folio *folio, size_t from, size_t to)
+void block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
@@ -2204,6 +2204,7 @@ static void __block_commit_write(struct
 	if (!partial)
 		folio_mark_uptodate(folio);
 }
+EXPORT_SYMBOL(block_commit_write);
 
 /*
  * block_write_begin takes care of the basic task of block allocation and
@@ -2262,7 +2263,7 @@ int block_write_end(struct file *file, s
 	flush_dcache_folio(folio);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(folio, start, start + copied);
+	block_commit_write(folio, start, start + copied);
 
 	return copied;
 }
@@ -2578,13 +2579,6 @@ int cont_write_begin(struct file *file,
 }
 EXPORT_SYMBOL(cont_write_begin);
 
-void block_commit_write(struct page *page, unsigned from, unsigned to)
-{
-	struct folio *folio = page_folio(page);
-	__block_commit_write(folio, from, to);
-}
-EXPORT_SYMBOL(block_commit_write);
-
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
@@ -2630,7 +2624,7 @@ int block_page_mkwrite(struct vm_area_st
 	if (unlikely(ret))
 		goto out_unlock;
 
-	__block_commit_write(folio, 0, end);
+	block_commit_write(folio, 0, end);
 
 	folio_mark_dirty(folio);
 	folio_wait_stable(folio);
--- a/fs/ext4/inline.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ext4/inline.c
@@ -637,7 +637,7 @@ retry:
 		goto retry;
 
 	if (folio)
-		block_commit_write(&folio->page, from, to);
+		block_commit_write(folio, from, to);
 out:
 	if (folio) {
 		folio_unlock(folio);
--- a/fs/ext4/move_extent.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ext4/move_extent.c
@@ -399,7 +399,7 @@ data_copy:
 		bh = bh->b_this_page;
 	}
 
-	block_commit_write(&folio[0]->page, from, from + replaced_size);
+	block_commit_write(folio[0], from, from + replaced_size);
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
--- a/fs/iomap/buffered-io.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/iomap/buffered-io.c
@@ -1484,7 +1484,7 @@ static loff_t iomap_folio_mkwrite_iter(s
 					      &iter->iomap);
 		if (ret)
 			return ret;
-		block_commit_write(&folio->page, 0, length);
+		block_commit_write(folio, 0, length);
 	} else {
 		WARN_ON_ONCE(!folio_test_uptodate(folio));
 		folio_mark_dirty(folio);
--- a/fs/ocfs2/aops.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ocfs2/aops.c
@@ -920,7 +920,7 @@ static void ocfs2_write_failure(struct i
 				ocfs2_jbd2_inode_add_write(wc->w_handle, inode,
 							   user_pos, user_len);
 
-			block_commit_write(&folio->page, from, to);
+			block_commit_write(folio, from, to);
 		}
 	}
 }
@@ -2012,7 +2012,7 @@ int ocfs2_write_end_nolock(struct addres
 				ocfs2_jbd2_inode_add_write(handle, inode,
 							   start_byte, length);
 			}
-			block_commit_write(&folio->page, from, to);
+			block_commit_write(folio, from, to);
 		}
 	}
 
--- a/fs/ocfs2/file.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ocfs2/file.c
@@ -813,7 +813,7 @@ static int ocfs2_write_zero_page(struct
 
 
 		/* must not update i_size! */
-		block_commit_write(&folio->page, block_start + 1, block_start + 1);
+		block_commit_write(folio, block_start + 1, block_start + 1);
 	}
 
 	/*
--- a/fs/udf/file.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/udf/file.c
@@ -69,7 +69,7 @@ static vm_fault_t udf_page_mkwrite(struc
 		goto out_unlock;
 	}
 
-	block_commit_write(&folio->page, 0, end);
+	block_commit_write(folio, 0, end);
 out_dirty:
 	folio_mark_dirty(folio);
 	folio_wait_stable(folio);
--- a/include/linux/buffer_head.h~fs-convert-block_commit_write-to-take-a-folio
+++ a/include/linux/buffer_head.h
@@ -271,7 +271,7 @@ int cont_write_begin(struct file *, stru
 			unsigned, struct folio **, void **,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
-void block_commit_write(struct page *page, unsigned int from, unsigned int to);
+void block_commit_write(struct folio *folio, size_t from, size_t to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch


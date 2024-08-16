Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1F146593
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723844626; cv=none; b=bQO6Ozxz2vPcM7DiO3C9t5wCBzYI26M8asq4VAvlBu2FEc9O0rySKzwwZfPd75McD+2hdl/qBsTScvL0ilpXYO8dWbMbQnEuO+3irElj0qhZHKA6ne3xkkQGPH7OsfenkfPMLBihPM9uS1nPUnLoV48QNz9x3fePXNL6BSIq7vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723844626; c=relaxed/simple;
	bh=nuXRO8O0B/NPioEkwxwdJGSVGNtIVN4DNbMaNEFcBuY=;
	h=Date:To:From:Subject:Message-Id; b=MuN+FPMY2X6q3TTiCAfbosCk4A1bHQ2cipknhZ0GB9Zt6rbb5P7xPuRTOPkjV9HvxpTK4YUp3EPVIjS2bW2xYgcg3m41bcZzNfuE4u9vrEHkaO+FwSKAxHj8VTcqkLfVwI1AVEv1X17MXgIPjhMK/sgtoTh3aZF0+3UlksNb4P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YL3mqt45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YL3mqt45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA2C32782;
	Fri, 16 Aug 2024 21:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723844626;
	bh=nuXRO8O0B/NPioEkwxwdJGSVGNtIVN4DNbMaNEFcBuY=;
	h=Date:To:From:Subject:From;
	b=YL3mqt45LC6aS033B2CP081pugwprariRsH1ya9gINgHOGPAJO6A9tiPSB8oVlmrm
	 /hN8Lwzx6aiyty2SMze4R91D8QZElXb3c2jf1Wmro+BT15MsuUxLLm5yUgSs7szsa4
	 oEkv9320s2IyKqatX6fk9A8sKN3ZJx9eV+N9gOAo=
Date: Fri, 16 Aug 2024 14:43:46 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch added to mm-nonmm-unstable branch
Message-Id: <20240816214346.97CA2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not output warnings when clearing dirty buffers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not output warnings when clearing dirty buffers
Date: Fri, 16 Aug 2024 18:01:28 +0900

After detecting file system corruption and degrading to a read-only mount,
dirty folios and buffers in the page cache are cleared, and a large number
of warnings are output at that time, often filling up the kernel log.

In this case, since the degrading to a read-only mount is output to the
kernel log, these warnings are not very meaningful, and are rather a
nuisance in system management and debugging.

The related nilfs2-specific page/folio routines have a silent argument
that suppresses the warning output, but since it is not currently used
meaningfully, remove both the silent argument and the warning output.

Link: https://lkml.kernel.org/r/20240816090128.4561-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    4 ++--
 fs/nilfs2/mdt.c   |    6 +++---
 fs/nilfs2/page.c  |   19 +++----------------
 fs/nilfs2/page.h  |    4 ++--
 4 files changed, 10 insertions(+), 23 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-do-not-output-warnings-when-clearing-dirty-buffers
+++ a/fs/nilfs2/inode.c
@@ -162,7 +162,7 @@ static int nilfs_writepages(struct addre
 	int err = 0;
 
 	if (sb_rdonly(inode->i_sb)) {
-		nilfs_clear_dirty_pages(mapping, false);
+		nilfs_clear_dirty_pages(mapping);
 		return -EROFS;
 	}
 
@@ -186,7 +186,7 @@ static int nilfs_writepage(struct page *
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_folio_dirty(folio, false);
+		nilfs_clear_folio_dirty(folio);
 		folio_unlock(folio);
 		return -EROFS;
 	}
--- a/fs/nilfs2/mdt.c~nilfs2-do-not-output-warnings-when-clearing-dirty-buffers
+++ a/fs/nilfs2/mdt.c
@@ -411,7 +411,7 @@ nilfs_mdt_write_page(struct page *page,
 		 * have dirty folios that try to be flushed in background.
 		 * So, here we simply discard this dirty folio.
 		 */
-		nilfs_clear_folio_dirty(folio, false);
+		nilfs_clear_folio_dirty(folio);
 		folio_unlock(folio);
 		return -EROFS;
 	}
@@ -638,10 +638,10 @@ void nilfs_mdt_restore_from_shadow_map(s
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping, true);
+	nilfs_clear_dirty_pages(inode->i_mapping);
 	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
 			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
--- a/fs/nilfs2/page.c~nilfs2-do-not-output-warnings-when-clearing-dirty-buffers
+++ a/fs/nilfs2/page.c
@@ -357,9 +357,8 @@ repeat:
 /**
  * nilfs_clear_dirty_pages - discard dirty pages in address space
  * @mapping: address space with dirty pages for discarding
- * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
+void nilfs_clear_dirty_pages(struct address_space *mapping)
 {
 	struct folio_batch fbatch;
 	unsigned int i;
@@ -380,7 +379,7 @@ void nilfs_clear_dirty_pages(struct addr
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(folio->mapping == mapping))
-				nilfs_clear_folio_dirty(folio, silent);
+				nilfs_clear_folio_dirty(folio);
 
 			folio_unlock(folio);
 		}
@@ -392,20 +391,13 @@ void nilfs_clear_dirty_pages(struct addr
 /**
  * nilfs_clear_folio_dirty - discard dirty folio
  * @folio: dirty folio that will be discarded
- * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_folio_dirty(struct folio *folio, bool silent)
+void nilfs_clear_folio_dirty(struct folio *folio)
 {
-	struct inode *inode = folio->mapping->host;
-	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh, *head;
 
 	BUG_ON(!folio_test_locked(folio));
 
-	if (!silent)
-		nilfs_warn(sb, "discard dirty page: offset=%lld, ino=%lu",
-			   folio_pos(folio), inode->i_ino);
-
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
 
@@ -419,11 +411,6 @@ void nilfs_clear_folio_dirty(struct foli
 		bh = head;
 		do {
 			lock_buffer(bh);
-			if (!silent)
-				nilfs_warn(sb,
-					   "discard dirty block: blocknr=%llu, size=%zu",
-					   (u64)bh->b_blocknr, bh->b_size);
-
 			set_mask_bits(&bh->b_state, clear_bits, 0);
 			unlock_buffer(bh);
 		} while (bh = bh->b_this_page, bh != head);
--- a/fs/nilfs2/page.h~nilfs2-do-not-output-warnings-when-clearing-dirty-buffers
+++ a/fs/nilfs2/page.h
@@ -41,8 +41,8 @@ void nilfs_folio_bug(struct folio *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_folio_dirty(struct folio *, bool);
-void nilfs_clear_dirty_pages(struct address_space *, bool);
+void nilfs_clear_folio_dirty(struct folio *folio);
+void nilfs_clear_dirty_pages(struct address_space *mapping);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch


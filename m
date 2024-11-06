Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72E184523
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855663; cv=none; b=KUO0e0rH5E5V8lyShlj4MzRvP03onu7VeHoainS6/LvRLFNqJTaQ5s2CO//342ZKJAp4sJtJvR1oyjtphC7+VdUjYG8Mt4YGGla6s8ttxDl14vNKwM5WLJyNPOh5FVwipclDwuXcAXyo1ASxprXMsy5UIVr2q/SYPY0C8Z3HXFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855663; c=relaxed/simple;
	bh=k91mdZwovxWFlQ6aP1B+R363kvlYSj15mdLOFW/Ql9c=;
	h=Date:To:From:Subject:Message-Id; b=vAFzrAZhf+seE2QgPthHNP8u17lcuHYf0twXzfUuKQ+JoJK9SPE1k2LfEpkucSEcNWKHxDBfe4OSBsqhVpi5m1UYjBrUoClNSOg/hS9YgrPPUNjhsaWEo56TuB6lctDEvgoVmAyqvUyBJpd9c/Jmti6h4Tbu4wOJLRFPe/8UO38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNULmh3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNULmh3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535D0C4CECF;
	Wed,  6 Nov 2024 01:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855663;
	bh=k91mdZwovxWFlQ6aP1B+R363kvlYSj15mdLOFW/Ql9c=;
	h=Date:To:From:Subject:From;
	b=uNULmh3vT65pVA3Gm7/kLaJktntuFSJv8HqmOFHK3gYJV/Zu6QBBtkJAgx065vpK4
	 5ru2vIiOHWfw3BJgBltHL4eddFK2FiKoEFHyI3Q4n7MoI3Gcwzny5cM8st2jAcb/Pa
	 lZUfBaYJRTbt/QDzPP3v3Rdw5amebn0cRq+kwU7g=
Date: Tue, 05 Nov 2024 17:14:22 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-nilfs_writepage.patch removed from -mm tree
Message-Id: <20241106011423.535D0C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove nilfs_writepage
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-nilfs_writepage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: remove nilfs_writepage
Date: Thu, 24 Oct 2024 18:25:43 +0900

Since nilfs2 has a ->writepages operation already, ->writepage is only
called by the migration code.  If we add a ->migrate_folio operation, it
won't even be used for that and so it can be deleted.

[konishi.ryusuke@gmail.com: fixed panic by using buffer_migrate_folio_norefs]
Link: https://lkml.kernel.org/r/20241002150036.1339475-2-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-10-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-remove-nilfs_writepage
+++ a/fs/nilfs2/inode.c
@@ -170,37 +170,6 @@ static int nilfs_writepages(struct addre
 	return err;
 }
 
-static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	struct folio *folio = page_folio(page);
-	struct inode *inode = folio->mapping->host;
-	int err;
-
-	if (sb_rdonly(inode->i_sb)) {
-		/*
-		 * It means that filesystem was remounted in read-only
-		 * mode because of error or metadata corruption. But we
-		 * have dirty pages that try to be flushed in background.
-		 * So, here we simply discard this dirty page.
-		 */
-		nilfs_clear_folio_dirty(folio);
-		folio_unlock(folio);
-		return -EROFS;
-	}
-
-	folio_redirty_for_writepage(wbc, folio);
-	folio_unlock(folio);
-
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		err = nilfs_construct_segment(inode->i_sb);
-		if (unlikely(err))
-			return err;
-	} else if (wbc->for_reclaim)
-		nilfs_flush_segment(inode->i_sb, inode->i_ino);
-
-	return 0;
-}
-
 static bool nilfs_dirty_folio(struct address_space *mapping,
 		struct folio *folio)
 {
@@ -295,7 +264,6 @@ nilfs_direct_IO(struct kiocb *iocb, stru
 }
 
 const struct address_space_operations nilfs_aops = {
-	.writepage		= nilfs_writepage,
 	.read_folio		= nilfs_read_folio,
 	.writepages		= nilfs_writepages,
 	.dirty_folio		= nilfs_dirty_folio,
@@ -304,6 +272,7 @@ const struct address_space_operations ni
 	.write_end		= nilfs_write_end,
 	.invalidate_folio	= block_invalidate_folio,
 	.direct_IO		= nilfs_direct_IO,
+	.migrate_folio		= buffer_migrate_folio_norefs,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch


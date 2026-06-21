Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0601F367293
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067119; cv=none; b=uk5R/KfIn4NGWQr0dDejMGJEKuAugMiSFVFmRsavyRt4YEj/1lNbekpNB0JdXLVLxTtT6HcJqHCrrrlqH5XCpcIX5ZGDAUTzi5ZNW9yYjBBPK50Wzq0V+8tphBuoGlp9hlgheiOQD8fJc3xck4MnGr6AgIdM1m0ZGYlbYXL+ktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067119; c=relaxed/simple;
	bh=VKKl+Un1HN7Jy2E8WGhYhGl9TcJki5md2Ffnckd5k2w=;
	h=Date:To:From:Subject:Message-Id; b=YAyQmH+8Yng16qEUhP0MvjA+SuNZTVAAxOf4tGC/QcRaKv0Kt7B4VPYkwu2g60QGzxKDouPz8ExcXZnDwD7XB/elWmsUTRHRlJI8DAwTp0SiKqvOP+PgBzpunFRtQMGefaRzJl6TdlH9dZwVVuRSFMpj7LH/Vkgqegx8hIZZ52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gT9QJshJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gT9QJshJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47E01F000E9;
	Sun, 21 Jun 2026 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067114;
	bh=/nWNbANMmB9BTSiyfm98jNBhP1LO+708ejemZRetzpM=;
	h=Date:To:From:Subject;
	b=gT9QJshJMxSgQzOxU2xABsBTW0goG/9V7FUC8I6kiXf8quHIwJAH4DEfxffh37p8x
	 ZHPD095dzY03JCKZEpJOuFaqpF/qz3EBazXd5mDqz+3MzgZKJJBADdGtgYJ766fG8J
	 4gSo2ZjLArjU69DkGGfkg+ZBVkTk151/igkET52o=
Date: Sun, 21 Jun 2026 11:38:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch removed from -mm tree
Message-Id: <20260621183834.D47E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Sun, 17 May 2026 09:54:15 -0400

collapse_file() is capable of collapsing pagecache folios from writable
files to PMD folios.  Now enable clean pagecache folio collapse in
addition to read-only pagecache folio collapse by removing the
inode_is_open_for_write() from file_thp_enabled() and only performing
filemap_flush() if the file is read-only.

This means userspace needs to explicitly flush the content of pagecache
folios before khugepaged can collapse the folios, or use
madvise(MADV_COLLAPSE), which does the flush in the retry.  The reason is
that blindly enabling dirty pagecache folio from writable files collapse
makes khugepaged flush these folios all the time.  It is undesirable to
cause system level pagecache flushes.

To properly support dirty pagecache folio collapse, filemap_flush() needs
to be avoided.  Potentially, merging associated buffer instead of dropping
it with filemap_release_folio() might be needed.

NOTE: this breaks khugepaged selftests for writable file pagecache
collapse, which is set to fail all the time.  The next commit fixes it.

Link: https://lore.kernel.org/20260517135416.1434539-14-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/khugepaged.c  |   15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files
+++ a/mm/huge_memory.c
@@ -100,7 +100,7 @@ static inline bool file_thp_enabled(stru
 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
--- a/mm/khugepaged.c~mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files
+++ a/mm/khugepaged.c
@@ -2345,18 +2345,21 @@ static enum scan_result collapse_file(st
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
-				 * been flushed since first write. There
-				 * won't be new dirty pages.
+				 * been flushed since first write.
 				 *
-				 * Trigger async flush here and hope the
-				 * writeback is done when khugepaged
-				 * revisits this page.
+				 * Trigger async flush for read-only files and
+				 * hope the writeback is done when khugepaged
+				 * revisits this page. Writable files can have
+				 * their folios dirty at any time; blindly
+				 * flushing them would cause undesirable
+				 * system-wide writeback.
 				 *
 				 * This is a one-off situation. We are not
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
+				if (!inode_is_open_for_write(mapping->host))
+					filemap_flush(mapping);
 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC8C25B0A6
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067098; cv=none; b=VK2qOuL0hIqVQ/6dxmC6HN4EDihVIakVMb4ue9c7590xce+Av8sgHh7/AAI2QQTuu6m+7RRSwrZNWoDE3vGHZJZPDWsPvdzg+X7t65nVLA2RjPauGf7L1eOlNU5WE5HPErCZyoC+feRHrjIndsQnNsCEFFSy1FjhzmWsEgKKRJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067098; c=relaxed/simple;
	bh=YrCzobvVp63RGAy2ReWu/h3+rhrBTuiLeiB4+bk6bao=;
	h=Date:To:From:Subject:Message-Id; b=mUJiQxSpXY6Uunk81XlcNBXshsaL+f95VUc6L8rY7qOXEO8/tUNpKqhInFGZmssLp6vwWvg0S3/CPmVril9cbKPqumADOkEUQhbIMDRP6czkeyn59XCtWi2nQtp/3f4qs9wIgEBAvY3JKjCepHh7iPiidnHXBOOCVj1iWBFkZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RrYUW0Vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RrYUW0Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D790F1F000E9;
	Sun, 21 Jun 2026 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067096;
	bh=U53nQI5eD4xe+hkPeHkjqNblkVBEvwe4PESSGF2jDAk=;
	h=Date:To:From:Subject;
	b=RrYUW0VzwsUZMy2TSI8j8fuxBmFSi5tBP/fAhzG0pi31YJIDNXw59/lVDZESSsYW4
	 TFeMZMX2MR8/dx2d6oOJnejBcdp/Xxoe9/Xofz7LNKgpw/IQqUYcIL7Hv0WXHJIjHC
	 BQ0W05DHRFeMVfgWAY5DFFUD8wyKfm3MKUcauWyc=
Date: Sun, 21 Jun 2026 11:38:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch removed from -mm tree
Message-Id: <20260621183816.D790F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: add folio dirty check after try_to_unmap()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Sun, 17 May 2026 09:54:04 -0400

This check ensures the correctness of read-only PMD folio collapse after
it is enabled for all FSes supporting PMD pagecache folios and replaces
READ_ONLY_THP_FOR_FS.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios.  In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too.  To ensure khugepaged functions
as expected after the changes, skip if any folio is dirty after
try_to_unmap(), since a dirty folio at that point means this read-only
folio can get writes between try_to_unmap() and try_to_unmap_flush() via
cached TLB entries and khugepaged does not support writable pagecache
folio collapse yet.

Link: https://lore.kernel.org/20260517135416.1434539-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-folio-dirty-check-after-try_to_unmap
+++ a/mm/khugepaged.c
@@ -2338,8 +2338,7 @@ static enum scan_result collapse_file(st
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2397,8 +2396,8 @@ static enum scan_result collapse_file(st
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
-			 * khugepaged only works on read-only fd, so this
-			 * folio is dirty because it hasn't been flushed
+			 * khugepaged only works on clean file-backed folios,
+			 * so this folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
@@ -2440,6 +2439,27 @@ static enum scan_result collapse_file(st
 			xas_unlock_irq(&xas);
 			folio_putback_lru(folio);
 			goto out_unlock;
+		}
+
+		/*
+		 * At this point, the folio is locked and unmapped. If the PTE
+		 * was dirty, try_to_unmap() has transferred the dirty bit to
+		 * the folio and we must not collapse it into a clean
+		 * file-backed folio.
+		 *
+		 * If the folio is clean here, no one can write it until we
+		 * drop the folio lock. A write through a stale TLB entry came
+		 * from a clean PTE and must fault because the PTE has been
+		 * cleared; the fault path has to take the folio lock before
+		 * installing a writable mapping. Buffered write paths also
+		 * have to take the folio lock before modifying file contents
+		 * without a mapping, typically via write_begin_get_folio().
+		 */
+		if (!is_shmem && folio_test_dirty(folio)) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			xas_unlock_irq(&xas);
+			folio_putback_lru(folio);
+			goto out_unlock;
 		}
 
 		/*
_

Patches currently in -mm which might be from ziy@nvidia.com are



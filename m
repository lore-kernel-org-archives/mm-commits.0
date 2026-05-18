Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B964E390990
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141562; cv=none; b=i4PvvaT2D1bjC6Ms/CBAdGJzXxf6RBApuVuOZfJlMchQ/qIGu64pD6qF3FW04VbBqGd9kkpvXUrXO07iZ0Sqf3b7wVsRe+1GkY8H8xYCmy3gsqnstfG++gjfYh4kib/1I2TQdzDqspeidweomLsifFA+KJ6HAR95Xx8WXZJbn7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141562; c=relaxed/simple;
	bh=uyHwBi+cYtf19pqVTJYZ+TavBSehAeM1uvIh07IHwnE=;
	h=Date:To:From:Subject:Message-Id; b=llyztCWEtwGcr9NQcQ+TiniNEEOMho2dEfRBZBzd5hERET8lKOpAsZYDxkFZIj0OKNLYZFKZG+qjs83P/++7oQZ2Ic3pQ45VcjitH4GufXjGkAk7Rj39/+H8ZwjD04ZgGapJ/Pl6J8Xfwd4j5dMPBz5nhwGCpjJUZZXPFhIkH5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bzxp6KcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bzxp6KcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498DCC2BCB7;
	Mon, 18 May 2026 21:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141562;
	bh=uyHwBi+cYtf19pqVTJYZ+TavBSehAeM1uvIh07IHwnE=;
	h=Date:To:From:Subject:From;
	b=bzxp6KcFgN9jzJ93WI8edA4n853qG4WlISkRp4mgSomU4og2qLYIxEhHi5GK7S06F
	 jKyV1M+bfg/J5UpYBkBDHYvDeIKUP/sEJfVp5Ul8F0jG7J5Kh4x1eQmT+IuYgbhfc7
	 Dpo9LhHAbsjgb3i89V5szhy1TGt4DQFRS77zuMDA=
Date: Mon, 18 May 2026 14:59:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch removed from -mm tree
Message-Id: <20260518215922.498DCC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: add folio dirty check after try_to_unmap()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Wed, 29 Apr 2026 11:29:12 -0400

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

Link: https://lore.kernel.org/20260429152924.727124-3-ziy@nvidia.com
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
@@ -2335,8 +2335,7 @@ static enum scan_result collapse_file(st
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2394,8 +2393,8 @@ static enum scan_result collapse_file(st
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
@@ -2437,6 +2436,27 @@ static enum scan_result collapse_file(st
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

mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch


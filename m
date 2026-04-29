Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F0C3FFAB6
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479198; cv=none; b=tXV0QcdloGrGVDz/d5513sO5SWAtS8NczkDl2ULl9FTxf7mLHf2+I468TkINwjYp2snp1HcpSVr8+ENSJf9I6Yz+ssnestfQnToTuh+bFBSM00HYNUoM+WtCg0HuPT/tgLp3yfuCJ0h2RDvt8P5ZxheWhU0+brAIbDZ6ICNkhNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479198; c=relaxed/simple;
	bh=+Yvu+zkxdrHSt/vx6cr7w/gVhwwlg/038+Imh7xycy8=;
	h=Date:To:From:Subject:Message-Id; b=Kgtjm5XsrdoG7MyBmpI4eh1W3mKQ0b2/CHhj9mLuUb4+/mbi2jvWqDeHgheHdVhjuqrbQzjhNR8146cNUdqY0AyUmyGXm8QtL6WBaguTrd24SQNVavgyIibr2mosZFE7N6xgttfFjT//0JKc+j84hb1Jk3bISLdDY8TWSZujjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lYYnEfMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lYYnEfMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279BCC19425;
	Wed, 29 Apr 2026 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777479198;
	bh=+Yvu+zkxdrHSt/vx6cr7w/gVhwwlg/038+Imh7xycy8=;
	h=Date:To:From:Subject:From;
	b=lYYnEfMcnZqFSS0ZVtxwz0JyfradtDFH+SjDBXzQVGjQWPV8LkHqdN0pfc4fg/U6R
	 hUmqctKnapT859NftLOXDmNQTkCCTdQq0DgWMMJa/Uf0/W9gCnGk46u3zgGW6D1Lfh
	 sDyQ1o3ECirCEbfDpA3zEDddYocbtAghdwixX3Us=
Date: Wed, 29 Apr 2026 09:13:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch added to mm-new branch
Message-Id: <20260429161318.279BCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: add folio dirty check after try_to_unmap()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
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

 mm/khugepaged.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-folio-dirty-check-after-try_to_unmap
+++ a/mm/khugepaged.c
@@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(st
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(st
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
@@ -2429,6 +2428,27 @@ static enum scan_result collapse_file(st
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

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch


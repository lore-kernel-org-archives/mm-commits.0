Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17D39D6C8
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141584; cv=none; b=RODnfvhz5wFFRBUd53+a6mVv2A1+B8UVDKbkx1e8Zbrnlmd5nOOhznOM/Ge/C+ooEMfZxm1sGHm+PEEpDiWgTj69z68GsII+bjxGi5rcF2QAoMz7NkY0Jq6HROKDGeofPyi06XMbSpY3AgBwTePyrffSRs76VfgqlU8SXwV2Btw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141584; c=relaxed/simple;
	bh=P1Ud09Up6w8XapmjQ0U71EFke7d9GbDL31G6rosxuB4=;
	h=Date:To:From:Subject:Message-Id; b=dHeYVrgeLy0RHUGAf7Uz3PtKULVbMEED69IfzSgi0B17D3S9as/iUN/0n9SSH8eJog39o6Jla4afE08N5Hau9V1dZVc2KsWG+WDlqPE7aE4Dl+SQjGyocMdvsuCw8XZhkA3yCBu2u4ueNGDU0HCVfhmlS+cTJtQyZDvvYEKhbH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jo4QIKuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jo4QIKuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74874C2BCB7;
	Mon, 18 May 2026 21:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141584;
	bh=P1Ud09Up6w8XapmjQ0U71EFke7d9GbDL31G6rosxuB4=;
	h=Date:To:From:Subject:From;
	b=Jo4QIKuDyZNbFfyKlv6/wBjHi68uMVsTBcwVtWPKFyotkhC9Of0blfqBUzSXpONfK
	 cZKhJQ3HbjnIovg5coychdEXt0iw/41ZCqYPFVwFxKfpWOe7f7lsTkv8JCPRiIHROC
	 0Ww+mmqyUEBQpmEFUXC1HysbDNSxv4m/sLjzWtRM=
Date: Mon, 18 May 2026 14:59:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch removed from -mm tree
Message-Id: <20260518215944.74874C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Wed, 29 Apr 2026 11:35:36 -0400

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

Link: https://lore.kernel.org/20260429153538.727855-9-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/huge_memory.c |    2 +-
 mm/khugepaged.c  |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files
+++ a/mm/huge_memory.c
@@ -97,7 +97,7 @@ static inline bool file_thp_enabled(stru
 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
--- a/mm/khugepaged.c~mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files
+++ a/mm/khugepaged.c
@@ -2353,7 +2353,14 @@ static enum scan_result collapse_file(st
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
+				/*
+				 * Only flush for read-only files. Writable
+				 * files can have their folios dirty at any
+				 * time; blindly flushing them would cause
+				 * undesirable system-wide writeback.
+				 */
+				if (!inode_is_open_for_write(mapping->host))
+					filemap_flush(mapping);
 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch


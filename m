Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F11302CD5
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141564; cv=none; b=UIL9cYpKxGRPKXG9owPLXoFE3CGOu5CxzfOlxeiEU/jqy59kvjvJ6t676xWFwPmiCuygR4vqDpQzmrBW+IVg3iI5Ioc1q+JFqgPKb8OrJto+upEGC0BwP40lesLPTprITvfI9HTNeB8dgitobu9H3KNgyXHpy3k2qdaY/N905n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141564; c=relaxed/simple;
	bh=ok/CGP9YWih7bTnb9nINu60eOuacsqbcE/LvAjHnMhI=;
	h=Date:To:From:Subject:Message-Id; b=nr1iVxTc6C9KOBvNlA6A5kjKc9hC4gnhqWAiM8BhVgbbOyzmFxT/tWgt194vWDE+CAZ6ozmb3l9HwGmA7b94CnMoagFzo+kSt97GMAjyQcDNulDcC3ScMYNGQp0K53dx0bUBv/D8o+FYnpJX4j+VtiHJrDphJCm3HIq8dCtRW+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CmXhd0mO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CmXhd0mO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFCEC2BCB7;
	Mon, 18 May 2026 21:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141564;
	bh=ok/CGP9YWih7bTnb9nINu60eOuacsqbcE/LvAjHnMhI=;
	h=Date:To:From:Subject:From;
	b=CmXhd0mOUORO/2J34ToSyAh2Uojb35BzhRxLxH391mLKwqHMbUnm9ut3iVn4qNaad
	 MWrLA2AjoaXWCP5tmPYt+BMTVixPcW11O2MU2V7TShrmjv8SF+M5shBNGbJ7BneG/s
	 W8qoLctiHnkSdg7Rx2YroDlo17Ol/SXp8WY0b7p8=
Date: Mon, 18 May 2026 14:59:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch removed from -mm tree
Message-Id: <20260518215924.1AFCEC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Wed, 29 Apr 2026 11:29:13 -0400

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported.  Keep the inode
open-for-write check, since even if collapse_file() now makes sure all
to-be-collapsed folios are clean and the created PMD file THP can be
handled by FSes properly, the filemap_flush() could perform undesirable
write back.

Link: https://lore.kernel.org/20260429152924.727124-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled
+++ a/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(stru
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(stru
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

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


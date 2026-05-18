Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A022571DD
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142905; cv=none; b=MpAwhwHyAHp3r8qZuaen+eBf7Bc0MmhKwN5cmNYtSaos/C0GPo05zQZ94zkrVb7MvDWr+sGYeBkMHQvBM2u1Ie9s9FScQ9BkuhA1CHvS4P7bbE69b4ZzEluzx1xZ/kzkQKlxdRYkjNlEyKnYpoBmw0p0kL+L8oXv27+2yKbozJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142905; c=relaxed/simple;
	bh=JOEFeNS/AsfjcUhmkKfZne0ijOUGvgZhFRF4sSD3lTI=;
	h=Date:To:From:Subject:Message-Id; b=OxTlBmVtSzW8iv2u4WEuEZfaadTumSnXTkip52Sax2gxhO6/2K2iYYqWmGIUZyVf4zwjIAizV/GMbq3DdTsyPkjCysNtZEYmdqw8pNIcdiL23cn/bhrdQkrdpz/QizdOwdUI8VNFRCfXBdaWAo+Jlj2/aWdD9ccjsYmzp2cOKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPV+FOay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPV+FOay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82489C2BCB7;
	Mon, 18 May 2026 22:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142904;
	bh=JOEFeNS/AsfjcUhmkKfZne0ijOUGvgZhFRF4sSD3lTI=;
	h=Date:To:From:Subject:From;
	b=pPV+FOaydtjP1MG1Cr0/3fuKHVYx4bS6a98FQ50lDWOMJbmNWan/oFHuCUKivblBD
	 NKN9ABSsgCYp5J5TfZ7LxJz28wWAYXzlLDgl21Z8VABxAdiYyC021upRPBqCDbfJmj
	 hV2ZhUyf9Th8SiXg3mtJBuAW2f9PYCXsmEZaOW/M=
Date: Mon, 18 May 2026 15:21:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-read_only_thp_for_fs-check.patch added to mm-unstable branch
Message-Id: <20260518222144.82489C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-remove-read_only_thp_for_fs-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-read_only_thp_for_fs-check.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Sun, 17 May 2026 09:54:03 -0400

Patch series "Remove CONFIG_READ_ONLY_THP_FOR_FS and enable file THP for
writable files", v6.


This patch (of 14):

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. 
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_folio_support() for FSes supporting
large folio with at least PMD_ORDER.

Link: https://lore.kernel.org/20260517135416.1434539-1-ziy@nvidia.com
Link: https://lore.kernel.org/20260517135416.1434539-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 include/linux/pagemap.h |   27 +++++++++++++++++++++++++++
 mm/khugepaged.c         |   10 ++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/include/linux/pagemap.h
@@ -513,6 +513,33 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+/**
+ * mapping_pmd_folio_support() - Check if a mapping supports PMD-sized folio
+ * @mapping: The address_space
+ *
+ * While some mappings support large folios, they might not support PMD-sized
+ * folios. This function checks whether a mapping supports PMD-sized folios.
+ * For example, khugepaged needs this information before attempting to
+ * collapsing THPs.
+ *
+ * Return: True if PMD-sized folios are supported, otherwise false.
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_min_folio_order(mapping) <= PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+#else
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	return false;
+}
+#endif
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
--- a/mm/khugepaged.c~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/mm/khugepaged.c
@@ -2243,8 +2243,14 @@ static enum scan_result collapse_file(st
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/*
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
+	 *
+	 * TODO: once shmem always calls mapping_set_large_folios() on its
+	 * mapping, the shmem check can be removed.
+	 */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CA9369225
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777026662; cv=none; b=CRHiSADU8dEERlpsjUbLMndRsDAtUe5x7MYEIvOQRb4u/sj/CgDNCNH13ctMxiwUie3OF+oUdGnujkNPA6TpaHMkfBM75WyNZrb4ZK5jkgvFHFX1Zi8BVetQBAhhcBlBXQ1jfj280gRNVTkLWfZV7F6fHRCXXReWHLQAq6ZYe2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777026662; c=relaxed/simple;
	bh=cz3/JD2xJV6loKxaZuQu4ySMBKkXF0AAYorwVqW9aiw=;
	h=Date:To:From:Subject:Message-Id; b=ml5xTqeOaOZQeYKHBnOt0F14AwHC0Hb2yluEQk2Hk3o/2zMsYRaYBkach5djsVErTaRtk8mGgb5VJDKyIrQ0Mhu/z0QYsTwEChg8hIpT8vbN1st501WXk6k/7EBtGCbKBPBAaShQcCvx/qHeseR3mfbOaDElaxZXCvdNIdt12Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dCXB6u2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dCXB6u2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC134C19425;
	Fri, 24 Apr 2026 10:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777026661;
	bh=cz3/JD2xJV6loKxaZuQu4ySMBKkXF0AAYorwVqW9aiw=;
	h=Date:To:From:Subject:From;
	b=dCXB6u2tYqWtezYh+5vDoEy6lKtECmT9eSdHB5RGhKBozkQhm4wMK6y1q1iiwJS+u
	 fjuIH0oITqof8gMZKjNNGfTap5jvwd2fpbbqdVZ1U6uT3KtqxzdJuoXr3r8eP6SJOJ
	 HYJwuz5UoR93NUDZh7h0MdZVuaDrMSv9qy54c1o0=
Date: Fri, 24 Apr 2026 03:31:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch added to mm-new branch
Message-Id: <20260424103101.DC134C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch

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
Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Thu, 23 Apr 2026 22:49:07 -0400

Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
hugepages are enabled by the global transparent hugepage control. 
khugepaged can still be enabled by per-size control for anon and shmem
when the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_enabled().

Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().

Link: https://lore.kernel.org/20260424024915.28758-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 mm/khugepaged.c          |   26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/shmem_fs.h~mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled
+++ a/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
--- a/mm/khugepaged.c~mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled
+++ a/mm/khugepaged.c
@@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+static inline bool anon_hpage_enabled(void)
+{
+	if (READ_ONCE(huge_anon_orders_always))
+		return true;
+	if (READ_ONCE(huge_anon_orders_madvise))
+		return true;
+	if (READ_ONCE(huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
+	 * hugepages are determined by the global control.
 	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
-	if (READ_ONCE(huge_anon_orders_always))
+	if (hugepage_global_enabled())
 		return true;
-	if (READ_ONCE(huge_anon_orders_madvise))
-		return true;
-	if (READ_ONCE(huge_anon_orders_inherit) &&
-	    hugepage_global_enabled())
+	if (anon_hpage_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
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


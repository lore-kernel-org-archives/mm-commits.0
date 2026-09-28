Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435A14F70
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 03:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790564835; cv=none; b=Tnfj4Y/YLCd0yT3Z1M9FF5GGIQLKIoI96sX+4GOYsJacqdVRwY5FLbPAlVr+jPARXIb8zNCN0+/VZhRc25gyayNCKBcbj4/KKiKwLG2s2hu8CIqYzT4UCxepdF9K/WznzO16a5XoJGKphV85/sUsqPf0KK3HqjJ/0bxyt8TFXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790564835; c=relaxed/simple;
	bh=EznRmZsog1woEZgBHE8V991mbVaF0Y3PRR3BwsgcTYg=;
	h=Date:To:From:Subject:Message-Id; b=Vf+YddoMaKFRqEHBRwNt++33KxzA3iXwFzPm8IC3gK4er6gJAJ5Cg7kMXScSu64aQ8eZMNZ0H+CroCaWWEFZKa7y+IyIUg7oJFck2Z1C2h1KtQaGpwfCtOLzajIp5J0TldUSXcDPT8pMwZMQ/fNkueWdhARlb6G1DCThtzyaMxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dRNURTpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRNURTpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563701F000FF;
	Mon, 28 Sep 2026 03:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790564833;
	bh=g0czPOY5UXIsnPVnKvhL2HY1FqLDPW/1zel44IE4C3Q=;
	h=Date:To:From:Subject;
	b=dRNURTpg6ZOp9kjvm7raqzRkY7PwgrdT/SvbVdZJbLMoSYQAWFsp7mkIMV9QxBiwt
	 xlXpAji//QvZDdayaxn2t4CfbYkXA23XUG82/8cNnF/TNeCrbAgoCsTCutHiiYFjVq
	 pm2l7qOrTvYfOjYTgyiseSSYmcB4wntfFHqorz2k=
Date: Sun, 27 Sep 2026 20:07:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,aiqi.i7@bytedance.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch removed from -mm tree
Message-Id: <20260928030713.563701F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
Date: Tue, 22 Sep 2026 17:07:49 +0800

Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
PMD sharing is possible.  That is only needed when huge_pmd_unshare()
actually detaches a shared PMD page table, because clearing the PUD
invalidates the whole PUD-sized virtual address range.

For hugetlbfs hole punch, and similarly for other hugetlb unmap paths, a
shared mapping can pass the "PMD sharing is possible" range test in
adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file has
never actually had any shared PMD page tables.  KVM then receives a 1G
invalidation for a 2M operation and zaps unrelated secondary mappings, so
the guest has to fault them back in.

Avoid this by remembering, per hugetlbfs inode, whether PMD sharing was
ever established for the file.  Set the flag when huge_pmd_share()
successfully populates a shared PMD table.  For the hugetlb unmap paths,
skip the conservative PUD-sized notifier expansion while the file has
never seen PMD sharing.

The state is intentionally sticky and file-wide.  Once PMD sharing has
ever happened for the file, the unmap paths keep the existing conservative
expansion.  This avoids the no-sharing case without adding a page-table
walk to every unmap.

On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
improves P99 QPS stability while punching pages, reducing the QPS
degradation ratio from 7.09% to 1.45%.

Link: https://lore.kernel.org/20260922090749.24905-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 fs/hugetlbfs/inode.c    |    3 +++
 include/linux/hugetlb.h |   24 ++++++++++++++++++++++++
 mm/hugetlb.c            |   11 ++++++++---
 3 files changed, 35 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds
+++ a/fs/hugetlbfs/inode.c
@@ -920,6 +920,9 @@ static struct inode *hugetlbfs_get_inode
 		simple_inode_init_ts(inode);
 		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+		info->pmd_sharing_seen = false;
+#endif
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
--- a/include/linux/hugetlb.h~mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds
+++ a/include/linux/hugetlb.h
@@ -507,6 +507,9 @@ struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	struct resv_map *resv_map;
 	unsigned int seals;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+	bool pmd_sharing_seen;
+#endif
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -514,6 +517,27 @@ static inline struct hugetlbfs_inode_inf
 	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
 }
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void hugetlbfs_set_pmd_sharing_seen(struct inode *inode)
+{
+	HUGETLBFS_I(inode)->pmd_sharing_seen = true;
+}
+
+static inline bool hugetlbfs_pmd_sharing_seen(struct inode *inode)
+{
+	return HUGETLBFS_I(inode)->pmd_sharing_seen;
+}
+#else
+static inline void hugetlbfs_set_pmd_sharing_seen(struct inode *inode)
+{
+}
+
+static inline bool hugetlbfs_pmd_sharing_seen(struct inode *inode)
+{
+	return false;
+}
+#endif
+
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vma_flags_t acct,
 				int creat_flags, int page_size_log);
--- a/mm/hugetlb.c~mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds
+++ a/mm/hugetlb.c
@@ -5438,10 +5438,12 @@ void __hugetlb_zap_begin(struct vm_area_
 	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
 		return;
 
-	adjust_range_if_pmd_sharing_possible(vma, start, end);
 	hugetlb_vma_lock_write(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+		if (hugetlbfs_pmd_sharing_seen(file_inode(vma->vm_file)))
+			adjust_range_if_pmd_sharing_possible(vma, start, end);
+	}
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5480,7 +5482,9 @@ void unmap_hugepage_range(struct vm_area
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				start, end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	if (hugetlbfs_pmd_sharing_seen(file_inode(vma->vm_file)))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
@@ -7083,6 +7087,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		hugetlbfs_set_pmd_sharing_seen(mapping->host);
 		mm_inc_nr_pmds(mm);
 	} else {
 		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch


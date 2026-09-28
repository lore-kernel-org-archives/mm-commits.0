Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76618AE3
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 03:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790564895; cv=none; b=PKnO51pBwUJaDquk3TylPznF8sGDb+azALRbECpOMEdK7GVoTvpoGEAuHknDO4chonOEouUNZsXuMlxV7kYCA9boqsAjeXhNjz0LFezt6aJtPeubHu7vDdljunGpsvSuVm6C/kZ4+FoDRb5P0SL7CDzuci38Z6xj1/xCHF09veo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790564895; c=relaxed/simple;
	bh=pQ/U/guPwLgA6WZv0JVDOv9dDfkAo8WHzsqh7MzaPew=;
	h=Date:To:From:Subject:Message-Id; b=bwZmihT7EIlqsIyH7o/l9HYin+oU7qhJruvXcvX8y4IM6SmJrVM/tj/lJH5/o9aWYfSZEDEFQ4PBxFfGnunm+37PpFnf1Vr9jjJEDVKGx9pIXXNa39vo/Vh/JuvURlAaVDjdkYKZAY+jXTkUBsXhHZUFGWNiFJpJckHFaWZkM9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IS3fEQgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IS3fEQgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342361F000FF;
	Mon, 28 Sep 2026 03:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790564893;
	bh=D2zGZz7i/cY2p27IV5qFeDbSmDRNnQ/yyNG1iepNtmM=;
	h=Date:To:From:Subject;
	b=IS3fEQgH3fbAYkcqNTd0TTyiq1pDXi9rOMGzTQHPilCiFaJokOYpeT8G9m9IDlER4
	 74mU9S3O/HdOdDVujInw5PQEQ3U+9TscjqpWD7z0IPGaaFLBpBa96qeyfQmvs/V+5t
	 BqfOGoweANKB70WlSfvL+VplQd+IaULrYZ8RTCQg=
Date: Sun, 27 Sep 2026 20:08:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,aiqi.i7@bytedance.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch added to mm-unstable branch
Message-Id: <20260928030813.342361F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

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
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
Date: Mon, 28 Sep 2026 10:47:23 +0800

Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
PMD sharing is possible.  That is only needed when huge_pmd_unshare()
actually detaches a shared PMD page table, because clearing the PUD
invalidates the whole PUD-sized virtual address range.

For hugetlbfs hole punch, and similarly for other hugetlb unmap paths, a
shared mapping can pass the "PMD sharing is possible" range test in
adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file does
not currently have any shared PMD page tables.  KVM then receives a 1G
invalidation for a 2M operation and zaps unrelated secondary mappings, so
the guest has to fault them back in.

Avoid this by tracking active PMD-sharing attachments per hugetlbfs inode.
The count is incremented only after huge_pmd_share() successfully
installs a shared PMD table, and decremented when __huge_pmd_unshare()
actually detaches one.  Since huge_pmd_share() can run concurrently under
i_mmap_lock_read(), use a 64-bit atomic counter.  A zero count is used to
skip the conservative notifier range expansion only after excluding
concurrent PMD sharing with the mapping write lock.

On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
improves P99 QPS stability while punching pages, reducing the QPS
degradation ratio from 7.09% to 1.45%.

Link: https://lore.kernel.org/20260928024723.87708-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 fs/hugetlbfs/inode.c    |    1 +
 include/linux/hugetlb.h |   37 +++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c            |   13 ++++++++++---
 3 files changed, 48 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds
+++ a/fs/hugetlbfs/inode.c
@@ -920,6 +920,7 @@ static struct inode *hugetlbfs_get_inode
 		simple_inode_init_ts(inode);
 		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
+		hugetlbfs_pmd_sharing_init(inode);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
--- a/include/linux/hugetlb.h~mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds
+++ a/include/linux/hugetlb.h
@@ -11,6 +11,7 @@
 #include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/atomic.h>
 #include <linux/pgtable.h>
 #include <linux/gfp.h>
 #include <linux/userfaultfd_k.h>
@@ -507,6 +508,9 @@ struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	struct resv_map *resv_map;
 	unsigned int seals;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+	atomic64_t pmd_sharing_count;
+#endif
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -514,6 +518,39 @@ static inline struct hugetlbfs_inode_inf
 	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
 }
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void hugetlbfs_pmd_sharing_init(struct inode *inode)
+{
+	atomic64_set(&HUGETLBFS_I(inode)->pmd_sharing_count, 0);
+}
+
+static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode)
+{
+	atomic64_inc(&HUGETLBFS_I(inode)->pmd_sharing_count);
+}
+
+static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode)
+{
+	atomic64_dec(&HUGETLBFS_I(inode)->pmd_sharing_count);
+}
+
+static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
+{
+	return atomic64_read(&HUGETLBFS_I(inode)->pmd_sharing_count) != 0;
+}
+#else
+static inline void hugetlbfs_pmd_sharing_init(struct inode *inode) {}
+
+static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode) {}
+
+static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode) {}
+
+static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
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
+		if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
+			adjust_range_if_pmd_sharing_possible(vma, start, end);
+	}
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5480,7 +5482,10 @@ void unmap_hugepage_range(struct vm_area
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				start, end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
@@ -7083,6 +7088,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		hugetlbfs_pmd_sharing_inc(file_inode(vma->vm_file));
 		mm_inc_nr_pmds(mm);
 	} else {
 		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
@@ -7114,6 +7120,7 @@ static int __huge_pmd_unshare(struct mmu
 	pud_clear(pud);
 
 	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
+	hugetlbfs_pmd_sharing_dec(file_inode(vma->vm_file));
 
 	mm_dec_nr_pmds(mm);
 	return 1;
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
mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch


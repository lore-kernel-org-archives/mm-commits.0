Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15852EC09D
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939844; cv=none; b=XPR19rpyxqbZ96oIEg/BYchqxw8pGvTRTNVxmkMgQ0PpIJhAhHhv1co89ltGY1DUYCLCjFe7jYhVwQQVuiBjdy22QEOwK+YspYAaRUgNqXsJ8nJ6ifX3jrYLeuoWzmQORUlA4TuIw2eUPHAht3Ac0ov66XP6CCWYbBOfnHYeU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939844; c=relaxed/simple;
	bh=sx5l69j4CNl3osncIHn7/LXMAqTKfulJKo7dAWYDHTo=;
	h=Date:To:From:Subject:Message-Id; b=AjCRRo+HaNeR/9jT0/8DqaYfdA190lxjjDmJFZXlx8RMqXP7ube276XN6nvZtHjPTfGHmdRbtEilgSHlwbEjEgTJkVBvCxvCUKPzWLqZkjPCEXZMVaq3NTZY1+yV0tut1GpNTvUZemHxLh5g28dKvRo2V+k8/AoC07KxJ0TyMgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DRBNHH5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DRBNHH5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFC3C4CEF7;
	Thu, 12 Feb 2026 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939844;
	bh=sx5l69j4CNl3osncIHn7/LXMAqTKfulJKo7dAWYDHTo=;
	h=Date:To:From:Subject:From;
	b=DRBNHH5/BCmUqo+cPqKa96yL1Fdv9wCLSo93SgvK71yeTlgzbKMfWZHIGRve4UZsN
	 E4cJDlcP4dsY9MQ6cvzhEBPHUuuubrFMJu+yrdLPRdvjmlvqN/Hwv0pdoLCxwWS9Z9
	 +k+S4L2aphTDoPtBIFWUYPJQ/Ioa6zYZmy4efjxk=
Date: Thu, 12 Feb 2026 15:44:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch removed from -mm tree
Message-Id: <20260212234404.5BFC3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update hugetlbfs to use VMA flags on mmap_prepare
has been removed from the -mm tree.  Its filename was
     mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update hugetlbfs to use VMA flags on mmap_prepare
Date: Thu, 22 Jan 2026 16:06:15 +0000

In order to update all mmap_prepare users to utilising the new VMA flags
type vma_flags_t and associated helper functions, we start by updating
hugetlbfs which has a lot of additional logic that requires updating to
make this change.

This is laying the groundwork for eliminating the vm_flags_t from struct
vm_area_desc and using vma_flags_t only, which further lays the ground for
removing the deprecated vm_flags_t type altogether.

No functional changes intended.

Link: https://lkml.kernel.org/r/9226bec80c9aa3447cc2b83354f733841dba8a50.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c           |   14 +++++++-------
 include/linux/hugetlb.h        |    6 +++---
 include/linux/hugetlb_inline.h |   10 ++++++++++
 ipc/shm.c                      |   12 +++++++-----
 mm/hugetlb.c                   |   22 +++++++++++-----------
 mm/memfd.c                     |    4 ++--
 mm/mmap.c                      |    2 +-
 7 files changed, 41 insertions(+), 29 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/fs/hugetlbfs/inode.c
@@ -109,7 +109,7 @@ static int hugetlbfs_file_mmap_prepare(s
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
@@ -119,7 +119,7 @@ static int hugetlbfs_file_mmap_prepare(s
 	 * way when do_mmap unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	desc->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
+	vma_desc_set_flags(desc, VMA_HUGETLB_BIT, VMA_DONTEXPAND_BIT);
 	desc->vm_ops = &hugetlb_vm_ops;
 
 	/*
@@ -148,23 +148,23 @@ static int hugetlbfs_file_mmap_prepare(s
 
 	ret = -ENOMEM;
 
-	vm_flags = desc->vm_flags;
+	vma_flags = desc->vma_flags;
 	/*
 	 * for SHM_HUGETLB, the pages are reserved in the shmget() call so skip
 	 * reserving here. Note: only for SHM hugetlbfs file, the inode
 	 * flag S_PRIVATE is set.
 	 */
 	if (inode->i_flags & S_PRIVATE)
-		vm_flags |= VM_NORESERVE;
+		vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 
 	if (hugetlb_reserve_pages(inode,
 			desc->pgoff >> huge_page_order(h),
 			len >> huge_page_shift(h), desc,
-			vm_flags) < 0)
+			vma_flags) < 0)
 		goto out;
 
 	ret = 0;
-	if ((desc->vm_flags & VM_WRITE) && inode->i_size < len)
+	if (vma_desc_test_flags(desc, VMA_WRITE_BIT) && inode->i_size < len)
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);
@@ -1527,7 +1527,7 @@ static int get_hstate_idx(int page_size_
  * otherwise hugetlb_reserve_pages reserves one less hugepages than intended.
  */
 struct file *hugetlb_file_setup(const char *name, size_t size,
-				vm_flags_t acctflag, int creat_flags,
+				vma_flags_t acctflag, int creat_flags,
 				int page_size_log)
 {
 	struct inode *inode;
--- a/include/linux/hugetlb.h~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/include/linux/hugetlb.h
@@ -150,7 +150,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			     struct folio **foliop);
 #endif /* CONFIG_USERFAULTFD */
 long hugetlb_reserve_pages(struct inode *inode, long from, long to,
-			   struct vm_area_desc *desc, vm_flags_t vm_flags);
+			   struct vm_area_desc *desc, vma_flags_t vma_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
@@ -529,7 +529,7 @@ static inline struct hugetlbfs_inode_inf
 }
 
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, size_t size, vma_flags_t acct,
 				int creat_flags, int page_size_log);
 
 static inline bool is_file_hugepages(const struct file *file)
@@ -545,7 +545,7 @@ static inline struct hstate *hstate_inod
 
 #define is_file_hugepages(file)			false
 static inline struct file *
-hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
+hugetlb_file_setup(const char *name, size_t size, vma_flags_t acctflag,
 		int creat_flags, int page_size_log)
 {
 	return ERR_PTR(-ENOSYS);
--- a/include/linux/hugetlb_inline.h~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/include/linux/hugetlb_inline.h
@@ -11,12 +11,22 @@ static inline bool is_vm_hugetlb_flags(v
 	return !!(vm_flags & VM_HUGETLB);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
 #else
 
 static inline bool is_vm_hugetlb_flags(vm_flags_t vm_flags)
 {
 	return false;
 }
+
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return false;
+}
 
 #endif
 
--- a/ipc/shm.c~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/ipc/shm.c
@@ -707,9 +707,9 @@ static int newseg(struct ipc_namespace *
 	int error;
 	struct shmid_kernel *shp;
 	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	const bool has_no_reserve = shmflg & SHM_NORESERVE;
 	struct file *file;
 	char name[13];
-	vm_flags_t acctflag = 0;
 
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
@@ -738,6 +738,7 @@ static int newseg(struct ipc_namespace *
 
 	sprintf(name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
+		vma_flags_t acctflag = EMPTY_VMA_FLAGS;
 		struct hstate *hs;
 		size_t hugesize;
 
@@ -749,17 +750,18 @@ static int newseg(struct ipc_namespace *
 		hugesize = ALIGN(size, huge_page_size(hs));
 
 		/* hugetlb_file_setup applies strict accounting */
-		if (shmflg & SHM_NORESERVE)
-			acctflag = VM_NORESERVE;
+		if (has_no_reserve)
+			vma_flags_set(&acctflag, VMA_NORESERVE_BIT);
 		file = hugetlb_file_setup(name, hugesize, acctflag,
 				HUGETLB_SHMFS_INODE, (shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
 	} else {
+		vm_flags_t acctflag = 0;
+
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
 		 * if it's asked for.
 		 */
-		if  ((shmflg & SHM_NORESERVE) &&
-				sysctl_overcommit_memory != OVERCOMMIT_NEVER)
+		if  (has_no_reserve && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
 			acctflag = VM_NORESERVE;
 		file = shmem_kernel_file_setup(name, size, acctflag);
 	}
--- a/mm/hugetlb.c~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/mm/hugetlb.c
@@ -1193,16 +1193,16 @@ static void set_vma_resv_flags(struct vm
 
 static void set_vma_desc_resv_map(struct vm_area_desc *desc, struct resv_map *map)
 {
-	VM_WARN_ON_ONCE(!is_vm_hugetlb_flags(desc->vm_flags));
-	VM_WARN_ON_ONCE(desc->vm_flags & VM_MAYSHARE);
+	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
+	VM_WARN_ON_ONCE(vma_desc_test_flags(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = map;
 }
 
 static void set_vma_desc_resv_flags(struct vm_area_desc *desc, unsigned long flags)
 {
-	VM_WARN_ON_ONCE(!is_vm_hugetlb_flags(desc->vm_flags));
-	VM_WARN_ON_ONCE(desc->vm_flags & VM_MAYSHARE);
+	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
+	VM_WARN_ON_ONCE(vma_desc_test_flags(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = (void *)((unsigned long)desc->private_data | flags);
 }
@@ -1216,7 +1216,7 @@ static int is_vma_resv_set(struct vm_are
 
 static bool is_vma_desc_resv_set(struct vm_area_desc *desc, unsigned long flag)
 {
-	VM_WARN_ON_ONCE(!is_vm_hugetlb_flags(desc->vm_flags));
+	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
 
 	return ((unsigned long)desc->private_data) & flag;
 }
@@ -6571,7 +6571,7 @@ next:
 long hugetlb_reserve_pages(struct inode *inode,
 		long from, long to,
 		struct vm_area_desc *desc,
-		vm_flags_t vm_flags)
+		vma_flags_t vma_flags)
 {
 	long chg = -1, add = -1, spool_resv, gbl_resv;
 	struct hstate *h = hstate_inode(inode);
@@ -6592,7 +6592,7 @@ long hugetlb_reserve_pages(struct inode
 	 * attempt will be made for VM_NORESERVE to allocate a page
 	 * without using reserves
 	 */
-	if (vm_flags & VM_NORESERVE)
+	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
 	/*
@@ -6601,7 +6601,7 @@ long hugetlb_reserve_pages(struct inode
 	 * to reserve the full area even if read-only as mprotect() may be
 	 * called to make the mapping read-write. Assume !desc is a shm mapping
 	 */
-	if (!desc || desc->vm_flags & VM_MAYSHARE) {
+	if (!desc || vma_desc_test_flags(desc, VMA_MAYSHARE_BIT)) {
 		/*
 		 * resv_map can not be NULL as hugetlb_reserve_pages is only
 		 * called for inodes for which resv_maps were created (see
@@ -6635,7 +6635,7 @@ long hugetlb_reserve_pages(struct inode
 	if (err < 0)
 		goto out_err;
 
-	if (desc && !(desc->vm_flags & VM_MAYSHARE) && h_cg) {
+	if (desc && !vma_desc_test_flags(desc, VMA_MAYSHARE_BIT) && h_cg) {
 		/* For private mappings, the hugetlb_cgroup uncharge info hangs
 		 * of the resv_map.
 		 */
@@ -6672,7 +6672,7 @@ long hugetlb_reserve_pages(struct inode
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!desc || desc->vm_flags & VM_MAYSHARE) {
+	if (!desc || vma_desc_test_flags(desc, VMA_MAYSHARE_BIT)) {
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
@@ -6727,7 +6727,7 @@ out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
-	if (!desc || desc->vm_flags & VM_MAYSHARE)
+	if (!desc || vma_desc_test_flags(desc, VMA_MAYSHARE_BIT))
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
 		 */
--- a/mm/memfd.c~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/mm/memfd.c
@@ -86,7 +86,7 @@ struct folio *memfd_alloc_folio(struct f
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
-		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, 0);
+		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
 		if (nr_resv < 0)
 			return ERR_PTR(nr_resv);
 
@@ -463,7 +463,7 @@ struct file *memfd_alloc_file(const char
 	int err = 0;
 
 	if (flags & MFD_HUGETLB) {
-		file = hugetlb_file_setup(name, 0, VM_NORESERVE,
+		file = hugetlb_file_setup(name, 0, mk_vma_flags(VMA_NORESERVE_BIT),
 					HUGETLB_ANONHUGE_INODE,
 					(flags >> MFD_HUGE_SHIFT) &
 					MFD_HUGE_MASK);
--- a/mm/mmap.c~mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare
+++ a/mm/mmap.c
@@ -594,7 +594,7 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		 * taken when vm_ops->mmap() is called
 		 */
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
-				VM_NORESERVE,
+				mk_vma_flags(VMA_NORESERVE_BIT),
 				HUGETLB_ANONHUGE_INODE,
 				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
 		if (IS_ERR(file))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are



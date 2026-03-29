Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8A209F43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744797; cv=none; b=GieFV0J+h3r7ArIZNFt/6WcRSJx1lJushDijsT/aYryMjZ231fNVfX4qNvDFq3+fGoqadQylgd1IYkVrejqlD3gUNTvLY7CSgPbytoP1pzorKxvfOEP1iLuO37g12KULQhx+gVeMskVsTQfuwCWas6rcrw2uqhorfjrqzT/O7fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744797; c=relaxed/simple;
	bh=UsDSZOWYU+e8QGX6T3YghC3YpAwljQeVhp4zShk/68U=;
	h=Date:To:From:Subject:Message-Id; b=mZYYPPAMJAgDqTeE4IwMo3+En6FNXAiB7OXkNQoDf/r4XoMPuU7kmiyCGAptX19MK5EHVC27Fqa+Ku0TPZVJBP2YlOHNd1unmlBUkrOWAN/HTauwV2SsEcRmDqAQSPf3aFPWq+gcCKftTFKu+dIADUhfctDKXvZJnx8vUTVmGMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVZbdcnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVZbdcnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BFDC4CEF7;
	Sun, 29 Mar 2026 00:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744797;
	bh=UsDSZOWYU+e8QGX6T3YghC3YpAwljQeVhp4zShk/68U=;
	h=Date:To:From:Subject:From;
	b=TVZbdcnuhDzdfnjDeVaztSuKjkaju/5k6t38AOGCoy62Z4wbKjTTii2R+9jNdTQax
	 xwxEXx4K8tXPyfhymNxRG8DPY4C13phzP7MZi3KhIzk4UyIRY35qgaw63VC1Mzgghd
	 8cBIk5FebzGH13GIXjvJFbXocg3M8jtlca6kP3yo=
Date: Sat, 28 Mar 2026 17:39:56 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,willy@infradead.org,vishal.l.verma@intel.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,naohiro.aota@wdc.com,muchun.song@linux.dev,mhocko@suse.com,lihongbo22@huawei.com,liam.howlett@oracle.com,jth@kernel.org,jgg@ziepe.ca,jefflexu@linux.alibaba.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,guochunhai@vivo.com,gregkh@linuxfoundation.org,dlemoal@kernel.org,dhavale@google.com,david@kernel.org,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,chao@kernel.org,baolin.wang@linux.alibaba.com,babu.moger@amd.com,arnd@arndb.de,almaz.alexandrovich@paragon-software.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-vma-flag-helpers-to-be-more-readable.patch removed from -mm tree
Message-Id: <20260329003957.26BFDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename VMA flag helpers to be more readable
has been removed from the -mm tree.  Its filename was
     mm-rename-vma-flag-helpers-to-be-more-readable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: rename VMA flag helpers to be more readable
Date: Thu, 5 Mar 2026 10:50:14 +0000

Patch series "mm: vma flag tweaks".

The ongoing work around introducing non-system word VMA flags has
introduced a number of helper functions and macros to make life easier
when working with these flags and to make conversions from the legacy use
of VM_xxx flags more straightforward.

This series improves these to reduce confusion as to what they do and to
improve consistency and readability.

Firstly the series renames vma_flags_test() to vma_flags_test_any() to
make it abundantly clear that this function tests whether any of the flags
are set (as opposed to vma_flags_test_all()).

It then renames vma_desc_test_flags() to vma_desc_test_any() for the same
reason.  Note that we drop the 'flags' suffix here, as
vma_desc_test_any_flags() would be cumbersome and 'test' implies a flag
test.

Similarly, we rename vma_test_all_flags() to vma_test_all() for
consistency.

Next, we have a couple of instances (erofs, zonefs) where we are now
testing for vma_desc_test_any(desc, VMA_SHARED_BIT) &&
vma_desc_test_any(desc, VMA_MAYWRITE_BIT).

This is silly, so this series introduces vma_desc_test_all() so these
callers can instead invoke vma_desc_test_all(desc, VMA_SHARED_BIT,
VMA_MAYWRITE_BIT).

We then observe that quite a few instances of vma_flags_test_any() and
vma_desc_test_any() are in fact only testing against a single flag.

Using the _any() variant here is just confusing - 'any' of single item
reads strangely and is liable to cause confusion.

So in these instances the series reintroduces vma_flags_test() and
vma_desc_test() as helpers which test against a single flag.

The fact that vma_flags_t is a struct and that vma_flag_t utilises sparse
to avoid confusion with vm_flags_t makes it impossible for a user to
misuse these helpers without it getting flagged somewhere.

The series also updates __mk_vma_flags() and functions invoked by it to
explicitly mark them always inline to match expectation and to be
consistent with other VMA flag helpers.

It also renames vma_flag_set() to vma_flags_set_flag() (a function only
used by __mk_vma_flags()) to be consistent with other VMA flag helpers.

Finally it updates the VMA tests for each of these changes, and introduces
explicit tests for vma_flags_test() and vma_desc_test() to assert that
they behave as expected.


This patch (of 6):

On reflection, it's confusing to have vma_flags_test() and
vma_desc_test_flags() test whether any comma-separated VMA flag bit is
set, while also having vma_flags_test_all() and vma_test_all_flags()
separately test whether all flags are set.

Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
confusion.

Secondly, since the VMA descriptor flag functions are becoming rather
cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
rename vma_desc_test_flags() to vma_desc_test_any().

Finally, rename vma_test_all_flags() to vma_test_all() to keep the
VMA-specific helper consistent with the VMA descriptor naming convention
and to help avoid confusion vs.  vma_flags_test_all().

While we're here, also update whitespace to be consistent in helper
functions.

Link: https://lkml.kernel.org/r/cover.1772704455.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Suggested-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hongbo Li <lihongbo22@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c              |    2 -
 drivers/dax/device.c            |    2 -
 fs/erofs/data.c                 |    4 +-
 fs/hugetlbfs/inode.c            |    2 -
 fs/ntfs3/file.c                 |    2 -
 fs/resctrl/pseudo_lock.c        |    2 -
 fs/zonefs/file.c                |    4 +-
 include/linux/dax.h             |    4 +-
 include/linux/hugetlb_inline.h  |    2 -
 include/linux/mm.h              |   48 +++++++++++++++---------------
 mm/hugetlb.c                    |   14 ++++----
 mm/memory.c                     |    2 -
 mm/secretmem.c                  |    2 -
 mm/shmem.c                      |    4 +-
 tools/testing/vma/include/dup.h |   20 ++++++------
 tools/testing/vma/tests/vma.c   |   28 ++++++++---------
 16 files changed, 72 insertions(+), 70 deletions(-)

--- a/drivers/char/mem.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/drivers/char/mem.c
@@ -520,7 +520,7 @@ static int mmap_zero_prepare(struct vm_a
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (vma_desc_test_flags(desc, VMA_SHARED_BIT))
+	if (vma_desc_test_any(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
 	desc->action.success_hook = mmap_zero_private_success;
--- a/drivers/dax/device.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/drivers/dax/device.c
@@ -24,7 +24,7 @@ static int __check_vma(struct dev_dax *d
 		return -ENXIO;
 
 	/* prevent private mappings from being established */
-	if (!vma_flags_test(&flags, VMA_MAYSHARE_BIT)) {
+	if (!vma_flags_test_any(&flags, VMA_MAYSHARE_BIT)) {
 		dev_info_ratelimited(dev,
 				"%s: %s: fail, attempted private mapping\n",
 				current->comm, func);
--- a/fs/erofs/data.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/fs/erofs/data.c
@@ -473,8 +473,8 @@ static int erofs_file_mmap_prepare(struc
 	if (!IS_DAX(file_inode(desc->file)))
 		return generic_file_readonly_mmap_prepare(desc);
 
-	if (vma_desc_test_flags(desc, VMA_SHARED_BIT) &&
-	    vma_desc_test_flags(desc, VMA_MAYWRITE_BIT))
+	if (vma_desc_test_any(desc, VMA_SHARED_BIT) &&
+	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	desc->vm_ops = &erofs_dax_vm_ops;
--- a/fs/hugetlbfs/inode.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/fs/hugetlbfs/inode.c
@@ -164,7 +164,7 @@ static int hugetlbfs_file_mmap_prepare(s
 		goto out;
 
 	ret = 0;
-	if (vma_desc_test_flags(desc, VMA_WRITE_BIT) && inode->i_size < len)
+	if (vma_desc_test_any(desc, VMA_WRITE_BIT) && inode->i_size < len)
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);
--- a/fs/ntfs3/file.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/fs/ntfs3/file.c
@@ -276,7 +276,7 @@ static int ntfs_file_mmap_prepare(struct
 	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
-	const bool rw = vma_desc_test_flags(desc, VMA_WRITE_BIT);
+	const bool rw = vma_desc_test_any(desc, VMA_WRITE_BIT);
 	int err;
 
 	/* Avoid any operation if inode is bad. */
--- a/fs/resctrl/pseudo_lock.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/fs/resctrl/pseudo_lock.c
@@ -1044,7 +1044,7 @@ static int pseudo_lock_dev_mmap_prepare(
 	 * Ensure changes are carried directly to the memory being mapped,
 	 * do not allow copy-on-write mapping.
 	 */
-	if (!vma_desc_test_flags(desc, VMA_SHARED_BIT)) {
+	if (!vma_desc_test_any(desc, VMA_SHARED_BIT)) {
 		mutex_unlock(&rdtgroup_mutex);
 		return -EINVAL;
 	}
--- a/fs/zonefs/file.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/fs/zonefs/file.c
@@ -333,8 +333,8 @@ static int zonefs_file_mmap_prepare(stru
 	 * ordering between msync() and page cache writeback.
 	 */
 	if (zonefs_inode_is_seq(file_inode(file)) &&
-	    vma_desc_test_flags(desc, VMA_SHARED_BIT) &&
-	    vma_desc_test_flags(desc, VMA_MAYWRITE_BIT))
+	    vma_desc_test_any(desc, VMA_SHARED_BIT) &&
+	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	file_accessed(file);
--- a/include/linux/dax.h~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/include/linux/dax.h
@@ -69,7 +69,7 @@ static inline bool daxdev_mapping_suppor
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	if (!vma_desc_test_flags(desc, VMA_SYNC_BIT))
+	if (!vma_desc_test_any(desc, VMA_SYNC_BIT))
 		return true;
 	if (!IS_DAX(inode))
 		return false;
@@ -115,7 +115,7 @@ static inline bool daxdev_mapping_suppor
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	return !vma_desc_test_flags(desc, VMA_SYNC_BIT);
+	return !vma_desc_test_any(desc, VMA_SYNC_BIT);
 }
 static inline size_t dax_recovery_write(struct dax_device *dax_dev,
 		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
--- a/include/linux/hugetlb_inline.h~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/include/linux/hugetlb_inline.h
@@ -13,7 +13,7 @@ static inline bool is_vm_hugetlb_flags(v
 
 static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
 {
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
+	return vma_flags_test_any(flags, VMA_HUGETLB_BIT);
 }
 
 #else
--- a/include/linux/mm.h~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/include/linux/mm.h
@@ -1062,7 +1062,7 @@ static inline vma_flags_t __mk_vma_flags
 					 (const vma_flag_t []){__VA_ARGS__})
 
 /*  Test each of to_test flags in flags, non-atomically. */
-static __always_inline bool vma_flags_test_mask(const vma_flags_t *flags,
+static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
 {
 	const unsigned long *bitmap = flags->__vma_flags;
@@ -1074,10 +1074,10 @@ static __always_inline bool vma_flags_te
 /*
  * Test whether any specified VMA flag is set, e.g.:
  *
- * if (vma_flags_test(flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
+ * if (vma_flags_test_any(flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
  */
-#define vma_flags_test(flags, ...) \
-	vma_flags_test_mask(flags, mk_vma_flags(__VA_ARGS__))
+#define vma_flags_test_any(flags, ...) \
+	vma_flags_test_any_mask(flags, mk_vma_flags(__VA_ARGS__))
 
 /* Test that ALL of the to_test flags are set, non-atomically. */
 static __always_inline bool vma_flags_test_all_mask(const vma_flags_t *flags,
@@ -1098,7 +1098,8 @@ static __always_inline bool vma_flags_te
 	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
 
 /* Set each of the to_set flags in flags, non-atomically. */
-static __always_inline void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set)
+static __always_inline void vma_flags_set_mask(vma_flags_t *flags,
+		vma_flags_t to_set)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 	const unsigned long *bitmap_to_set = to_set.__vma_flags;
@@ -1115,7 +1116,8 @@ static __always_inline void vma_flags_se
 	vma_flags_set_mask(flags, mk_vma_flags(__VA_ARGS__))
 
 /* Clear all of the to-clear flags in flags, non-atomically. */
-static __always_inline void vma_flags_clear_mask(vma_flags_t *flags, vma_flags_t to_clear)
+static __always_inline void vma_flags_clear_mask(vma_flags_t *flags,
+		vma_flags_t to_clear)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 	const unsigned long *bitmap_to_clear = to_clear.__vma_flags;
@@ -1137,8 +1139,8 @@ static __always_inline void vma_flags_cl
  * Note: appropriate locks must be held, this function does not acquire them for
  * you.
  */
-static inline bool vma_test_all_flags_mask(const struct vm_area_struct *vma,
-					   vma_flags_t flags)
+static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
+		vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&vma->flags, flags);
 }
@@ -1146,10 +1148,10 @@ static inline bool vma_test_all_flags_ma
 /*
  * Helper macro for checking that ALL specified flags are set in a VMA, e.g.:
  *
- * if (vma_test_all_flags(vma, VMA_READ_BIT, VMA_MAYREAD_BIT) { ... }
+ * if (vma_test_all(vma, VMA_READ_BIT, VMA_MAYREAD_BIT) { ... }
  */
-#define vma_test_all_flags(vma, ...) \
-	vma_test_all_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+#define vma_test_all(vma, ...) \
+	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
 
 /*
  * Helper to set all VMA flags in a VMA.
@@ -1158,7 +1160,7 @@ static inline bool vma_test_all_flags_ma
  * you.
  */
 static inline void vma_set_flags_mask(struct vm_area_struct *vma,
-				      vma_flags_t flags)
+		vma_flags_t flags)
 {
 	vma_flags_set_mask(&vma->flags, flags);
 }
@@ -1176,25 +1178,25 @@ static inline void vma_set_flags_mask(st
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
 /* Helper to test all VMA flags in a VMA descriptor. */
-static inline bool vma_desc_test_flags_mask(const struct vm_area_desc *desc,
-					    vma_flags_t flags)
+static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
 {
-	return vma_flags_test_mask(&desc->vma_flags, flags);
+	return vma_flags_test_any_mask(&desc->vma_flags, flags);
 }
 
 /*
  * Helper macro for testing VMA flags for an input pointer to a struct
  * vm_area_desc object describing a proposed VMA, e.g.:
  *
- * if (vma_desc_test_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
+ * if (vma_desc_test_any(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
  *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
  */
-#define vma_desc_test_flags(desc, ...) \
-	vma_desc_test_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+#define vma_desc_test_any(desc, ...) \
+	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
 /* Helper to set all VMA flags in a VMA descriptor. */
 static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
-					   vma_flags_t flags)
+		vma_flags_t flags)
 {
 	vma_flags_set_mask(&desc->vma_flags, flags);
 }
@@ -1211,7 +1213,7 @@ static inline void vma_desc_set_flags_ma
 
 /* Helper to clear all VMA flags in a VMA descriptor. */
 static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
-					     vma_flags_t flags)
+		vma_flags_t flags)
 {
 	vma_flags_clear_mask(&desc->vma_flags, flags);
 }
@@ -1936,8 +1938,8 @@ static inline bool vma_desc_is_cow_mappi
 {
 	const vma_flags_t *flags = &desc->vma_flags;
 
-	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
-		!vma_flags_test(flags, VMA_SHARED_BIT);
+	return vma_flags_test_any(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test_any(flags, VMA_SHARED_BIT);
 }
 
 #ifndef CONFIG_MMU
@@ -1956,7 +1958,7 @@ static inline bool is_nommu_shared_mappi
 
 static inline bool is_nommu_shared_vma_flags(const vma_flags_t *flags)
 {
-	return vma_flags_test(flags, VMA_MAYSHARE_BIT, VMA_MAYOVERLAY_BIT);
+	return vma_flags_test_any(flags, VMA_MAYSHARE_BIT, VMA_MAYOVERLAY_BIT);
 }
 #endif
 
--- a/mm/hugetlb.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/mm/hugetlb.c
@@ -1194,7 +1194,7 @@ static void set_vma_resv_flags(struct vm
 static void set_vma_desc_resv_map(struct vm_area_desc *desc, struct resv_map *map)
 {
 	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test_flags(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE(vma_desc_test_any(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = map;
 }
@@ -1202,7 +1202,7 @@ static void set_vma_desc_resv_map(struct
 static void set_vma_desc_resv_flags(struct vm_area_desc *desc, unsigned long flags)
 {
 	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test_flags(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE(vma_desc_test_any(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = (void *)((unsigned long)desc->private_data | flags);
 }
@@ -6593,7 +6593,7 @@ long hugetlb_reserve_pages(struct inode
 	 * attempt will be made for VM_NORESERVE to allocate a page
 	 * without using reserves
 	 */
-	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
+	if (vma_flags_test_any(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
 	/*
@@ -6602,7 +6602,7 @@ long hugetlb_reserve_pages(struct inode
 	 * to reserve the full area even if read-only as mprotect() may be
 	 * called to make the mapping read-write. Assume !desc is a shm mapping
 	 */
-	if (!desc || vma_desc_test_flags(desc, VMA_MAYSHARE_BIT)) {
+	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT)) {
 		/*
 		 * resv_map can not be NULL as hugetlb_reserve_pages is only
 		 * called for inodes for which resv_maps were created (see
@@ -6636,7 +6636,7 @@ long hugetlb_reserve_pages(struct inode
 	if (err < 0)
 		goto out_err;
 
-	if (desc && !vma_desc_test_flags(desc, VMA_MAYSHARE_BIT) && h_cg) {
+	if (desc && !vma_desc_test_any(desc, VMA_MAYSHARE_BIT) && h_cg) {
 		/* For private mappings, the hugetlb_cgroup uncharge info hangs
 		 * of the resv_map.
 		 */
@@ -6673,7 +6673,7 @@ long hugetlb_reserve_pages(struct inode
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!desc || vma_desc_test_flags(desc, VMA_MAYSHARE_BIT)) {
+	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT)) {
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
@@ -6737,7 +6737,7 @@ out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
-	if (!desc || vma_desc_test_flags(desc, VMA_MAYSHARE_BIT))
+	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT))
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
 		 */
--- a/mm/memory.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/mm/memory.c
@@ -2982,7 +2982,7 @@ static int remap_pfn_range_internal(stru
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
 		return -EINVAL;
 
-	VM_WARN_ON_ONCE(!vma_test_all_flags_mask(vma, VMA_REMAP_FLAGS));
+	VM_WARN_ON_ONCE(!vma_test_all_mask(vma, VMA_REMAP_FLAGS));
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
--- a/mm/secretmem.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/mm/secretmem.c
@@ -122,7 +122,7 @@ static int secretmem_mmap_prepare(struct
 {
 	const unsigned long len = vma_desc_size(desc);
 
-	if (!vma_desc_test_flags(desc, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))
+	if (!vma_desc_test_any(desc, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))
 		return -EINVAL;
 
 	vma_desc_set_flags(desc, VMA_LOCKED_BIT, VMA_DONTDUMP_BIT);
--- a/mm/shmem.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/mm/shmem.c
@@ -3086,7 +3086,7 @@ static struct inode *__shmem_get_inode(s
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = vma_flags_test(&flags, VMA_NORESERVE_BIT)
+	info->flags = vma_flags_test_any(&flags, VMA_NORESERVE_BIT)
 		? SHMEM_F_NORESERVE : 0;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
@@ -5827,7 +5827,7 @@ static struct file *__shmem_file_setup(s
 				       unsigned int i_flags)
 {
 	const unsigned long shmem_flags =
-		vma_flags_test(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
+		vma_flags_test_any(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
--- a/tools/testing/vma/include/dup.h~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/tools/testing/vma/include/dup.h
@@ -843,7 +843,7 @@ static inline vma_flags_t __mk_vma_flags
 #define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
 					 (const vma_flag_t []){__VA_ARGS__})
 
-static __always_inline bool vma_flags_test_mask(const vma_flags_t *flags,
+static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
 {
 	const unsigned long *bitmap = flags->__vma_flags;
@@ -852,8 +852,8 @@ static __always_inline bool vma_flags_te
 	return bitmap_intersects(bitmap_to_test, bitmap, NUM_VMA_FLAG_BITS);
 }
 
-#define vma_flags_test(flags, ...) \
-	vma_flags_test_mask(flags, mk_vma_flags(__VA_ARGS__))
+#define vma_flags_test_any(flags, ...) \
+	vma_flags_test_any_mask(flags, mk_vma_flags(__VA_ARGS__))
 
 static __always_inline bool vma_flags_test_all_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
@@ -889,14 +889,14 @@ static __always_inline void vma_flags_cl
 #define vma_flags_clear(flags, ...) \
 	vma_flags_clear_mask(flags, mk_vma_flags(__VA_ARGS__))
 
-static inline bool vma_test_all_flags_mask(const struct vm_area_struct *vma,
+static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 					   vma_flags_t flags)
 {
 	return vma_flags_test_all_mask(&vma->flags, flags);
 }
 
-#define vma_test_all_flags(vma, ...) \
-	vma_test_all_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+#define vma_test_all(vma, ...) \
+	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
 
 static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
@@ -913,14 +913,14 @@ static inline void vma_set_flags_mask(st
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
-static inline bool vma_desc_test_flags_mask(const struct vm_area_desc *desc,
+static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 					    vma_flags_t flags)
 {
-	return vma_flags_test_mask(&desc->vma_flags, flags);
+	return vma_flags_test_any_mask(&desc->vma_flags, flags);
 }
 
-#define vma_desc_test_flags(desc, ...) \
-	vma_desc_test_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+#define vma_desc_test_any(desc, ...) \
+	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
 static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 					   vma_flags_t flags)
--- a/tools/testing/vma/tests/vma.c~mm-rename-vma-flag-helpers-to-be-more-readable
+++ a/tools/testing/vma/tests/vma.c
@@ -159,8 +159,8 @@ static bool test_vma_flags_word(void)
 	return true;
 }
 
-/* Ensure that vma_flags_test() and friends works correctly. */
-static bool test_vma_flags_test(void)
+/* Ensure that vma_flags_test_any() and friends works correctly. */
+static bool test_vma_flags_test_any(void)
 {
 	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
 					       VMA_EXEC_BIT, 64, 65);
@@ -171,16 +171,16 @@ static bool test_vma_flags_test(void)
 	desc.vma_flags = flags;
 
 #define do_test(...)						\
-	ASSERT_TRUE(vma_flags_test(&flags, __VA_ARGS__));	\
-	ASSERT_TRUE(vma_desc_test_flags(&desc, __VA_ARGS__))
+	ASSERT_TRUE(vma_flags_test_any(&flags, __VA_ARGS__));	\
+	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__))
 
 #define do_test_all_true(...)					\
 	ASSERT_TRUE(vma_flags_test_all(&flags, __VA_ARGS__));	\
-	ASSERT_TRUE(vma_test_all_flags(&vma, __VA_ARGS__))
+	ASSERT_TRUE(vma_test_all(&vma, __VA_ARGS__))
 
 #define do_test_all_false(...)					\
 	ASSERT_FALSE(vma_flags_test_all(&flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_test_all_flags(&vma, __VA_ARGS__))
+	ASSERT_FALSE(vma_test_all(&vma, __VA_ARGS__))
 
 	/*
 	 * Testing for some flags that are present, some that are not - should
@@ -200,7 +200,7 @@ static bool test_vma_flags_test(void)
 	 * Check _mask variant. We don't need to test extensively as macro
 	 * helper is the equivalent.
 	 */
-	ASSERT_TRUE(vma_flags_test_mask(&flags, flags));
+	ASSERT_TRUE(vma_flags_test_any_mask(&flags, flags));
 	ASSERT_TRUE(vma_flags_test_all_mask(&flags, flags));
 
 	/* Single bits. */
@@ -268,9 +268,9 @@ static bool test_vma_flags_clear(void)
 	vma_flags_clear_mask(&flags, mask);
 	vma_flags_clear_mask(&vma.flags, mask);
 	vma_desc_clear_flags_mask(&desc, mask);
-	ASSERT_FALSE(vma_flags_test(&flags, VMA_EXEC_BIT, 64));
-	ASSERT_FALSE(vma_flags_test(&vma.flags, VMA_EXEC_BIT, 64));
-	ASSERT_FALSE(vma_desc_test_flags(&desc, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_flags_test_any(&flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_flags_test_any(&vma.flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_desc_test_any(&desc, VMA_EXEC_BIT, 64));
 	/* Reset. */
 	vma_flags_set(&flags, VMA_EXEC_BIT, 64);
 	vma_set_flags(&vma, VMA_EXEC_BIT, 64);
@@ -284,9 +284,9 @@ static bool test_vma_flags_clear(void)
 	vma_flags_clear(&flags, __VA_ARGS__);			\
 	vma_flags_clear(&vma.flags, __VA_ARGS__);		\
 	vma_desc_clear_flags(&desc, __VA_ARGS__);		\
-	ASSERT_FALSE(vma_flags_test(&flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_flags_test(&vma.flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_desc_test_flags(&desc, __VA_ARGS__));	\
+	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));	\
+	ASSERT_FALSE(vma_flags_test_any(&vma.flags, __VA_ARGS__));	\
+	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));	\
 	vma_flags_set(&flags, __VA_ARGS__);			\
 	vma_set_flags(&vma, __VA_ARGS__);			\
 	vma_desc_set_flags(&desc, __VA_ARGS__)
@@ -334,6 +334,6 @@ static void run_vma_tests(int *num_tests
 	TEST(vma_flags_unchanged);
 	TEST(vma_flags_cleared);
 	TEST(vma_flags_word);
-	TEST(vma_flags_test);
+	TEST(vma_flags_test_any);
 	TEST(vma_flags_clear);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
tools-bitmap-add-missing-bitmap_copy-implementation.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-simplify-vma-flag-tests-of-excluded-flags.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-avoid-deadlock-when-holding-rmap-on-mmap_prepare-error.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch
mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch
mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-revert-mmap_prepare-change.patch
fs-afs-restore-mmap_prepare-implementation.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch
mm-huge_memory-simplify-vma_is_specal_huge.patch
mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch
mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch
mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch
mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch
mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch
mm-huge_memory-deduplicate-zap-deposited-table-call.patch
mm-huge_memory-remove-unnecessary-sanity-checks.patch
mm-huge_memory-use-mm-instead-of-tlb-mm.patch
mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch
mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch


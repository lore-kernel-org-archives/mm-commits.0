From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-use-__gfp_highmem-implicitly.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:02:56 -0700
Message-ID: <20170509180256.4fna5DmWU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754061AbdEISC5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm, vmalloc: use __GFP_HIGHMEM implicitly
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-__gfp_highmem-implicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmalloc: use __GFP_HIGHMEM implicitly

__vmalloc* allows users to provide gfp flags for the underlying
allocation. This API is quite popular
$ git grep "=[[:space:]]__vmalloc\|return[[:space:]]*__vmalloc" | wc -l
77

The only problem is that many people are not aware that they really want
to give __GFP_HIGHMEM along with other flags because there is really no
reason to consume precious lowmemory on CONFIG_HIGHMEM systems for pages
which are mapped to the kernel vmalloc space.  About half of users don't
use this flag, though.  This signals that we make the API unnecessarily
too complex.

This patch simply uses __GFP_HIGHMEM implicitly when allocating pages to
be mapped to the vmalloc space.  Current users which add __GFP_HIGHMEM are
simplified and drop the flag.

Link: http://lkml.kernel.org/r/20170307141020.29107-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Cristopher Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/module.c            |    2 +-
 arch/x86/kernel/module.c               |    2 +-
 drivers/block/drbd/drbd_bitmap.c       |    2 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c |    4 ++--
 drivers/md/dm-bufio.c                  |    2 +-
 fs/btrfs/free-space-tree.c             |    3 +--
 fs/file.c                              |    2 +-
 fs/xfs/kmem.c                          |    2 +-
 include/drm/drm_mem_util.h             |    9 +++------
 kernel/bpf/core.c                      |    9 +++------
 kernel/bpf/syscall.c                   |    3 +--
 kernel/fork.c                          |    2 +-
 kernel/groups.c                        |    2 +-
 kernel/module.c                        |    2 +-
 mm/kasan/kasan.c                       |    2 +-
 mm/nommu.c                             |    3 +--
 mm/util.c                              |    2 +-
 mm/vmalloc.c                           |   14 +++++++-------
 net/ceph/ceph_common.c                 |    2 +-
 net/netfilter/x_tables.c               |    3 +--
 20 files changed, 31 insertions(+), 41 deletions(-)

diff -puN arch/parisc/kernel/module.c~mm-vmalloc-use-__gfp_highmem-implicitly arch/parisc/kernel/module.c
--- a/arch/parisc/kernel/module.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/arch/parisc/kernel/module.c
@@ -218,7 +218,7 @@ void *module_alloc(unsigned long size)
 	 * easier than trying to map the text, data, init_text and
 	 * init_data correctly */
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
-				    GFP_KERNEL | __GFP_HIGHMEM,
+				    GFP_KERNEL,
 				    PAGE_KERNEL_RWX, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
diff -puN arch/x86/kernel/module.c~mm-vmalloc-use-__gfp_highmem-implicitly arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/arch/x86/kernel/module.c
@@ -85,7 +85,7 @@ void *module_alloc(unsigned long size)
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
-				    MODULES_END, GFP_KERNEL | __GFP_HIGHMEM,
+				    MODULES_END, GFP_KERNEL,
 				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 	if (p && (kasan_module_alloc(p, size) < 0)) {
diff -puN drivers/block/drbd/drbd_bitmap.c~mm-vmalloc-use-__gfp_highmem-implicitly drivers/block/drbd/drbd_bitmap.c
--- a/drivers/block/drbd/drbd_bitmap.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -409,7 +409,7 @@ static struct page **bm_realloc_pages(st
 	new_pages = kzalloc(bytes, GFP_NOIO | __GFP_NOWARN);
 	if (!new_pages) {
 		new_pages = __vmalloc(bytes,
-				GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO,
+				GFP_NOIO | __GFP_ZERO,
 				PAGE_KERNEL);
 		if (!new_pages)
 			return NULL;
diff -puN drivers/gpu/drm/etnaviv/etnaviv_dump.c~mm-vmalloc-use-__gfp_highmem-implicitly drivers/gpu/drm/etnaviv/etnaviv_dump.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -161,8 +161,8 @@ void etnaviv_core_dump(struct etnaviv_gp
 	file_size += sizeof(*iter.hdr) * n_obj;
 
 	/* Allocate the file in vmalloc memory, it's likely to be big */
-	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_HIGHMEM |
-			       __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);
+	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
+			       PAGE_KERNEL);
 	if (!iter.start) {
 		dev_warn(gpu->dev, "failed to allocate devcoredump file\n");
 		return;
diff -puN drivers/md/dm-bufio.c~mm-vmalloc-use-__gfp_highmem-implicitly drivers/md/dm-bufio.c
--- a/drivers/md/dm-bufio.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/drivers/md/dm-bufio.c
@@ -406,7 +406,7 @@ static void *alloc_buffer_data(struct dm
 	if (gfp_mask & __GFP_NORETRY)
 		noio_flag = memalloc_noio_save();
 
-	ptr = __vmalloc(c->block_size, gfp_mask | __GFP_HIGHMEM, PAGE_KERNEL);
+	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
 
 	if (gfp_mask & __GFP_NORETRY)
 		memalloc_noio_restore(noio_flag);
diff -puN fs/btrfs/free-space-tree.c~mm-vmalloc-use-__gfp_highmem-implicitly fs/btrfs/free-space-tree.c
--- a/fs/btrfs/free-space-tree.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/fs/btrfs/free-space-tree.c
@@ -167,8 +167,7 @@ static u8 *alloc_bitmap(u32 bitmap_size)
 	if (mem)
 		return mem;
 
-	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_HIGHMEM | __GFP_ZERO,
-			 PAGE_KERNEL);
+	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_ZERO, PAGE_KERNEL);
 }
 
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
diff -puN fs/file.c~mm-vmalloc-use-__gfp_highmem-implicitly fs/file.c
--- a/fs/file.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/fs/file.c
@@ -42,7 +42,7 @@ static void *alloc_fdmem(size_t size)
 		if (data != NULL)
 			return data;
 	}
-	return __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM, PAGE_KERNEL);
+	return __vmalloc(size, GFP_KERNEL_ACCOUNT, PAGE_KERNEL);
 }
 
 static void __free_fdtable(struct fdtable *fdt)
diff -puN fs/xfs/kmem.c~mm-vmalloc-use-__gfp_highmem-implicitly fs/xfs/kmem.c
--- a/fs/xfs/kmem.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/fs/xfs/kmem.c
@@ -67,7 +67,7 @@ kmem_zalloc_large(size_t size, xfs_km_fl
 		nofs_flag = memalloc_nofs_save();
 
 	lflags = kmem_flags_convert(flags);
-	ptr = __vmalloc(size, lflags | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
+	ptr = __vmalloc(size, lflags | __GFP_ZERO, PAGE_KERNEL);
 
 	if (flags & KM_NOFS)
 		memalloc_nofs_restore(nofs_flag);
diff -puN include/drm/drm_mem_util.h~mm-vmalloc-use-__gfp_highmem-implicitly include/drm/drm_mem_util.h
--- a/include/drm/drm_mem_util.h~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/include/drm/drm_mem_util.h
@@ -37,8 +37,7 @@ static __inline__ void *drm_calloc_large
 	if (size * nmemb <= PAGE_SIZE)
 	    return kcalloc(nmemb, size, GFP_KERNEL);
 
-	return __vmalloc(size * nmemb,
-			 GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
+	return vzalloc(size * nmemb);
 }
 
 /* Modeled after cairo's malloc_ab, it's like calloc but without the zeroing. */
@@ -50,8 +49,7 @@ static __inline__ void *drm_malloc_ab(si
 	if (size * nmemb <= PAGE_SIZE)
 	    return kmalloc(nmemb * size, GFP_KERNEL);
 
-	return __vmalloc(size * nmemb,
-			 GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL);
+	return vmalloc(size * nmemb);
 }
 
 static __inline__ void *drm_malloc_gfp(size_t nmemb, size_t size, gfp_t gfp)
@@ -69,8 +67,7 @@ static __inline__ void *drm_malloc_gfp(s
 			return ptr;
 	}
 
-	return __vmalloc(size * nmemb,
-			 gfp | __GFP_HIGHMEM, PAGE_KERNEL);
+	return __vmalloc(size * nmemb, gfp, PAGE_KERNEL);
 }
 
 static __inline void drm_free_large(void *ptr)
diff -puN kernel/bpf/core.c~mm-vmalloc-use-__gfp_highmem-implicitly kernel/bpf/core.c
--- a/kernel/bpf/core.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/kernel/bpf/core.c
@@ -76,8 +76,7 @@ void *bpf_internal_load_pointer_neg_help
 
 struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO |
-			  gfp_extra_flags;
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog_aux *aux;
 	struct bpf_prog *fp;
 
@@ -107,8 +106,7 @@ EXPORT_SYMBOL_GPL(bpf_prog_alloc);
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 				  gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO |
-			  gfp_extra_flags;
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
 	u32 pages, delta;
 	int ret;
@@ -655,8 +653,7 @@ out:
 static struct bpf_prog *bpf_prog_clone_create(struct bpf_prog *fp_other,
 					      gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO |
-			  gfp_extra_flags;
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
 
 	fp = __vmalloc(fp_other->pages * PAGE_SIZE, gfp_flags, PAGE_KERNEL);
diff -puN kernel/bpf/syscall.c~mm-vmalloc-use-__gfp_highmem-implicitly kernel/bpf/syscall.c
--- a/kernel/bpf/syscall.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/kernel/bpf/syscall.c
@@ -67,8 +67,7 @@ void *bpf_map_area_alloc(size_t size)
 			return area;
 	}
 
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | flags,
-			 PAGE_KERNEL);
+	return __vmalloc(size, GFP_KERNEL | flags, PAGE_KERNEL);
 }
 
 void bpf_map_area_free(void *area)
diff -puN kernel/fork.c~mm-vmalloc-use-__gfp_highmem-implicitly kernel/fork.c
--- a/kernel/fork.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/kernel/fork.c
@@ -221,7 +221,7 @@ static unsigned long *alloc_thread_stack
 
 	stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
 				     VMALLOC_START, VMALLOC_END,
-				     THREADINFO_GFP | __GFP_HIGHMEM,
+				     THREADINFO_GFP,
 				     PAGE_KERNEL,
 				     0, node, __builtin_return_address(0));
 
diff -puN kernel/groups.c~mm-vmalloc-use-__gfp_highmem-implicitly kernel/groups.c
--- a/kernel/groups.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/kernel/groups.c
@@ -18,7 +18,7 @@ struct group_info *groups_alloc(int gids
 	len = sizeof(struct group_info) + sizeof(kgid_t) * gidsetsize;
 	gi = kmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY);
 	if (!gi)
-		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_HIGHMEM, PAGE_KERNEL);
+		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT, PAGE_KERNEL);
 	if (!gi)
 		return NULL;
 
diff -puN kernel/module.c~mm-vmalloc-use-__gfp_highmem-implicitly kernel/module.c
--- a/kernel/module.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/kernel/module.c
@@ -2864,7 +2864,7 @@ static int copy_module_from_user(const v
 
 	/* Suck in entire file: we'll want most of it. */
 	info->hdr = __vmalloc(info->len,
-			GFP_KERNEL | __GFP_HIGHMEM | __GFP_NOWARN, PAGE_KERNEL);
+			GFP_KERNEL | __GFP_NOWARN, PAGE_KERNEL);
 	if (!info->hdr)
 		return -ENOMEM;
 
diff -puN mm/kasan/kasan.c~mm-vmalloc-use-__gfp_highmem-implicitly mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/mm/kasan/kasan.c
@@ -691,7 +691,7 @@ int kasan_module_alloc(void *addr, size_
 
 	ret = __vmalloc_node_range(shadow_size, 1, shadow_start,
 			shadow_start + shadow_size,
-			GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			GFP_KERNEL | __GFP_ZERO,
 			PAGE_KERNEL, VM_NO_GUARD, NUMA_NO_NODE,
 			__builtin_return_address(0));
 
diff -puN mm/nommu.c~mm-vmalloc-use-__gfp_highmem-implicitly mm/nommu.c
--- a/mm/nommu.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/mm/nommu.c
@@ -246,8 +246,7 @@ void *vmalloc_user(unsigned long size)
 {
 	void *ret;
 
-	ret = __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
-			PAGE_KERNEL);
+	ret = __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
 	if (ret) {
 		struct vm_area_struct *vma;
 
diff -puN mm/util.c~mm-vmalloc-use-__gfp_highmem-implicitly mm/util.c
--- a/mm/util.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/mm/util.c
@@ -382,7 +382,7 @@ void *kvmalloc_node(size_t size, gfp_t f
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-	return __vmalloc_node_flags(size, node, flags | __GFP_HIGHMEM);
+	return __vmalloc_node_flags(size, node, flags);
 }
 EXPORT_SYMBOL(kvmalloc_node);
 
diff -puN mm/vmalloc.c~mm-vmalloc-use-__gfp_highmem-implicitly mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/mm/vmalloc.c
@@ -1655,7 +1655,7 @@ static void *__vmalloc_area_node(struct
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
-	const gfp_t alloc_mask = gfp_mask | __GFP_NOWARN;
+	const gfp_t alloc_mask = gfp_mask | __GFP_HIGHMEM | __GFP_NOWARN;
 
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1818,7 +1818,7 @@ EXPORT_SYMBOL(__vmalloc);
 void *vmalloc(unsigned long size)
 {
 	return __vmalloc_node_flags(size, NUMA_NO_NODE,
-				    GFP_KERNEL | __GFP_HIGHMEM);
+				    GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -1835,7 +1835,7 @@ EXPORT_SYMBOL(vmalloc);
 void *vzalloc(unsigned long size)
 {
 	return __vmalloc_node_flags(size, NUMA_NO_NODE,
-				GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+				GFP_KERNEL | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vzalloc);
 
@@ -1852,7 +1852,7 @@ void *vmalloc_user(unsigned long size)
 	void *ret;
 
 	ret = __vmalloc_node(size, SHMLBA,
-			     GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			     GFP_KERNEL | __GFP_ZERO,
 			     PAGE_KERNEL, NUMA_NO_NODE,
 			     __builtin_return_address(0));
 	if (ret) {
@@ -1876,7 +1876,7 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL, PAGE_KERNEL,
 					node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
@@ -1896,7 +1896,7 @@ EXPORT_SYMBOL(vmalloc_node);
 void *vzalloc_node(unsigned long size, int node)
 {
 	return __vmalloc_node_flags(size, node,
-			 GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+			 GFP_KERNEL | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vzalloc_node);
 
@@ -1918,7 +1918,7 @@ EXPORT_SYMBOL(vzalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+	return __vmalloc_node(size, 1, GFP_KERNEL, PAGE_KERNEL_EXEC,
 			      NUMA_NO_NODE, __builtin_return_address(0));
 }
 
diff -puN net/ceph/ceph_common.c~mm-vmalloc-use-__gfp_highmem-implicitly net/ceph/ceph_common.c
--- a/net/ceph/ceph_common.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/net/ceph/ceph_common.c
@@ -187,7 +187,7 @@ void *ceph_kvmalloc(size_t size, gfp_t f
 			return ptr;
 	}
 
-	return __vmalloc(size, flags | __GFP_HIGHMEM, PAGE_KERNEL);
+	return __vmalloc(size, flags, PAGE_KERNEL);
 }
 
 
diff -puN net/netfilter/x_tables.c~mm-vmalloc-use-__gfp_highmem-implicitly net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~mm-vmalloc-use-__gfp_highmem-implicitly
+++ a/net/netfilter/x_tables.c
@@ -998,8 +998,7 @@ struct xt_table_info *xt_alloc_table_inf
 	if (sz <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
 		info = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!info) {
-		info = __vmalloc(sz, GFP_KERNEL | __GFP_NOWARN |
-				     __GFP_NORETRY | __GFP_HIGHMEM,
+		info = __vmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
 				 PAGE_KERNEL);
 		if (!info)
 			return NULL;
_

Patches currently in -mm which might be from mhocko@suse.com are



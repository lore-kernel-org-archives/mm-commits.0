From: akpm@linux-foundation.org
Subject: [patch 052/114] mm: introduce kv[mz]alloc helpers
Date: Mon, 08 May 2017 15:57:09 -0700
Message-ID: <20170508225709.Jk8PPAJW3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdEHW5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger@dilger.ca, akpm@linux-foundation.org, davem@davemloft.net, jhubbard@nvidia.com, mhocko@suse.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: introduce kv[mz]alloc helpers

Patch series "kvmalloc", v5.

There are many open coded kmalloc with vmalloc fallback instances in the
tree.  Most of them are not careful enough or simply do not care about the
underlying semantic of the kmalloc/page allocator which means that a) some
vmalloc fallbacks are basically unreachable because the kmalloc part will
keep retrying until it succeeds b) the page allocator can invoke a really
disruptive steps like the OOM killer to move forward which doesn't sound
appropriate when we consider that the vmalloc fallback is available.

As it can be seen implementing kvmalloc requires quite an intimate
knowledge if the page allocator and the memory reclaim internals which
strongly suggests that a helper should be implemented in the memory
subsystem proper.

Most callers, I could find, have been converted to use the helper instead.
This is patch 6.  There are some more relying on __GFP_REPEAT in the
networking stack which I have converted as well and Eric Dumazet was not
opposed [2] to convert them as well.

[1] http://lkml.kernel.org/r/20170130094940.13546-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/1485273626.16328.301.camel@edumazet-glaptop3.roam.corp.google.com


This patch (of 9):

Using kmalloc with the vmalloc fallback for larger allocations is a common
pattern in the kernel code.  Yet we do not have any common helper for that
and so users have invented their own helpers.  Some of them are really
creative when doing so.  Let's just add kv[mz]alloc and make sure it is
implemented properly.  This implementation makes sure to not make a large
memory pressure for > PAGE_SZE requests (__GFP_NORETRY) and also to not
warn about allocation failures.  This also rules out the OOM killer as the
vmalloc is a more approapriate fallback than a disruptive user visible
action.

This patch also changes some existing users and removes helpers which are
specific for them.  In some cases this is not possible (e.g. 
ext4_kvmalloc, libcfs_kvzalloc) because those seems to be broken and
require GFP_NO{FS,IO} context which is not vmalloc compatible in general
(note that the page table allocation is GFP_KERNEL).  Those need to be
fixed separately.

While we are at it, document that __vmalloc{_node} about unsupported gfp
mask because there seems to be a lot of confusion out there. 
kvmalloc_node will warn about GFP_KERNEL incompatible (which are not
superset) flags to catch new abusers.  Existing ones would have to die
slowly.

[sfr@canb.auug.org.au: f2fs fixup]
  Link: http://lkml.kernel.org/r/20170320163735.332e64b7@canb.auug.org.au
Link: http://lkml.kernel.org/r/20170306103032.2540-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>	[ext4 part]
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/lapic.c              |    4 +-
 arch/x86/kvm/page_track.c         |    4 +-
 arch/x86/kvm/x86.c                |    4 +-
 drivers/md/dm-stats.c             |    7 ----
 fs/ext4/mballoc.c                 |    2 -
 fs/ext4/super.c                   |    4 +-
 fs/f2fs/f2fs.h                    |   20 ------------
 fs/f2fs/file.c                    |    4 +-
 fs/f2fs/node.c                    |    6 +--
 fs/f2fs/segment.c                 |   14 ++++----
 fs/seq_file.c                     |   16 ---------
 include/linux/kvm_host.h          |    2 -
 include/linux/mm.h                |   14 ++++++++
 include/linux/vmalloc.h           |    1 
 ipc/util.c                        |    7 ----
 mm/nommu.c                        |    5 +++
 mm/util.c                         |   45 ++++++++++++++++++++++++++++
 mm/vmalloc.c                      |    9 ++++-
 security/apparmor/apparmorfs.c    |    2 -
 security/apparmor/include/lib.h   |   11 ------
 security/apparmor/lib.c           |   30 ------------------
 security/apparmor/match.c         |    2 -
 security/apparmor/policy_unpack.c |    2 -
 virt/kvm/kvm_main.c               |   18 +----------
 24 files changed, 103 insertions(+), 130 deletions(-)

diff -puN arch/x86/kvm/lapic.c~mm-introduce-kvalloc-helpers arch/x86/kvm/lapic.c
--- a/arch/x86/kvm/lapic.c~mm-introduce-kvalloc-helpers
+++ a/arch/x86/kvm/lapic.c
@@ -177,8 +177,8 @@ static void recalculate_apic_map(struct
 		if (kvm_apic_present(vcpu))
 			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
 
-	new = kvm_kvzalloc(sizeof(struct kvm_apic_map) +
-	                   sizeof(struct kvm_lapic *) * ((u64)max_id + 1));
+	new = kvzalloc(sizeof(struct kvm_apic_map) +
+	                   sizeof(struct kvm_lapic *) * ((u64)max_id + 1), GFP_KERNEL);
 
 	if (!new)
 		goto out;
diff -puN arch/x86/kvm/page_track.c~mm-introduce-kvalloc-helpers arch/x86/kvm/page_track.c
--- a/arch/x86/kvm/page_track.c~mm-introduce-kvalloc-helpers
+++ a/arch/x86/kvm/page_track.c
@@ -40,8 +40,8 @@ int kvm_page_track_create_memslot(struct
 	int  i;
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
-		slot->arch.gfn_track[i] = kvm_kvzalloc(npages *
-					    sizeof(*slot->arch.gfn_track[i]));
+		slot->arch.gfn_track[i] = kvzalloc(npages *
+					    sizeof(*slot->arch.gfn_track[i]), GFP_KERNEL);
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
 	}
diff -puN arch/x86/kvm/x86.c~mm-introduce-kvalloc-helpers arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~mm-introduce-kvalloc-helpers
+++ a/arch/x86/kvm/x86.c
@@ -8199,13 +8199,13 @@ int kvm_arch_create_memslot(struct kvm *
 				      slot->base_gfn, level) + 1;
 
 		slot->arch.rmap[i] =
-			kvm_kvzalloc(lpages * sizeof(*slot->arch.rmap[i]));
+			kvzalloc(lpages * sizeof(*slot->arch.rmap[i]), GFP_KERNEL);
 		if (!slot->arch.rmap[i])
 			goto out_free;
 		if (i == 0)
 			continue;
 
-		linfo = kvm_kvzalloc(lpages * sizeof(*linfo));
+		linfo = kvzalloc(lpages * sizeof(*linfo), GFP_KERNEL);
 		if (!linfo)
 			goto out_free;
 
diff -puN drivers/md/dm-stats.c~mm-introduce-kvalloc-helpers drivers/md/dm-stats.c
--- a/drivers/md/dm-stats.c~mm-introduce-kvalloc-helpers
+++ a/drivers/md/dm-stats.c
@@ -146,12 +146,7 @@ static void *dm_kvzalloc(size_t alloc_si
 	if (!claim_shared_memory(alloc_size))
 		return NULL;
 
-	if (alloc_size <= KMALLOC_MAX_SIZE) {
-		p = kzalloc_node(alloc_size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
-		if (p)
-			return p;
-	}
-	p = vzalloc_node(alloc_size, node);
+	p = kvzalloc_node(alloc_size, GFP_KERNEL | __GFP_NOMEMALLOC, node);
 	if (p)
 		return p;
 
diff -puN fs/ext4/mballoc.c~mm-introduce-kvalloc-helpers fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~mm-introduce-kvalloc-helpers
+++ a/fs/ext4/mballoc.c
@@ -2393,7 +2393,7 @@ int ext4_mb_alloc_groupinfo(struct super
 		return 0;
 
 	size = roundup_pow_of_two(sizeof(*sbi->s_group_info) * size);
-	new_groupinfo = ext4_kvzalloc(size, GFP_KERNEL);
+	new_groupinfo = kvzalloc(size, GFP_KERNEL);
 	if (!new_groupinfo) {
 		ext4_msg(sb, KERN_ERR, "can't allocate buddy meta group");
 		return -ENOMEM;
diff -puN fs/ext4/super.c~mm-introduce-kvalloc-helpers fs/ext4/super.c
--- a/fs/ext4/super.c~mm-introduce-kvalloc-helpers
+++ a/fs/ext4/super.c
@@ -2153,7 +2153,7 @@ int ext4_alloc_flex_bg_array(struct supe
 		return 0;
 
 	size = roundup_pow_of_two(size * sizeof(struct flex_groups));
-	new_groups = ext4_kvzalloc(size, GFP_KERNEL);
+	new_groups = kvzalloc(size, GFP_KERNEL);
 	if (!new_groups) {
 		ext4_msg(sb, KERN_ERR, "not enough memory for %d flex groups",
 			 size / (int) sizeof(struct flex_groups));
@@ -3887,7 +3887,7 @@ static int ext4_fill_super(struct super_
 			goto failed_mount;
 		}
 	}
-	sbi->s_group_desc = ext4_kvmalloc(db_count *
+	sbi->s_group_desc = kvmalloc(db_count *
 					  sizeof(struct buffer_head *),
 					  GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
diff -puN fs/f2fs/f2fs.h~mm-introduce-kvalloc-helpers fs/f2fs/f2fs.h
--- a/fs/f2fs/f2fs.h~mm-introduce-kvalloc-helpers
+++ a/fs/f2fs/f2fs.h
@@ -2005,26 +2005,6 @@ static inline void *f2fs_kmalloc(struct
 	return kmalloc(size, flags);
 }
 
-static inline void *f2fs_kvmalloc(size_t size, gfp_t flags)
-{
-	void *ret;
-
-	ret = kmalloc(size, flags | __GFP_NOWARN);
-	if (!ret)
-		ret = __vmalloc(size, flags, PAGE_KERNEL);
-	return ret;
-}
-
-static inline void *f2fs_kvzalloc(size_t size, gfp_t flags)
-{
-	void *ret;
-
-	ret = kzalloc(size, flags | __GFP_NOWARN);
-	if (!ret)
-		ret = __vmalloc(size, flags | __GFP_ZERO, PAGE_KERNEL);
-	return ret;
-}
-
 #define get_inode_mode(i) \
 	((is_inode_flag_set(i, FI_ACL_MODE)) ? \
 	 (F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
diff -puN fs/f2fs/file.c~mm-introduce-kvalloc-helpers fs/f2fs/file.c
--- a/fs/f2fs/file.c~mm-introduce-kvalloc-helpers
+++ a/fs/f2fs/file.c
@@ -1012,11 +1012,11 @@ static int __exchange_data_block(struct
 	while (len) {
 		olen = min((pgoff_t)4 * ADDRS_PER_BLOCK, len);
 
-		src_blkaddr = f2fs_kvzalloc(sizeof(block_t) * olen, GFP_KERNEL);
+		src_blkaddr = kvzalloc(sizeof(block_t) * olen, GFP_KERNEL);
 		if (!src_blkaddr)
 			return -ENOMEM;
 
-		do_replace = f2fs_kvzalloc(sizeof(int) * olen, GFP_KERNEL);
+		do_replace = kvzalloc(sizeof(int) * olen, GFP_KERNEL);
 		if (!do_replace) {
 			kvfree(src_blkaddr);
 			return -ENOMEM;
diff -puN fs/f2fs/node.c~mm-introduce-kvalloc-helpers fs/f2fs/node.c
--- a/fs/f2fs/node.c~mm-introduce-kvalloc-helpers
+++ a/fs/f2fs/node.c
@@ -2621,17 +2621,17 @@ static int init_free_nid_cache(struct f2
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	nm_i->free_nid_bitmap = f2fs_kvzalloc(nm_i->nat_blocks *
+	nm_i->free_nid_bitmap = kvzalloc(nm_i->nat_blocks *
 					NAT_ENTRY_BITMAP_SIZE, GFP_KERNEL);
 	if (!nm_i->free_nid_bitmap)
 		return -ENOMEM;
 
-	nm_i->nat_block_bitmap = f2fs_kvzalloc(nm_i->nat_blocks / 8,
+	nm_i->nat_block_bitmap = kvzalloc(nm_i->nat_blocks / 8,
 								GFP_KERNEL);
 	if (!nm_i->nat_block_bitmap)
 		return -ENOMEM;
 
-	nm_i->free_nid_count = f2fs_kvzalloc(nm_i->nat_blocks *
+	nm_i->free_nid_count = kvzalloc(nm_i->nat_blocks *
 					sizeof(unsigned short), GFP_KERNEL);
 	if (!nm_i->free_nid_count)
 		return -ENOMEM;
diff -puN fs/f2fs/segment.c~mm-introduce-kvalloc-helpers fs/f2fs/segment.c
--- a/fs/f2fs/segment.c~mm-introduce-kvalloc-helpers
+++ a/fs/f2fs/segment.c
@@ -2501,13 +2501,13 @@ static int build_sit_info(struct f2fs_sb
 
 	SM_I(sbi)->sit_info = sit_i;
 
-	sit_i->sentries = f2fs_kvzalloc(MAIN_SEGS(sbi) *
+	sit_i->sentries = kvzalloc(MAIN_SEGS(sbi) *
 					sizeof(struct seg_entry), GFP_KERNEL);
 	if (!sit_i->sentries)
 		return -ENOMEM;
 
 	bitmap_size = f2fs_bitmap_size(MAIN_SEGS(sbi));
-	sit_i->dirty_sentries_bitmap = f2fs_kvzalloc(bitmap_size, GFP_KERNEL);
+	sit_i->dirty_sentries_bitmap = kvzalloc(bitmap_size, GFP_KERNEL);
 	if (!sit_i->dirty_sentries_bitmap)
 		return -ENOMEM;
 
@@ -2540,7 +2540,7 @@ static int build_sit_info(struct f2fs_sb
 		return -ENOMEM;
 
 	if (sbi->segs_per_sec > 1) {
-		sit_i->sec_entries = f2fs_kvzalloc(MAIN_SECS(sbi) *
+		sit_i->sec_entries = kvzalloc(MAIN_SECS(sbi) *
 					sizeof(struct sec_entry), GFP_KERNEL);
 		if (!sit_i->sec_entries)
 			return -ENOMEM;
@@ -2591,12 +2591,12 @@ static int build_free_segmap(struct f2fs
 	SM_I(sbi)->free_info = free_i;
 
 	bitmap_size = f2fs_bitmap_size(MAIN_SEGS(sbi));
-	free_i->free_segmap = f2fs_kvmalloc(bitmap_size, GFP_KERNEL);
+	free_i->free_segmap = kvmalloc(bitmap_size, GFP_KERNEL);
 	if (!free_i->free_segmap)
 		return -ENOMEM;
 
 	sec_bitmap_size = f2fs_bitmap_size(MAIN_SECS(sbi));
-	free_i->free_secmap = f2fs_kvmalloc(sec_bitmap_size, GFP_KERNEL);
+	free_i->free_secmap = kvmalloc(sec_bitmap_size, GFP_KERNEL);
 	if (!free_i->free_secmap)
 		return -ENOMEM;
 
@@ -2764,7 +2764,7 @@ static int init_victim_secmap(struct f2f
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	unsigned int bitmap_size = f2fs_bitmap_size(MAIN_SECS(sbi));
 
-	dirty_i->victim_secmap = f2fs_kvzalloc(bitmap_size, GFP_KERNEL);
+	dirty_i->victim_secmap = kvzalloc(bitmap_size, GFP_KERNEL);
 	if (!dirty_i->victim_secmap)
 		return -ENOMEM;
 	return 0;
@@ -2786,7 +2786,7 @@ static int build_dirty_segmap(struct f2f
 	bitmap_size = f2fs_bitmap_size(MAIN_SEGS(sbi));
 
 	for (i = 0; i < NR_DIRTY_TYPE; i++) {
-		dirty_i->dirty_segmap[i] = f2fs_kvzalloc(bitmap_size, GFP_KERNEL);
+		dirty_i->dirty_segmap[i] = kvzalloc(bitmap_size, GFP_KERNEL);
 		if (!dirty_i->dirty_segmap[i])
 			return -ENOMEM;
 	}
diff -puN fs/seq_file.c~mm-introduce-kvalloc-helpers fs/seq_file.c
--- a/fs/seq_file.c~mm-introduce-kvalloc-helpers
+++ a/fs/seq_file.c
@@ -25,21 +25,7 @@ static void seq_set_overflow(struct seq_
 
 static void *seq_buf_alloc(unsigned long size)
 {
-	void *buf;
-	gfp_t gfp = GFP_KERNEL;
-
-	/*
-	 * For high order allocations, use __GFP_NORETRY to avoid oom-killing -
-	 * it's better to fall back to vmalloc() than to kill things.  For small
-	 * allocations, just use GFP_KERNEL which will oom kill, thus no need
-	 * for vmalloc fallback.
-	 */
-	if (size > PAGE_SIZE)
-		gfp |= __GFP_NORETRY | __GFP_NOWARN;
-	buf = kmalloc(size, gfp);
-	if (!buf && size > PAGE_SIZE)
-		buf = vmalloc(size);
-	return buf;
+	return kvmalloc(size, GFP_KERNEL);
 }
 
 /**
diff -puN include/linux/kvm_host.h~mm-introduce-kvalloc-helpers include/linux/kvm_host.h
--- a/include/linux/kvm_host.h~mm-introduce-kvalloc-helpers
+++ a/include/linux/kvm_host.h
@@ -767,8 +767,6 @@ void kvm_arch_check_processor_compat(voi
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 
-void *kvm_kvzalloc(unsigned long size);
-
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
diff -puN include/linux/mm.h~mm-introduce-kvalloc-helpers include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-kvalloc-helpers
+++ a/include/linux/mm.h
@@ -518,6 +518,20 @@ static inline int is_vmalloc_or_module_a
 }
 #endif
 
+extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
+static inline void *kvmalloc(size_t size, gfp_t flags)
+{
+	return kvmalloc_node(size, flags, NUMA_NO_NODE);
+}
+static inline void *kvzalloc_node(size_t size, gfp_t flags, int node)
+{
+	return kvmalloc_node(size, flags | __GFP_ZERO, node);
+}
+static inline void *kvzalloc(size_t size, gfp_t flags)
+{
+	return kvmalloc(size, flags | __GFP_ZERO);
+}
+
 extern void kvfree(const void *addr);
 
 static inline atomic_t *compound_mapcount_ptr(struct page *page)
diff -puN include/linux/vmalloc.h~mm-introduce-kvalloc-helpers include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-introduce-kvalloc-helpers
+++ a/include/linux/vmalloc.h
@@ -80,6 +80,7 @@ extern void *__vmalloc_node_range(unsign
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
 			const void *caller);
+extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
diff -puN ipc/util.c~mm-introduce-kvalloc-helpers ipc/util.c
--- a/ipc/util.c~mm-introduce-kvalloc-helpers
+++ a/ipc/util.c
@@ -403,12 +403,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
  */
 void *ipc_alloc(int size)
 {
-	void *out;
-	if (size > PAGE_SIZE)
-		out = vmalloc(size);
-	else
-		out = kmalloc(size, GFP_KERNEL);
-	return out;
+	return kvmalloc(size, GFP_KERNEL);
 }
 
 /**
diff -puN mm/nommu.c~mm-introduce-kvalloc-helpers mm/nommu.c
--- a/mm/nommu.c~mm-introduce-kvalloc-helpers
+++ a/mm/nommu.c
@@ -237,6 +237,11 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
+void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
+{
+	return __vmalloc(size, flags, PAGE_KERNEL);
+}
+
 void *vmalloc_user(unsigned long size)
 {
 	void *ret;
diff -puN mm/util.c~mm-introduce-kvalloc-helpers mm/util.c
--- a/mm/util.c~mm-introduce-kvalloc-helpers
+++ a/mm/util.c
@@ -329,6 +329,51 @@ unsigned long vm_mmap(struct file *file,
 }
 EXPORT_SYMBOL(vm_mmap);
 
+/**
+ * kvmalloc_node - attempt to allocate physically contiguous memory, but upon
+ * failure, fall back to non-contiguous (vmalloc) allocation.
+ * @size: size of the request.
+ * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
+ * @node: numa node to allocate from
+ *
+ * Uses kmalloc to get the memory but if the allocation fails then falls back
+ * to the vmalloc allocator. Use kvfree for freeing the memory.
+ *
+ * Reclaim modifiers - __GFP_NORETRY, __GFP_REPEAT and __GFP_NOFAIL are not supported
+ *
+ * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
+ */
+void *kvmalloc_node(size_t size, gfp_t flags, int node)
+{
+	gfp_t kmalloc_flags = flags;
+	void *ret;
+
+	/*
+	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
+	 * so the given set of flags has to be compatible.
+	 */
+	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
+
+	/*
+	 * Make sure that larger requests are not too disruptive - no OOM
+	 * killer and no allocation failure warnings as we have a fallback
+	 */
+	if (size > PAGE_SIZE)
+		kmalloc_flags |= __GFP_NORETRY | __GFP_NOWARN;
+
+	ret = kmalloc_node(size, kmalloc_flags, node);
+
+	/*
+	 * It doesn't really make sense to fallback to vmalloc for sub page
+	 * requests
+	 */
+	if (ret || size <= PAGE_SIZE)
+		return ret;
+
+	return __vmalloc_node_flags(size, node, flags | __GFP_HIGHMEM);
+}
+EXPORT_SYMBOL(kvmalloc_node);
+
 void kvfree(const void *addr)
 {
 	if (is_vmalloc_addr(addr))
diff -puN mm/vmalloc.c~mm-introduce-kvalloc-helpers mm/vmalloc.c
--- a/mm/vmalloc.c~mm-introduce-kvalloc-helpers
+++ a/mm/vmalloc.c
@@ -1786,6 +1786,13 @@ fail:
  *	Allocate enough pages to cover @size from the page level
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
+ *
+ *	Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_REPEAT
+ *	and __GFP_NOFAIL are not supported
+ *
+ *	Any use of gfp flags outside of GFP_KERNEL should be consulted
+ *	with mm people.
+ *
  */
 static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
@@ -1802,7 +1809,7 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
-static inline void *__vmalloc_node_flags(unsigned long size,
+void *__vmalloc_node_flags(unsigned long size,
 					int node, gfp_t flags)
 {
 	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
diff -puN security/apparmor/apparmorfs.c~mm-introduce-kvalloc-helpers security/apparmor/apparmorfs.c
--- a/security/apparmor/apparmorfs.c~mm-introduce-kvalloc-helpers
+++ a/security/apparmor/apparmorfs.c
@@ -98,7 +98,7 @@ static struct aa_loaddata *aa_simple_wri
 		return ERR_PTR(-ESPIPE);
 
 	/* freed by caller to simple_write_to_buffer */
-	data = kvmalloc(sizeof(*data) + alloc_size);
+	data = kvmalloc(sizeof(*data) + alloc_size, GFP_KERNEL);
 	if (data == NULL)
 		return ERR_PTR(-ENOMEM);
 	kref_init(&data->count);
diff -puN security/apparmor/include/lib.h~mm-introduce-kvalloc-helpers security/apparmor/include/lib.h
--- a/security/apparmor/include/lib.h~mm-introduce-kvalloc-helpers
+++ a/security/apparmor/include/lib.h
@@ -64,17 +64,6 @@ char *aa_split_fqname(char *args, char *
 const char *aa_splitn_fqname(const char *fqname, size_t n, const char **ns_name,
 			     size_t *ns_len);
 void aa_info_message(const char *str);
-void *__aa_kvmalloc(size_t size, gfp_t flags);
-
-static inline void *kvmalloc(size_t size)
-{
-	return __aa_kvmalloc(size, 0);
-}
-
-static inline void *kvzalloc(size_t size)
-{
-	return __aa_kvmalloc(size, __GFP_ZERO);
-}
 
 /**
  * aa_strneq - compare null terminated @str to a non null terminated substring
diff -puN security/apparmor/lib.c~mm-introduce-kvalloc-helpers security/apparmor/lib.c
--- a/security/apparmor/lib.c~mm-introduce-kvalloc-helpers
+++ a/security/apparmor/lib.c
@@ -129,36 +129,6 @@ void aa_info_message(const char *str)
 }
 
 /**
- * __aa_kvmalloc - do allocation preferring kmalloc but falling back to vmalloc
- * @size: how many bytes of memory are required
- * @flags: the type of memory to allocate (see kmalloc).
- *
- * Return: allocated buffer or NULL if failed
- *
- * It is possible that policy being loaded from the user is larger than
- * what can be allocated by kmalloc, in those cases fall back to vmalloc.
- */
-void *__aa_kvmalloc(size_t size, gfp_t flags)
-{
-	void *buffer = NULL;
-
-	if (size == 0)
-		return NULL;
-
-	/* do not attempt kmalloc if we need more than 16 pages at once */
-	if (size <= (16*PAGE_SIZE))
-		buffer = kmalloc(size, flags | GFP_KERNEL | __GFP_NORETRY |
-				 __GFP_NOWARN);
-	if (!buffer) {
-		if (flags & __GFP_ZERO)
-			buffer = vzalloc(size);
-		else
-			buffer = vmalloc(size);
-	}
-	return buffer;
-}
-
-/**
  * aa_policy_init - initialize a policy structure
  * @policy: policy to initialize  (NOT NULL)
  * @prefix: prefix name if any is required.  (MAYBE NULL)
diff -puN security/apparmor/match.c~mm-introduce-kvalloc-helpers security/apparmor/match.c
--- a/security/apparmor/match.c~mm-introduce-kvalloc-helpers
+++ a/security/apparmor/match.c
@@ -88,7 +88,7 @@ static struct table_header *unpack_table
 	if (bsize < tsize)
 		goto out;
 
-	table = kvzalloc(tsize);
+	table = kvzalloc(tsize, GFP_KERNEL);
 	if (table) {
 		table->td_id = th.td_id;
 		table->td_flags = th.td_flags;
diff -puN security/apparmor/policy_unpack.c~mm-introduce-kvalloc-helpers security/apparmor/policy_unpack.c
--- a/security/apparmor/policy_unpack.c~mm-introduce-kvalloc-helpers
+++ a/security/apparmor/policy_unpack.c
@@ -487,7 +487,7 @@ fail:
 
 static void *kvmemdup(const void *src, size_t len)
 {
-	void *p = kvmalloc(len);
+	void *p = kvmalloc(len, GFP_KERNEL);
 
 	if (p)
 		memcpy(p, src, len);
diff -puN virt/kvm/kvm_main.c~mm-introduce-kvalloc-helpers virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mm-introduce-kvalloc-helpers
+++ a/virt/kvm/kvm_main.c
@@ -504,7 +504,7 @@ static struct kvm_memslots *kvm_alloc_me
 	int i;
 	struct kvm_memslots *slots;
 
-	slots = kvm_kvzalloc(sizeof(struct kvm_memslots));
+	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!slots)
 		return NULL;
 
@@ -689,18 +689,6 @@ out_err_no_disable:
 	return ERR_PTR(r);
 }
 
-/*
- * Avoid using vmalloc for a small buffer.
- * Should not be used when the size is statically known.
- */
-void *kvm_kvzalloc(unsigned long size)
-{
-	if (size > PAGE_SIZE)
-		return vzalloc(size);
-	else
-		return kzalloc(size, GFP_KERNEL);
-}

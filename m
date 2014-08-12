From: akpm@linux-foundation.org
Subject: [merged] mm-allow-drivers-to-prevent-new-writable-mappings.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:29 -0700
Message-ID: <53ea6e61.Z86usRn4szzMYUDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:50172 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbaHLTna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:30 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so472438qcz.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh.herrmann@gmail.com, desrt@desrt.ca, hughd@google.com, lennart@poettering.net, luto@amacapital.net, mtk.manpages@gmail.com, zonque@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow drivers to prevent new writable mappings
has been removed from the -mm tree.  Its filename was
     mm-allow-drivers-to-prevent-new-writable-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Herrmann <dh.herrmann@gmail.com>
Subject: mm: allow drivers to prevent new writable mappings

This patch (of 6):

The i_mmap_writable field counts existing writable mappings of an
address_space.  To allow drivers to prevent new writable mappings, make
this counter signed and prevent new writable mappings if it is negative. 
This is modelled after i_writecount and DENYWRITE.

This will be required by the shmem-sealing infrastructure to prevent any
new writable mappings after the WRITE seal has been set.  In case there
exists a writable mapping, this operation will fail with EBUSY.

Note that we rely on the fact that iff you already own a writable mapping,
you can increase the counter without using the helpers.  This is the same
that we do for i_writecount.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ryan Lortie <desrt@desrt.ca>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |    1 +
 include/linux/fs.h |   29 +++++++++++++++++++++++++++--
 kernel/fork.c      |    2 +-
 mm/mmap.c          |   30 ++++++++++++++++++++++++------
 mm/swap_state.c    |    1 +
 5 files changed, 54 insertions(+), 9 deletions(-)

diff -puN fs/inode.c~mm-allow-drivers-to-prevent-new-writable-mappings fs/inode.c
--- a/fs/inode.c~mm-allow-drivers-to-prevent-new-writable-mappings
+++ a/fs/inode.c
@@ -165,6 +165,7 @@ int inode_init_always(struct super_block
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
 	mapping->flags = 0;
+	atomic_set(&mapping->i_mmap_writable, 0);
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->private_data = NULL;
 	mapping->backing_dev_info = &default_backing_dev_info;
diff -puN include/linux/fs.h~mm-allow-drivers-to-prevent-new-writable-mappings include/linux/fs.h
--- a/include/linux/fs.h~mm-allow-drivers-to-prevent-new-writable-mappings
+++ a/include/linux/fs.h
@@ -387,7 +387,7 @@ struct address_space {
 	struct inode		*host;		/* owner: inode, block_device */
 	struct radix_tree_root	page_tree;	/* radix tree of all pages */
 	spinlock_t		tree_lock;	/* and lock protecting it */
-	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
+	atomic_t		i_mmap_writable;/* count VM_SHARED mappings */
 	struct rb_root		i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
 	struct mutex		i_mmap_mutex;	/* protect tree, count, list */
@@ -470,10 +470,35 @@ static inline int mapping_mapped(struct
  * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap_pgoff
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
+ *
+ * If i_mmap_writable is negative, no new writable mappings are allowed. You
+ * can only deny writable mappings, if none exists right now.
  */
 static inline int mapping_writably_mapped(struct address_space *mapping)
 {
-	return mapping->i_mmap_writable != 0;
+	return atomic_read(&mapping->i_mmap_writable) > 0;
+}
+
+static inline int mapping_map_writable(struct address_space *mapping)
+{
+	return atomic_inc_unless_negative(&mapping->i_mmap_writable) ?
+		0 : -EPERM;
+}
+
+static inline void mapping_unmap_writable(struct address_space *mapping)
+{
+	atomic_dec(&mapping->i_mmap_writable);
+}
+
+static inline int mapping_deny_writable(struct address_space *mapping)
+{
+	return atomic_dec_unless_positive(&mapping->i_mmap_writable) ?
+		0 : -EBUSY;
+}
+
+static inline void mapping_allow_writable(struct address_space *mapping)
+{
+	atomic_inc(&mapping->i_mmap_writable);
 }
 
 /*
diff -puN kernel/fork.c~mm-allow-drivers-to-prevent-new-writable-mappings kernel/fork.c
--- a/kernel/fork.c~mm-allow-drivers-to-prevent-new-writable-mappings
+++ a/kernel/fork.c
@@ -429,7 +429,7 @@ static int dup_mmap(struct mm_struct *mm
 				atomic_dec(&inode->i_writecount);
 			mutex_lock(&mapping->i_mmap_mutex);
 			if (tmp->vm_flags & VM_SHARED)
-				mapping->i_mmap_writable++;
+				atomic_inc(&mapping->i_mmap_writable);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			if (unlikely(tmp->vm_flags & VM_NONLINEAR))
diff -puN mm/mmap.c~mm-allow-drivers-to-prevent-new-writable-mappings mm/mmap.c
--- a/mm/mmap.c~mm-allow-drivers-to-prevent-new-writable-mappings
+++ a/mm/mmap.c
@@ -221,7 +221,7 @@ static void __remove_shared_vm_struct(st
 	if (vma->vm_flags & VM_DENYWRITE)
 		atomic_inc(&file_inode(file)->i_writecount);
 	if (vma->vm_flags & VM_SHARED)
-		mapping->i_mmap_writable--;
+		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
 	if (unlikely(vma->vm_flags & VM_NONLINEAR))
@@ -622,7 +622,7 @@ static void __vma_link_file(struct vm_ar
 		if (vma->vm_flags & VM_DENYWRITE)
 			atomic_dec(&file_inode(file)->i_writecount);
 		if (vma->vm_flags & VM_SHARED)
-			mapping->i_mmap_writable++;
+			atomic_inc(&mapping->i_mmap_writable);
 
 		flush_dcache_mmap_lock(mapping);
 		if (unlikely(vma->vm_flags & VM_NONLINEAR))
@@ -1577,6 +1577,17 @@ munmap_back:
 			if (error)
 				goto free_vma;
 		}
+		if (vm_flags & VM_SHARED) {
+			error = mapping_map_writable(file->f_mapping);
+			if (error)
+				goto allow_write_and_free_vma;
+		}
+
+		/* ->mmap() can change vma->vm_file, but must guarantee that
+		 * vma_link() below can deny write-access if VM_DENYWRITE is set
+		 * and map writably if VM_SHARED is set. This usually means the
+		 * new file must not have been exposed to user-space, yet.
+		 */
 		vma->vm_file = get_file(file);
 		error = file->f_op->mmap(file, vma);
 		if (error)
@@ -1616,8 +1627,12 @@ munmap_back:
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
-	if (vm_flags & VM_DENYWRITE)
-		allow_write_access(file);
+	if (file) {
+		if (vm_flags & VM_SHARED)
+			mapping_unmap_writable(file->f_mapping);
+		if (vm_flags & VM_DENYWRITE)
+			allow_write_access(file);
+	}
 	file = vma->vm_file;
 out:
 	perf_event_mmap(vma);
@@ -1646,14 +1661,17 @@ out:
 	return addr;
 
 unmap_and_free_vma:
-	if (vm_flags & VM_DENYWRITE)
-		allow_write_access(file);
 	vma->vm_file = NULL;
 	fput(file);
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
 	charged = 0;
+	if (vm_flags & VM_SHARED)
+		mapping_unmap_writable(file->f_mapping);
+allow_write_and_free_vma:
+	if (vm_flags & VM_DENYWRITE)
+		allow_write_access(file);
 free_vma:
 	kmem_cache_free(vm_area_cachep, vma);
 unacct_error:
diff -puN mm/swap_state.c~mm-allow-drivers-to-prevent-new-writable-mappings mm/swap_state.c
--- a/mm/swap_state.c~mm-allow-drivers-to-prevent-new-writable-mappings
+++ a/mm/swap_state.c
@@ -39,6 +39,7 @@ static struct backing_dev_info swap_back
 struct address_space swapper_spaces[MAX_SWAPFILES] = {
 	[0 ... MAX_SWAPFILES - 1] = {
 		.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
+		.i_mmap_writable = ATOMIC_INIT(0),
 		.a_ops		= &swap_aops,
 		.backing_dev_info = &swap_backing_dev_info,
 	}
_

Patches currently in -mm which might be from dh.herrmann@gmail.com are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch


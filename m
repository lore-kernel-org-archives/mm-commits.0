From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:31 -0800
Message-ID: <58af50b7.TQ40Di1HAMaIfOKS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support

shmem_mcopy_atomic_pte is the low level routine that implements the
userfaultfd UFFDIO_COPY command.  It is based on the existing
mcopy_atomic_pte routine with modifications for shared memory pages.

Link: http://lkml.kernel.org/r/20161216144821.5183-29-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   11 +++
 mm/shmem.c               |  110 +++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

diff -puN include/linux/shmem_fs.h~userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support
+++ a/include/linux/shmem_fs.h
@@ -124,4 +124,15 @@ static inline bool shmem_huge_enabled(st
 }
 #endif
 
+#ifdef CONFIG_SHMEM
+extern int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+				  struct vm_area_struct *dst_vma,
+				  unsigned long dst_addr,
+				  unsigned long src_addr,
+				  struct page **pagep);
+#else
+#define shmem_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
+			       src_addr, pagep)        ({ BUG(); 0; })
+#endif
+
 #endif
diff -puN mm/shmem.c~userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support
+++ a/mm/shmem.c
@@ -70,6 +70,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
 #include <uapi/linux/memfd.h>
+#include <linux/rmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
@@ -2178,6 +2179,115 @@ bool shmem_mapping(struct address_space
 	return mapping->a_ops == &shmem_aops;
 }
 
+int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm,
+			   pmd_t *dst_pmd,
+			   struct vm_area_struct *dst_vma,
+			   unsigned long dst_addr,
+			   unsigned long src_addr,
+			   struct page **pagep)
+{
+	struct inode *inode = file_inode(dst_vma->vm_file);
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct address_space *mapping = inode->i_mapping;
+	gfp_t gfp = mapping_gfp_mask(mapping);
+	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
+	struct mem_cgroup *memcg;
+	spinlock_t *ptl;
+	void *page_kaddr;
+	struct page *page;
+	pte_t _dst_pte, *dst_pte;
+	int ret;
+
+	if (!*pagep) {
+		ret = -ENOMEM;
+		if (shmem_acct_block(info->flags, 1))
+			goto out;
+		if (sbinfo->max_blocks) {
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						   sbinfo->max_blocks) >= 0)
+				goto out_unacct_blocks;
+			percpu_counter_inc(&sbinfo->used_blocks);
+		}
+
+		page = shmem_alloc_page(gfp, info, pgoff);
+		if (!page)
+			goto out_dec_used_blocks;
+
+		page_kaddr = kmap_atomic(page);
+		ret = copy_from_user(page_kaddr, (const void __user *)src_addr,
+				     PAGE_SIZE);
+		kunmap_atomic(page_kaddr);
+
+		/* fallback to copy_from_user outside mmap_sem */
+		if (unlikely(ret)) {
+			*pagep = page;
+			/* don't free the page */
+			return -EFAULT;
+		}
+	} else {
+		page = *pagep;
+		*pagep = NULL;
+	}
+
+	ret = mem_cgroup_try_charge(page, dst_mm, gfp, &memcg, false);
+	if (ret)
+		goto out_release;
+
+	ret = radix_tree_maybe_preload(gfp & GFP_RECLAIM_MASK);
+	if (!ret) {
+		ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL);
+		radix_tree_preload_end();
+	}
+	if (ret)
+		goto out_release_uncharge;
+
+	mem_cgroup_commit_charge(page, memcg, false, false);
+
+	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
+	if (dst_vma->vm_flags & VM_WRITE)
+		_dst_pte = pte_mkwrite(pte_mkdirty(_dst_pte));
+
+	ret = -EEXIST;
+	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+	if (!pte_none(*dst_pte))
+		goto out_release_uncharge_unlock;
+
+	__SetPageUptodate(page);
+
+	lru_cache_add_anon(page);
+
+	spin_lock(&info->lock);
+	info->alloced++;
+	inode->i_blocks += BLOCKS_PER_PAGE;
+	shmem_recalc_inode(inode);
+	spin_unlock(&info->lock);
+
+	inc_mm_counter(dst_mm, mm_counter_file(page));
+	page_add_file_rmap(page, false);
+	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(dst_vma, dst_addr, dst_pte);
+	unlock_page(page);
+	pte_unmap_unlock(dst_pte, ptl);
+	ret = 0;
+out:
+	return ret;
+out_release_uncharge_unlock:
+	pte_unmap_unlock(dst_pte, ptl);
+out_release_uncharge:
+	mem_cgroup_cancel_charge(page, memcg, false);
+out_release:
+	put_page(page);
+out_dec_used_blocks:
+	if (sbinfo->max_blocks)
+		percpu_counter_add(&sbinfo->used_blocks, -1);
+out_unacct_blocks:
+	shmem_unacct_blocks(info->flags, 1);
+	goto out;
+}
+
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch
userfaultfd-documentation-update.patch


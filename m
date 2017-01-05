From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
 added to -mm tree
Date: Wed, 04 Jan 2017 16:54:18 -0800
Message-ID: <586d993a.wPGfDWX8VsYRqibO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937494AbdAEAyY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2171,6 +2172,115 @@ bool shmem_mapping(struct address_space
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

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch


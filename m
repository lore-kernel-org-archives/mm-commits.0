From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?userfaultfd-hugetlbfs-prevent-uffdio=5Fcopy-to-fill-beyond?=
 =?US-ASCII?Q?-the-end-of-i=5Fsize.patch?= removed from -mm tree
Date: Fri, 03 Nov 2017 11:53:52 -0700
Message-ID: <20171103185352.y_e_m-O5g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54070 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933020AbdKCSxy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 14:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: prevent UFFDIO_COPY to fill beyond the end of i_size
has been removed from the -mm tree.  Its filename was
     userfaultfd-hugetlbfs-prevent-uffdio_copy-to-fill-beyond-the-end-of-i_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: hugetlbfs: prevent UFFDIO_COPY to fill beyond the end of i_size

kernel BUG at fs/hugetlbfs/inode.c:484!
RIP: 0010:[<ffffffff815f8520>]  [<ffffffff815f8520>] remove_inode_hugepages+0x3d0/0x410
Call Trace:
 [<ffffffff815f95b9>] hugetlbfs_setattr+0xd9/0x130
 [<ffffffff81526312>] notify_change+0x292/0x410
 [<ffffffff816cc6b6>] ? security_inode_need_killpriv+0x16/0x20
 [<ffffffff81503c65>] do_truncate+0x65/0xa0
 [<ffffffff81504035>] ? do_sys_ftruncate.constprop.3+0xe5/0x180
 [<ffffffff8150406a>] do_sys_ftruncate.constprop.3+0x11a/0x180
 [<ffffffff8150410e>] SyS_ftruncate+0xe/0x10
 [<ffffffff81999f27>] tracesys+0xd9/0xde

This oops was caused by the lack of i_size check in
hugetlb_mcopy_atomic_pte.  mmap() can still succeed beyond the end of the
i_size after vmtruncate zapped vmas in those ranges, but the faults must
not succeed, and that includes UFFDIO_COPY.

We could differentiate the retval to userland to represent a SIGBUS like a
page fault would do (vs SIGSEGV), but it doesn't seem very useful and we'd
need to pick a random retval as there's no meaningful syscall retval that
would differentiate from SIGSEGV and SIGBUS, there's just -EFAULT.

Link: http://lkml.kernel.org/r/20171016223914.2421-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-prevent-uffdio_copy-to-fill-beyond-the-end-of-i_size mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-prevent-uffdio_copy-to-fill-beyond-the-end-of-i_size
+++ a/mm/hugetlb.c
@@ -3984,6 +3984,9 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			    unsigned long src_addr,
 			    struct page **pagep)
 {
+	struct address_space *mapping;
+	pgoff_t idx;
+	unsigned long size;
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	struct hstate *h = hstate_vma(dst_vma);
 	pte_t _dst_pte;
@@ -4021,13 +4024,24 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	__SetPageUptodate(page);
 	set_page_huge_active(page);
 
+	mapping = dst_vma->vm_file->f_mapping;
+	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
+
 	/*
 	 * If shared, add to page cache
 	 */
 	if (vm_shared) {
-		struct address_space *mapping = dst_vma->vm_file->f_mapping;
-		pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
+		size = i_size_read(mapping->host) >> huge_page_shift(h);
+		ret = -EFAULT;
+		if (idx >= size)
+			goto out_release_nounlock;
 
+		/*
+		 * Serialization between remove_inode_hugepages() and
+		 * huge_add_to_page_cache() below happens through the
+		 * hugetlb_fault_mutex_table that here must be hold by
+		 * the caller.
+		 */
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
@@ -4036,6 +4050,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
 	spin_lock(ptl);
 
+	/*
+	 * Recheck the i_size after holding PT lock to make sure not
+	 * to leave any page mapped (as page_mapped()) beyond the end
+	 * of the i_size (remove_inode_hugepages() is strict about
+	 * enforcing that). If we bail out here, we'll also leave a
+	 * page in the radix tree in the vm_shared case beyond the end
+	 * of the i_size, but remove_inode_hugepages() will take care
+	 * of it as soon as we drop the hugetlb_fault_mutex_table.
+	 */
+	size = i_size_read(mapping->host) >> huge_page_shift(h);
+	ret = -EFAULT;
+	if (idx >= size)
+		goto out_release_unlock;
+
 	ret = -EEXIST;
 	if (!huge_pte_none(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
_

Patches currently in -mm which might be from aarcange@redhat.com are



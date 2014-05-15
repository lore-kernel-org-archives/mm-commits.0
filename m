From: akpm@linux-foundation.org
Subject: + mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch
 added to -mm tree
Date: Thu, 15 May 2014 15:57:27 -0700
Message-ID: <53754657.8WbOhqwUv5UWtu/V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaEOW52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 18:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, hughd@google.com, sasha.levin@oracle.com

Subject: + mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch added to -mm tree
To: sasha.levin@oracle.com,hughd@google.com,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 15:57:27 -0700


The patch titled
     Subject: mm: remap_file_pages: grab file ref to prevent race while mmaping
has been added to the -mm tree.  Its filename is
     mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: remap_file_pages: grab file ref to prevent race while mmaping

A file reference should be held while a file is mmaped, otherwise it might
be freed while being used.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix-3 mm/mmap.c
--- a/mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix-3
+++ a/mm/mmap.c
@@ -2593,6 +2593,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	struct vm_area_struct *vma;
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
+	struct file *file;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
@@ -2636,8 +2637,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		munlock_vma_pages_range(vma, start, start + size);
 	}
 
+	file = get_file(vma->vm_file);
 	ret = do_mmap_pgoff(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate);
+	fput(file);
 out:
 	up_write(&mm->mmap_sem);
 	if (populate)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kexec-save-pg_head_mask-in-vmcoreinfo.patch
linux-next.patch
x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch


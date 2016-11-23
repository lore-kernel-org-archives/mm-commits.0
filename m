From: akpm@linux-foundation.org
Subject: +
 mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch
 added to -mm tree
Date: Tue, 22 Nov 2016 16:15:04 -0800
Message-ID: <5834df88.Oj/gj6a9ya73x7pv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbcKWAPE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use pgoff in struct vm_fault instead of passing it separately
has been added to the -mm tree.  Its filename is
     mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: use pgoff in struct vm_fault instead of passing it separately

struct vm_fault has already pgoff entry.  Use it instead of passing pgoff
as a separate argument and then assigning it later.

Link: http://lkml.kernel.org/r/1479460644-25076-4-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 mm/memory.c     |   35 ++++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff -puN mm/khugepaged.c~mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately mm/khugepaged.c
--- a/mm/khugepaged.c~mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately
+++ a/mm/khugepaged.c
@@ -882,6 +882,7 @@ static bool __collapse_huge_page_swapin(
 		.address = address,
 		.flags = FAULT_FLAG_ALLOW_RETRY,
 		.pmd = pmd,
+		.pgoff = linear_page_index(vma, address),
 	};
 
 	/* we only decide to swapin, if there is enough young ptes */
diff -puN mm/memory.c~mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately mm/memory.c
--- a/mm/memory.c~mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately
+++ a/mm/memory.c
@@ -2275,7 +2275,7 @@ static int wp_pfn_shared(struct vm_fault
 	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
 		struct vm_fault vmf2 = {
 			.page = NULL,
-			.pgoff = linear_page_index(vma, vmf->address),
+			.pgoff = vmf->pgoff,
 			.address = vmf->address,
 			.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE,
 		};
@@ -2844,15 +2844,15 @@ oom:
  * released depending on flags and vma->vm_ops->fault() return value.
  * See filemap_fault() and __lock_page_retry().
  */
-static int __do_fault(struct vm_fault *vmf, pgoff_t pgoff,
-		struct page *cow_page, struct page **page, void **entry)
+static int __do_fault(struct vm_fault *vmf, struct page *cow_page,
+		      struct page **page, void **entry)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vm_fault vmf2;
 	int ret;
 
 	vmf2.address = vmf->address;
-	vmf2.pgoff = pgoff;
+	vmf2.pgoff = vmf->pgoff;
 	vmf2.flags = vmf->flags;
 	vmf2.page = NULL;
 	vmf2.gfp_mask = __get_fault_gfp_mask(vma);
@@ -3156,9 +3156,10 @@ late_initcall(fault_around_debugfs);
  * fault_around_pages() value (and therefore to page order).  This way it's
  * easier to guarantee that we don't cross page table boundaries.
  */
-static int do_fault_around(struct vm_fault *vmf, pgoff_t start_pgoff)
+static int do_fault_around(struct vm_fault *vmf)
 {
 	unsigned long address = vmf->address, nr_pages, mask;
+	pgoff_t start_pgoff = vmf->pgoff;
 	pgoff_t end_pgoff;
 	int off, ret = 0;
 
@@ -3210,7 +3211,7 @@ out:
 	return ret;
 }
 
-static int do_read_fault(struct vm_fault *vmf, pgoff_t pgoff)
+static int do_read_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page;
@@ -3222,12 +3223,12 @@ static int do_read_fault(struct vm_fault
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		ret = do_fault_around(vmf, pgoff);
+		ret = do_fault_around(vmf);
 		if (ret)
 			return ret;
 	}
 
-	ret = __do_fault(vmf, pgoff, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3240,7 +3241,7 @@ static int do_read_fault(struct vm_fault
 	return ret;
 }
 
-static int do_cow_fault(struct vm_fault *vmf, pgoff_t pgoff)
+static int do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page, *new_page;
@@ -3261,7 +3262,7 @@ static int do_cow_fault(struct vm_fault
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vmf, pgoff, new_page, &fault_page, &fault_entry);
+	ret = __do_fault(vmf, new_page, &fault_page, &fault_entry);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
@@ -3276,7 +3277,7 @@ static int do_cow_fault(struct vm_fault
 		unlock_page(fault_page);
 		put_page(fault_page);
 	} else {
-		dax_unlock_mapping_entry(vma->vm_file->f_mapping, pgoff);
+		dax_unlock_mapping_entry(vma->vm_file->f_mapping, vmf->pgoff);
 	}
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
@@ -3287,7 +3288,7 @@ uncharge_out:
 	return ret;
 }
 
-static int do_shared_fault(struct vm_fault *vmf, pgoff_t pgoff)
+static int do_shared_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page;
@@ -3295,7 +3296,7 @@ static int do_shared_fault(struct vm_fau
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vmf, pgoff, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3356,16 +3357,15 @@ static int do_shared_fault(struct vm_fau
 static int do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	pgoff_t pgoff = linear_page_index(vma, vmf->address);
 
 	/* The VMA was not fully populated on mmap() or missing VM_DONTEXPAND */
 	if (!vma->vm_ops->fault)
 		return VM_FAULT_SIGBUS;
 	if (!(vmf->flags & FAULT_FLAG_WRITE))
-		return do_read_fault(vmf, pgoff);
+		return do_read_fault(vmf);
 	if (!(vma->vm_flags & VM_SHARED))
-		return do_cow_fault(vmf, pgoff);
-	return do_shared_fault(vmf, pgoff);
+		return do_cow_fault(vmf);
+	return do_shared_fault(vmf);
 }
 
 static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
@@ -3613,6 +3613,7 @@ static int __handle_mm_fault(struct vm_a
 		.vma = vma,
 		.address = address & PAGE_MASK,
 		.flags = flags,
+		.pgoff = linear_page_index(vma, address),
 	};
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
_

Patches currently in -mm which might be from jack@suse.cz are

mm-join-struct-fault_env-and-vm_fault.patch
mm-use-vmf-address-instead-of-of-vmf-virtual_address.patch
mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch
mm-use-passed-vm_fault-structure-in-__do_fault.patch
mm-trim-__do_fault-arguments.patch
mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared.patch
mm-add-orig_pte-field-into-vm_fault.patch
mm-allow-full-handling-of-cow-faults-in-fault-handlers.patch
mm-factor-out-functionality-to-finish-page-faults.patch
mm-move-handling-of-cow-faults-into-dax-code.patch
mm-factor-out-common-parts-of-write-fault-handling.patch
mm-pass-vm_fault-structure-into-do_page_mkwrite.patch
mm-use-vmf-page-during-wp-faults.patch
mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch
mm-provide-helper-for-finishing-mkwrite-faults.patch
mm-change-return-values-of-finish_mkwrite_fault.patch
mm-export-follow_pte.patch
dax-make-cache-flushing-protected-by-entry-lock.patch
dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch
dax-clear-dirty-entry-tags-on-cache-flush.patch


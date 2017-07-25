From: akpm@linux-foundation.org
Subject: + mm-add-vm_insert_mixed_mkwrite.patch added to -mm tree
Date: Tue, 25 Jul 2017 15:04:31 -0700
Message-ID: <5977c06f.fsjWhkD/tDtJw8Qv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdGYWEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 18:04:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, corbet@lwn.net, dan.j.williams@intel.com, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@redhat.com, rostedt@goodmis.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vm_insert_mixed_mkwrite()
has been added to the -mm tree.  Its filename is
     mm-add-vm_insert_mixed_mkwrite.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-vm_insert_mixed_mkwrite.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-vm_insert_mixed_mkwrite.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mm: add vm_insert_mixed_mkwrite()

When servicing mmap() reads from file holes the current DAX code allocates
a page cache page of all zeroes and places the struct page pointer in the
mapping->page_tree radix tree.  This has three major drawbacks:

1) It consumes memory unnecessarily.  For every 4k page that is read
   via a DAX mmap() over a hole, we allocate a new page cache page.  This
   means that if you read 1GiB worth of pages, you end up using 1GiB of
   zeroed memory.

2) It is slower than using a common zero page because each page fault
   has more work to do.  Instead of just inserting a common zero page we
   have to allocate a page cache page, zero it, and then insert it.

3) The fact that we had to check for both DAX exceptional entries and
   for page cache pages in the radix tree made the DAX code more complex.

This series solves these issues by following the lead of the DAX PMD code
and using a common 4k zero page instead.  This reduces memory usage and
decreases latencies for some workloads, and it simplifies the DAX code,
removing over 100 lines in total.



This patch (of 5):

To be able to use the common 4k zero page in DAX we need to have our PTE
fault path look more like our PMD fault path where a PTE entry can be
marked as dirty and writeable as it is first inserted rather than waiting
for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.

Right now we can rely on having a dax_pfn_mkwrite() call because we can
distinguish between these two cases in do_wp_page():

	case 1: 4k zero page => writable DAX storage
	case 2: read-only DAX storage => writeable DAX storage

This distinction is made by via vm_normal_page().  vm_normal_page()
returns false for the common 4k zero page, though, just as it does for DAX
ptes.  Instead of special casing the DAX + 4k zero page case we will
simplify our DAX PTE page fault sequence so that it matches our DAX PMD
sequence, and get rid of the dax_pfn_mkwrite() helper.  We will instead
use dax_iomap_fault() to handle write-protection faults.

This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set
insert_pfn() will do the work that was previously done by wp_page_reuse()
as part of the dax_pfn_mkwrite() call path.

Link: http://lkml.kernel.org/r/20170724170616.25810-2-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 mm/memory.c        |   50 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-add-vm_insert_mixed_mkwrite include/linux/mm.h
--- a/include/linux/mm.h~mm-add-vm_insert_mixed_mkwrite
+++ a/include/linux/mm.h
@@ -2293,6 +2293,8 @@ int vm_insert_pfn_prot(struct vm_area_st
 			unsigned long pfn, pgprot_t pgprot);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn);
+int vm_insert_mixed_mkwrite(struct vm_area_struct *vma, unsigned long addr,
+			pfn_t pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 
diff -puN mm/memory.c~mm-add-vm_insert_mixed_mkwrite mm/memory.c
--- a/mm/memory.c~mm-add-vm_insert_mixed_mkwrite
+++ a/mm/memory.c
@@ -1647,7 +1647,7 @@ int vm_insert_page(struct vm_area_struct
 EXPORT_SYMBOL(vm_insert_page);
 
 static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			pfn_t pfn, pgprot_t prot)
+			pfn_t pfn, pgprot_t prot, bool mkwrite)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int retval;
@@ -1659,14 +1659,35 @@ static int insert_pfn(struct vm_area_str
 	if (!pte)
 		goto out;
 	retval = -EBUSY;
-	if (!pte_none(*pte))
-		goto out_unlock;
+	if (!pte_none(*pte)) {
+		if (mkwrite) {
+			/*
+			 * For read faults on private mappings the PFN passed
+			 * in may not match the PFN we have mapped if the
+			 * mapped PFN is a writeable COW page.  In the mkwrite
+			 * case we are creating a writable PTE for a shared
+			 * mapping and we expect the PFNs to match.
+			 */
+			if (WARN_ON_ONCE(pte_pfn(*pte) != pfn_t_to_pfn(pfn)))
+				goto out_unlock;
+			entry = *pte;
+			goto out_mkwrite;
+		} else
+			goto out_unlock;
+	}
 
 	/* Ok, finally just insert the thing.. */
 	if (pfn_t_devmap(pfn))
 		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
 	else
 		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
+
+out_mkwrite:
+	if (mkwrite) {
+		entry = pte_mkyoung(entry);
+		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	}
+
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -1737,14 +1758,15 @@ int vm_insert_pfn_prot(struct vm_area_st
 
 	track_pfn_insert(vma, &pgprot, __pfn_to_pfn_t(pfn, PFN_DEV));
 
-	ret = insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot);
+	ret = insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot,
+			false);
 
 	return ret;
 }
 EXPORT_SYMBOL(vm_insert_pfn_prot);
 
-int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-			pfn_t pfn)
+static int __vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+			pfn_t pfn, bool mkwrite)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 
@@ -1773,10 +1795,24 @@ int vm_insert_mixed(struct vm_area_struc
 		page = pfn_to_page(pfn_t_to_pfn(pfn));
 		return insert_page(vma, addr, page, pgprot);
 	}
-	return insert_pfn(vma, addr, pfn, pgprot);
+	return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+}
+
+int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+			pfn_t pfn)
+{
+	return __vm_insert_mixed(vma, addr, pfn, false);
+
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
+int vm_insert_mixed_mkwrite(struct vm_area_struct *vma, unsigned long addr,
+			pfn_t pfn)
+{
+	return __vm_insert_mixed(vma, addr, pfn, true);
+}
+EXPORT_SYMBOL(vm_insert_mixed_mkwrite);
+
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-add-vm_insert_mixed_mkwrite.patch
dax-relocate-some-dax-functions.patch
dax-use-common-4k-zero-page-for-dax-mmap-reads.patch
dax-remove-dax-code-from-page_cache_tree_insert.patch
dax-move-all-dax-radix-tree-defs-to-fs-daxc.patch


From: akpm@linux-foundation.org
Subject: + proc-drop-handling-non-linear-mappings.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:33:56 -0800
Message-ID: <54ac70e4.J4Dv3JmCLZIbRgbx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbAFXd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:33:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: drop handling non-linear mappings
has been added to the -mm tree.  Its filename is
     proc-drop-handling-non-linear-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-drop-handling-non-linear-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-drop-handling-non-linear-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: proc: drop handling non-linear mappings

We have to handle non-linear mappings for /proc/PID/{smaps,clear_refs}
which is unused now.  Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-drop-handling-non-linear-mappings fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-drop-handling-non-linear-mappings
+++ a/fs/proc/task_mmu.c
@@ -443,7 +443,6 @@ struct mem_size_stats {
 	unsigned long anonymous;
 	unsigned long anonymous_thp;
 	unsigned long swap;
-	unsigned long nonlinear;
 	u64 pss;
 };
 
@@ -484,7 +483,6 @@ static void smaps_pte_entry(pte_t *pte,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
-	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct page *page = NULL;
 
 	if (pte_present(*pte)) {
@@ -496,17 +494,10 @@ static void smaps_pte_entry(pte_t *pte,
 			mss->swap += PAGE_SIZE;
 		else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
-	} else if (pte_file(*pte)) {
-		if (pte_to_pgoff(*pte) != pgoff)
-			mss->nonlinear += PAGE_SIZE;
 	}
 
 	if (!page)
 		return;
-
-	if (page->index != pgoff)
-		mss->nonlinear += PAGE_SIZE;
-
 	smaps_account(mss, page, PAGE_SIZE, pte_young(*pte), pte_dirty(*pte));
 }
 
@@ -596,7 +587,6 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_ACCOUNT)]	= "ac",
 		[ilog2(VM_NORESERVE)]	= "nr",
 		[ilog2(VM_HUGETLB)]	= "ht",
-		[ilog2(VM_NONLINEAR)]	= "nl",
 		[ilog2(VM_ARCH_1)]	= "ar",
 		[ilog2(VM_DONTDUMP)]	= "dd",
 #ifdef CONFIG_MEM_SOFT_DIRTY
@@ -668,10 +658,6 @@ static int show_smap(struct seq_file *m,
 		   (vma->vm_flags & VM_LOCKED) ?
 			(unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
 
-	if (vma->vm_flags & VM_NONLINEAR)
-		seq_printf(m, "Nonlinear:      %8lu kB\n",
-				mss.nonlinear >> 10);
-
 	show_smap_vma_flags(m, vma);
 	m_cache_vma(m, vma);
 	return 0;
@@ -772,8 +758,6 @@ static inline void clear_soft_dirty(stru
 		ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
 	} else if (is_swap_pte(ptent)) {
 		ptent = pte_swp_clear_soft_dirty(ptent);
-	} else if (pte_file(ptent)) {
-		ptent = pte_file_clear_soft_dirty(ptent);
 	}
 
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch


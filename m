From: akpm@linux-foundation.org
Subject: + thp-fix-update_mmu_cache_pmd-calls.patch added to -mm tree
Date: Tue, 20 Nov 2012 14:48:06 -0800
Message-ID: <20121120224807.4647C200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:52981 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2KTWsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 17:48:09 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so101180wib.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 14:48:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mingo@elte.hu, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: thp: fix update_mmu_cache_pmd() calls
has been added to the -mm tree.  Its filename is
     thp-fix-update_mmu_cache_pmd-calls.patch

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
Subject: thp: fix update_mmu_cache_pmd() calls

update_mmu_cache_pmd() takes pointer to pmd_t as third, not pmd_t.

mm/huge_memory.c: In function 'do_huge_pmd_numa_page':
mm/huge_memory.c:825:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
In file included from include/linux/mm.h:44:0,
                 from mm/huge_memory.c:8:
arch/mips/include/asm/pgtable.h:385:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'
mm/huge_memory.c:895:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
In file included from include/linux/mm.h:44:0,
                 from mm/huge_memory.c:8:
arch/mips/include/asm/pgtable.h:385:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-update_mmu_cache_pmd-calls mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-update_mmu_cache_pmd-calls
+++ a/mm/huge_memory.c
@@ -773,7 +773,7 @@ fixup:
 	/* change back to regular protection */
 	entry = pmd_modify(entry, vma->vm_page_prot);
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
 
 unlock:
 	spin_unlock(&mm->page_table_lock);
@@ -843,7 +843,7 @@ migrate:
 	page_add_new_anon_rmap(new_page, vma, haddr);
 
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
 	page_remove_rmap(page);
 	spin_unlock(&mm->page_table_lock);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
thp-fix-update_mmu_cache_pmd-calls.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch


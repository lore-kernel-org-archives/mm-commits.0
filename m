From: akpm@linux-foundation.org
Subject: + hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:05 -0700
Message-ID: <20120613204605.EB5FAA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35262 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2FMUqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:07 -0400
Received: by ggeh3 with SMTP id h3so89256gge.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for hugetlb
has been added to the -mm tree.  Its filename is
     hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for hugetlb

i_mmap_mutex lock was added in unmap_single_vma by 502717f4e ("hugetlb:
fix linked list corruption in unmap_hugepage_range()") but we don't use
page->lru in unmap_hugepage_range any more.  Also the lock was taken
higher up in the stack in some code path.  That would result in deadlock.

unmap_mapping_range (i_mmap_mutex)
 -> unmap_mapping_range_tree
    -> unmap_mapping_range_vma
       -> zap_page_range_single
         -> unmap_single_vma
	      -> unmap_hugepage_range (i_mmap_mutex)

For shared pagetable support for huge pages, since pagetable pages are ref
counted we don't need any lock during huge_pmd_unshare.  We do take
i_mmap_mutex in huge_pmd_share while walking the vma_prio_tree in mapping.
(39dde65c9940c97f ("shared page table for hugetlb page")).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/memory.c~hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb mm/memory.c
--- a/mm/memory.c~hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb
+++ a/mm/memory.c
@@ -1336,11 +1336,8 @@ static void unmap_single_vma(struct mmu_
 			 * Since no pte has actually been setup, it is
 			 * safe to do nothing in this case.
 			 */
-			if (vma->vm_file) {
-				mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			if (vma->vm_file)
 				__unmap_hugepage_range(tlb, vma, start, end, NULL);
-				mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
-			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
 	}
_
Subject: Subject: hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for hugetlb

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch


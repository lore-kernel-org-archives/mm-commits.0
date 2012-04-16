From: akpm@linux-foundation.org
Subject: + hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:15:57 -0700
Message-ID: <20120416231557.26F4BA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:51445 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2DPXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:15:59 -0400
Received: by wejx9 with SMTP id x9so262230wej.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:15:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/memory.c~hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb mm/memory.c
--- a/mm/memory.c~hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb
+++ a/mm/memory.c
@@ -1329,11 +1329,8 @@ static void unmap_single_vma(struct mmu_
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
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch


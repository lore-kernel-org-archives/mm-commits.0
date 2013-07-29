From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
 added to -mm tree
Date: Mon, 29 Jul 2013 15:07:55 -0700
Message-ID: <51f6e7bb.GQh2moZ80vL8mQ+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3G2WH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:07:55 -0700


The patch titled
     Subject: mm, hugetlb: add VM_NORESERVE check in vma_has_reserves()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: add VM_NORESERVE check in vma_has_reserves()

If we map the region with MAP_NORESERVE and MAP_SHARED, we can skip to
check reserve counting and eventually we cannot be ensured to allocate a
huge page in fault time.  With following example code, you can easily find
this situation.

Assume 2MB, nr_hugepages = 100

        fd = hugetlbfs_unlinked_fd();
        if (fd < 0)
                return 1;

        size = 200 * MB;
        flag = MAP_SHARED;
        p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
        if (p == MAP_FAILED) {
                fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
                return -1;
        }

        size = 2 * MB;
        flag = MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB | MAP_NORESERVE;
        p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, -1, 0);
        if (p == MAP_FAILED) {
                fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
        }
        p[0] = '0';
        sleep(10);

During executing sleep(10), run 'cat /proc/meminfo' on another process.

HugePages_Free:       99
HugePages_Rsvd:      100

Number of free should be higher or equal than number of reserve, but this
aren't.  This represent that non reserved shared mapping steal a reserved
page.  Non reserved shared mapping should not eat into reserve space.

If we consider VM_NORESERVE in vma_has_reserve() and return 0 which mean
that we don't have reserved pages, then we check that we have enough free
pages in dequeue_huge_page_vma().  This prevent to steal a reserved page.

With this change, above test generate a SIGBUG which is correct, because
all free pages are reserved and non reserved shared mapping can't get a
free page.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves
+++ a/mm/hugetlb.c
@@ -464,6 +464,8 @@ void reset_vma_resv_huge_pages(struct vm
 /* Returns true if the VMA has associated reserve pages */
 static int vma_has_reserves(struct vm_area_struct *vma)
 {
+	if (vma->vm_flags & VM_NORESERVE)
+		return 0;
 	if (vma->vm_flags & VM_MAYSHARE)
 		return 1;
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch


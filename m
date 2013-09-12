From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:15 -0700
Message-ID: <52321953.KRHcRwGFPUfM1CaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3ILTnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:15 -0700


The patch titled
     Subject: mm, hugetlb: add VM_NORESERVE check in vma_has_reserves()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.cz>
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

origin.patch


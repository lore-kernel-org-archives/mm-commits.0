From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:07:53 -0700
Message-ID: <51f6e7b9.BbuS3u4ZgCjLAoP7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3G2WHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:07:53 -0700


The patch titled
     Subject: mm, hugetlb: do not use a page in page cache for cow optimization
has been added to the -mm tree.  Its filename is
     mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch

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
Subject: mm, hugetlb: do not use a page in page cache for cow optimization

Currently, we use a page with mapped count 1 in page cache for cow
optimization.  If we find this condition, we don't allocate a new page and
copy contents.  Instead, we map this page directly.  This may introduce a
problem that writting to private mapping overwrite hugetlb file directly. 
You can find this situation with following code.

        size = 20 * MB;
        flag = MAP_SHARED;
        p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
        if (p == MAP_FAILED) {
                fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
                return -1;
        }
        p[0] = 's';
        fprintf(stdout, "BEFORE STEAL PRIVATE WRITE: %c\n", p[0]);
        munmap(p, size);

        flag = MAP_PRIVATE;
        p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
        if (p == MAP_FAILED) {
                fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
        }
        p[0] = 'c';
        munmap(p, size);

        flag = MAP_SHARED;
        p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
        if (p == MAP_FAILED) {
                fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
                return -1;
        }
        fprintf(stdout, "AFTER STEAL PRIVATE WRITE: %c\n", p[0]);
        munmap(p, size);

We can see that "AFTER STEAL PRIVATE WRITE: c", not "AFTER STEAL PRIVATE
WRITE: s".  If we turn off this optimization to a page in page cache, the
problem is disappeared.

So, I change the trigger condition of optimization.  If this page is not
AnonPage, we don't do optimization.  This makes this optimization turning
off for a page cache.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization
+++ a/mm/hugetlb.c
@@ -2528,7 +2528,6 @@ static int hugetlb_cow(struct mm_struct
 {
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
-	int avoidcopy;
 	int outside_reserve = 0;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
@@ -2538,10 +2537,8 @@ static int hugetlb_cow(struct mm_struct
 retry_avoidcopy:
 	/* If no-one else is actually using this page, avoid the copy
 	 * and just make the page writable */
-	avoidcopy = (page_mapcount(old_page) == 1);
-	if (avoidcopy) {
-		if (PageAnon(old_page))
-			page_move_anon_rmap(old_page, vma, address);
+	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
+		page_move_anon_rmap(old_page, vma, address);
 		set_huge_ptep_writable(vma, address, ptep);
 		return 0;
 	}
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


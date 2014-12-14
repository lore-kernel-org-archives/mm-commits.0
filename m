From: akpm@linux-foundation.org
Subject: [merged] hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:17 -0800
Message-ID: <548d0cf5.erPEADRKzEtK0h1b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaLNEHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, dave@stgolabs.net, isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()
has been removed from the -mm tree.  Its filename was
     hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()

No reason to duplicate the code of an existing macro.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-alloc_bootmem_huge_page-use-is_aligned mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-alloc_bootmem_huge_page-use-is_aligned
+++ a/mm/hugetlb.c
@@ -1457,7 +1457,7 @@ int __weak alloc_bootmem_huge_page(struc
 	return 0;
 
 found:
-	BUG_ON((unsigned long)virt_to_phys(m) & (huge_page_size(h) - 1));
+	BUG_ON(!IS_ALIGNED(virt_to_phys(m), huge_page_size(h)));
 	/* Put them into a private list first because mem_map is not up yet */
 	list_add(&m->list, &huge_boot_pages);
 	m->hstate = h;
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

origin.patch
linux-next.patch


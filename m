From: akpm@linux-foundation.org
Subject: + hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch added to
 -mm tree
Date: Thu, 13 Nov 2014 13:54:52 -0800
Message-ID: <546528ac.tQ8ske0lrq4HpvJ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934250AbaKMVyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:54:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, dave@stgolabs.net, isimatu.yasuaki@jp.fujitsu.com, riel@redhat.com, rientjes@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()
has been added to the -mm tree.  Its filename is
     hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()

No reason to duplicate the code of an existing macro.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
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

hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
linux-next.patch


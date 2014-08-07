From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:06:21 -0700
Message-ID: <53e3dc3d.ns1HcllM7qxRrQmz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:52003 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHGUGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:22 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so843517oac.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhong@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix potential infinite loop in dissolve_free_huge_pages()
has been removed from the -mm tree.  Its filename was
     mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: mm: fix potential infinite loop in dissolve_free_huge_pages()

It is possible for some platforms, such as powerpc to set HPAGE_SHIFT to 0
to indicate huge pages not supported.

When this is the case, hugetlbfs could be disabled during boot time:
hugetlbfs: disabling because there are no supported hugepage sizes

Then in dissolve_free_huge_pages(), order is kept maximum (64 for 64bits),
and the for loop below won't end: for (pfn = start_pfn; pfn < end_pfn; pfn
+= 1 << order)

As suggested by Naoya, below fix checks hugepages_supported() before
calling dissolve_free_huge_pages().

[rientjes@google.com: no legitimate reason to call dissolve_free_huge_pages() when !hugepages_supported()]
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/hugetlb.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages
+++ a/mm/hugetlb.c
@@ -1088,6 +1088,9 @@ void dissolve_free_huge_pages(unsigned l
 	unsigned long pfn;
 	struct hstate *h;
 
+	if (!hugepages_supported())
+		return;
+
 	/* Set scan step to minimum hugepage size */
 	for_each_hstate(h)
 		if (order > huge_page_order(h))
_

Patches currently in -mm which might be from zhong@linux.vnet.ibm.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: +
 mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch added to
 -mm tree
Date: Tue, 29 Jul 2014 15:47:32 -0700
Message-ID: <53d82484.0nrL0jPCV+aFZBUj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57478 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaG2Wrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 18:47:33 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so56302qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 15:47:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhong@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix potential infinite loop in dissolve_free_huge_pages()
has been added to the -mm tree.  Its filename is
     mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages
+++ a/mm/memory_hotplug.c
@@ -1726,7 +1726,8 @@ repeat:
 	 * dissolve free hugepages in the memory block before doing offlining
 	 * actually in order to make hugetlbfs's object counting consistent.
 	 */
-	dissolve_free_huge_pages(start_pfn, end_pfn);
+	if (hugepages_supported())
+		dissolve_free_huge_pages(start_pfn, end_pfn);
 	/* check again */
 	offlined_pages = check_pages_isolated(start_pfn, end_pfn);
 	if (offlined_pages < 0) {
_

Patches currently in -mm which might be from zhong@linux.vnet.ibm.com are

mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch


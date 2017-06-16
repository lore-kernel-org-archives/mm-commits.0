From: akpm@linux-foundation.org
Subject: + replace-memfmt-with-string_get_size.patch added to -mm tree
Date: Fri, 16 Jun 2017 11:48:23 -0700
Message-ID: <594427f7.uHM6+yBKATL11nYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdFPSsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@infradead.org, Liam.Howlett@Oracle.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: replace memfmt with string_get_size
has been added to the -mm tree.  Its filename is
     replace-memfmt-with-string_get_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/replace-memfmt-with-string_get_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/replace-memfmt-with-string_get_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm/hugetlb.c: replace memfmt with string_get_size

The hugetlb code has its own function to report human-readable sizes. 
Convert it to use the shared string_get_size() function.  This will lead
to a minor difference in user visible output (MiB/GiB instead of MB/GB),
but some would argue that's desirable anyway.

Link: http://lkml.kernel.org/r/20170606190350.GA20010@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN mm/hugetlb.c~replace-memfmt-with-string_get_size mm/hugetlb.c
--- a/mm/hugetlb.c~replace-memfmt-with-string_get_size
+++ a/mm/hugetlb.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
+#include <linux/string_helpers.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/jhash.h>
@@ -70,17 +71,6 @@ struct mutex *hugetlb_fault_mutex_table
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
-static char * __init memfmt(char *buf, unsigned long n)
-{
-	if (n >= (1UL << 30))
-		sprintf(buf, "%lu GB", n >> 30);
-	else if (n >= (1UL << 20))
-		sprintf(buf, "%lu MB", n >> 20);
-	else
-		sprintf(buf, "%lu KB", n >> 10);
-	return buf;
-}
-
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
 	bool free = (spool->count == 0) && (spool->used_hpages == 0);
@@ -2255,7 +2245,7 @@ static void __init hugetlb_hstate_alloc_
 	if (i < h->max_huge_pages) {
 		char buf[32];
 
-		memfmt(buf, huge_page_size(h)),
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
 		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, i);
 		h->max_huge_pages = i;
@@ -2283,9 +2273,10 @@ static void __init report_hugepages(void
 
 	for_each_hstate(h) {
 		char buf[32];
+
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
 		pr_info("HugeTLB registered %s page size, pre-allocated %ld pages\n",
-			memfmt(buf, huge_page_size(h)),
-			h->free_huge_pages);
+			buf, h->free_huge_pages);
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

replace-memfmt-with-string_get_size.patch


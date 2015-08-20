From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3.patch
 removed from -mm tree
Date: Thu, 20 Aug 2015 14:37:27 -0700
Message-ID: <55d64897.W9ulK10PLal8Idox%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbHTVh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 17:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h  |    4 ----
 include/linux/mm_types.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3
+++ a/include/linux/hugetlb.h
@@ -344,10 +344,6 @@ int __init alloc_bootmem_huge_page(struc
 void __init hugetlb_add_hstate(unsigned order);
 struct hstate *size_to_hstate(unsigned long size);
 
-#ifndef HUGE_MAX_HSTATE
-#define HUGE_MAX_HSTATE 1
-#endif
-
 extern struct hstate hstates[HUGE_MAX_HSTATE];
 extern unsigned int default_hstate_idx;
 
diff -puN include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3 include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3
+++ a/include/linux/mm_types.h
@@ -367,6 +367,10 @@ struct mm_rss_stat {
 };
 
 #ifdef CONFIG_HUGETLB_PAGE
+
+#ifndef HUGE_MAX_HSTATE
+#define HUGE_MAX_HSTATE	1
+#endif
 struct hugetlb_usage {
 	atomic_long_t count[HUGE_MAX_HSTATE];
 };
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch
mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch


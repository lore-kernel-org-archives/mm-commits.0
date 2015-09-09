From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:53:12 -0700
Message-ID: <55f08e28.x8TRLG4vBGisdCN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbbIITxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: don't try to unpoison containment-failed pages
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hwpoison: don't try to unpoison containment-failed pages

memory_failure() can be called at any page at any time, which means that
we can't eliminate the possibility of containment failure.  In such case
the best option is to leak the page intentionally (and never touch it
later.)

We have an unpoison function for testing, and it cannot handle such
containment-failed pages, which results in kernel panic (visible with
various calltraces.) So this patch suggests that we limit the unpoisonable
pages to properly contained pages and ignore any other ones.

Testers are recommended to keep in mind that there're un-unpoisonable pages
when writing test programs.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-dont-try-to-unpoison-containment-failed-pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dont-try-to-unpoison-containment-failed-pages
+++ a/mm/memory-failure.c
@@ -1445,6 +1445,22 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
+	if (page_count(page) > 1) {
+		pr_info("MCE: Someone grabs the hwpoison page %#lx\n", pfn);
+		return 0;
+	}
+
+	if (page_mapped(page)) {
+		pr_info("MCE: Someone maps the hwpoison page %#lx\n", pfn);
+		return 0;
+	}
+
+	if (page_mapping(page)) {
+		pr_info("MCE: the hwpoison page has non-NULL mapping %#lx\n",
+			pfn);
+		return 0;
+	}
+
 	/*
 	 * unpoison_memory() can encounter thp only when the thp is being
 	 * worked by memory_failure() and the page lock is not held yet.
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch


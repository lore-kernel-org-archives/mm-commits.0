From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-make-optimistic-check-for-swapin-readahead-fix.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 21:21:05 -0800
Message-ID: <569f1941.f/qInHlUQWRXVY2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbcATFVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 00:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: avoid usage of uninitialized variable 'isolated'
has been removed from the -mm tree.  Its filename was
     mm-make-optimistic-check-for-swapin-readahead-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: avoid usage of uninitialized variable 'isolated'

In file included from include/trace/events/huge_memory.h:7:0,
                 from mm/huge_memory.c:62:
include/linux/tracepoint.h:141:5: warning: `isolated' may be used uninitialized in this function [-Wmaybe-uninitialized]
     ((void(*)(proto))(it_func))(args); \
     ^
mm/huge_memory.c:2327:6: note: `isolated' was declared here
  int isolated, result = 0;

We make use of isolated in error path before it get initialized.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix
+++ a/mm/huge_memory.c
@@ -2351,7 +2351,7 @@ static void collapse_huge_page(struct mm
 	pgtable_t pgtable;
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int isolated, result = 0;
+	int isolated = 0, result = 0;
 	unsigned long hstart, hend;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list.patch
mm-proc-add-workaround-for-old-compilers.patch
thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


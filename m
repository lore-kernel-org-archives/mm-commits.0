From: akpm@linux-foundation.org
Subject: [merged] thp-fix-typo-in-khugepaged_scan_pmd.patch removed from
 -mm tree
Date: Sat, 26 Mar 2016 20:31:37 -0700
Message-ID: <56f75419.eceUGW2TlUExigJx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0Dbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix typo in khugepaged_scan_pmd()
has been removed from the -mm tree.  Its filename was
     thp-fix-typo-in-khugepaged_scan_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix typo in khugepaged_scan_pmd()

!PageLRU should lead to SCAN_PAGE_LRU, not SCAN_SCAN_ABORT result.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-typo-in-khugepaged_scan_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-typo-in-khugepaged_scan_pmd
+++ a/mm/huge_memory.c
@@ -2578,7 +2578,7 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		khugepaged_node_load[node]++;
 		if (!PageLRU(page)) {
-			result = SCAN_SCAN_ABORT;
+			result = SCAN_PAGE_LRU;
 			goto out_unmap;
 		}
 		if (PageLocked(page)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


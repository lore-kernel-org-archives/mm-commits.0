From: akpm@linux-foundation.org
Subject: [merged]
 mm-khugepaged-add-trace-status-description-for-scan_page_has_private.patch
 removed from -mm tree
Date: Tue, 14 Jan 2020 16:46:02 -0800
Message-ID: <20200115004602.sG3P8yeSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgAOAqD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:46:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, songliubraving@fb.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: khugepaged: add trace status description for SCAN_PAGE_HAS_PRIVATE
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-trace-status-description-for-scan_page_has_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: khugepaged: add trace status description for SCAN_PAGE_HAS_PRIVATE

Commit 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem)
FS") introduced a new khugepaged scan result: SCAN_PAGE_HAS_PRIVATE, but
the corresponding description for trace events were not added.

Link: http://lkml.kernel.org/r/1574793844-2914-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-add-trace-status-description-for-scan_page_has_private
+++ a/include/trace/events/huge_memory.h
@@ -31,7 +31,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
-	EMe(SCAN_TRUNCATED,		"truncated")			\
+	EM( SCAN_TRUNCATED,		"truncated")			\
+	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 
 #undef EM
 #undef EMe
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

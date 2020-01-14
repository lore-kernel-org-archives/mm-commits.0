From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 11/11] mm: khugepaged: add trace status description
 for SCAN_PAGE_HAS_PRIVATE
Date: Mon, 13 Jan 2020 16:29:36 -0800
Message-ID: <20200114002936.cnqbu%akpm__27769.7217230283$1578961904$gmane$org@linux-foundation.org>
References: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:37 -0500
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: songliubraving@fb.com, kirill.shutemov@linux.intel.com, anshuman.khandual@arm.com, yang.shi@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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

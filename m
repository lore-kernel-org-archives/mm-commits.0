From: akpm@linux-foundation.org
Subject: [merged] mm-shmem-fix-build-without-thp.patch removed
 from -mm tree
Date: Thu, 23 Apr 2020 12:51:48 -0700
Message-ID: <20200423195148.pAT0fjJBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTvt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm/shmem: fix build without THP
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-build-without-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: fix build without THP

Some optimizers don't notice that shmem_punch_compound() is always true
(PageTransCompound() being false) without CONFIG_TRANSPARENT_HUGEPAGE==y:
use IS_ENABLED to help them to avoid the BUILD_BUG inside HPAGE_PMD_NR.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2004142339170.10035@eggly.anvils
Fixes: 71725ed10c40 ("mm: huge tmpfs: try to split_huge_page() when punching hole")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-build-without-thp
+++ a/mm/shmem.c
@@ -952,7 +952,7 @@ static void shmem_undo_range(struct inod
 				VM_BUG_ON_PAGE(PageWriteback(page), page);
 				if (shmem_punch_compound(page, start, end))
 					truncate_inode_page(mapping, page);
-				else {
+				else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 					/* Wipe the page and don't get stuck */
 					clear_highpage(page);
 					flush_dcache_page(page);
_

Patches currently in -mm which might be from hughd@google.com are

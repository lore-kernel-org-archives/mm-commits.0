From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 10/15] mm/shmem: fix build without THP
Date: Mon, 20 Apr 2020 18:14:07 -0700
Message-ID: <20200421011407.urMuIwZHA%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgDUBOI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:14:08 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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

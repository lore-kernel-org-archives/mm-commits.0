From: akpm@linux-foundation.org
Subject: [merged]
 rmap-fix-compound-check-logic-in-page_remove_file_rmap.patch removed from
 -mm tree
Date: Thu, 11 Aug 2016 11:36:14 -0700
Message-ID: <57acc59e.VecmQuXPjIC2pVcX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcHKSgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 14:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@arm.com, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, shijie.huang@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: fix compound check logic in page_remove_file_rmap
has been removed from the -mm tree.  Its filename was
     rmap-fix-compound-check-logic-in-page_remove_file_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steve Capper <steve.capper@arm.com>
Subject: rmap: fix compound check logic in page_remove_file_rmap

In page_remove_file_rmap(.) we have the following check:
  VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);

This is meant to check for either HugeTLB pages or THP when a compound
page is passed in.

Unfortunately, if one disables CONFIG_TRANSPARENT_HUGEPAGE, then
PageTransHuge(.) will always return false, provoking BUGs when one runs
the libhugetlbfs test suite.

This patch replaces PageTransHuge(), with PageHead() which will work for
both HugeTLB and THP.

Fixes: dd78fedde4b9 ("rmap: support file thp")
Link: http://lkml.kernel.org/r/1470838217-5889-1-git-send-email-steve.capper@arm.com
Signed-off-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Huang Shijie <shijie.huang@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~rmap-fix-compound-check-logic-in-page_remove_file_rmap mm/rmap.c
--- a/mm/rmap.c~rmap-fix-compound-check-logic-in-page_remove_file_rmap
+++ a/mm/rmap.c
@@ -1304,7 +1304,7 @@ static void page_remove_file_rmap(struct
 {
 	int i, nr = 1;
 
-	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
+	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
 	lock_page_memcg(page);
 
 	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
_

Patches currently in -mm which might be from steve.capper@arm.com are



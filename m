From: akpm@linux-foundation.org
Subject: [merged] mm-fix-build-of-split-ptlock-code.patch removed from -mm tree
Date: Thu, 26 Dec 2013 13:21:19 -0800
Message-ID: <52bc9dcf.zU4ZcjtgOMn2bVWB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3LZVVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 16:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, hughd@google.com, olof@lixom.net

Subject: [merged] mm-fix-build-of-split-ptlock-code.patch removed from -mm tree
To: olof@lixom.net,hughd@google.com,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 13:21:19 -0800


The patch titled
     Subject: mm: fix build of split ptlock code
has been removed from the -mm tree.  Its filename was
     mm-fix-build-of-split-ptlock-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Olof Johansson <olof@lixom.net>
Subject: mm: fix build of split ptlock code

Commit 597d795a2a78 ("mm: do not allocate page->ptl dynamically, if
spinlock_t fits to long") restructures some allocators that are compiled
even if USE_SPLIT_PTLOCKS arn't used.  It results in compilation failure:

mm/memory.c:4282:6: error: 'struct page' has no member named 'ptl'
mm/memory.c:4288:12: error: 'struct page' has no member named 'ptl'

Add in the missing ifdef.

Fixes: 597d795a2a78 ('mm: do not allocate page->ptl dynamically, if spinlock_t fits to long')

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-fix-build-of-split-ptlock-code mm/memory.c
--- a/mm/memory.c~mm-fix-build-of-split-ptlock-code
+++ a/mm/memory.c
@@ -4271,7 +4271,7 @@ void copy_user_huge_page(struct page *ds
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
-#if ALLOC_SPLIT_PTLOCKS
+#if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
 bool ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
_

Patches currently in -mm which might be from olof@lixom.net are

linux-next.patch


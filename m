From: akpm@linux-foundation.org
Subject: - mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range.patch removed from -mm tree
Date: Wed, 19 Nov 2008 12:47:56 -0800
Message-ID: <200811192047.mAJKluAC007149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbYKSUsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 15:48:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, mm-commits@vger.kernel.org


The patch titled
     mm: fix unitialized return value in mm/mlock.c: __mlock_vma_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix unitialized return value in mm/mlock.c: __mlock_vma_pages_range()
From: Helge Deller <deller@gmx.de>

Fix an uninitialized return value when compiling on parisc (with
CONFIG_UNEVICTABLE_LRU=y):

	mm/mlock.c: In function `__mlock_vma_pages_range':
	mm/mlock.c:165: warning: `ret' might be used uninitialized in this function

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range mm/mlock.c
--- a/mm/mlock.c~mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range
+++ a/mm/mlock.c
@@ -162,7 +162,7 @@ static long __mlock_vma_pages_range(stru
 	unsigned long addr = start;
 	struct page *pages[16]; /* 16 gives a reasonable batch */
 	int nr_pages = (end - start) / PAGE_SIZE;
-	int ret;
+	int ret = 0;
 	int gup_flags = 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch


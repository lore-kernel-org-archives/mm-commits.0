From: akpm@linux-foundation.org
Subject: + mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:26:10 -0800
Message-ID: <200811190026.mAJ0QAKR022066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbYKSA0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:26:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de


The patch titled
     mm: fix unitialized return value in mm/mlock.c: __mlock_vma_pages_range()
has been added to the -mm tree.  Its filename is
     mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-fix-unitialized-return-value-in-mm-mlockc-__mlock_vma_pages_range.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-fix-out-of-date-comments-which-refers-non-existent-functions-update.patch removed from -mm tree
Date: Fri, 18 Feb 2011 13:11:48 -0800
Message-ID: <201102182111.p1ILBmIB016848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab1BRVMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Feb 2011 16:12:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ozaki.ryota@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, trivial@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm-fix-out-of-date-comments-which-refers-non-existent-functions-update
has been removed from the -mm tree.  Its filename was
     mm-fix-out-of-date-comments-which-refers-non-existent-functions-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-fix-out-of-date-comments-which-refers-non-existent-functions-update
From: Ryota Ozaki <ozaki.ryota@gmail.com>

do_file_page and do_no_page don't exist anymore, but some comments still
refers them.  The patch fixes them by replacing them with existing ones.

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Kosina <trivial@kernel.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/cacheflush.h |    2 +-
 arch/avr32/mm/cache.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/cacheflush.h~mm-fix-out-of-date-comments-which-refers-non-existent-functions-update arch/alpha/include/asm/cacheflush.h
--- a/arch/alpha/include/asm/cacheflush.h~mm-fix-out-of-date-comments-which-refers-non-existent-functions-update
+++ a/arch/alpha/include/asm/cacheflush.h
@@ -63,7 +63,7 @@ extern void flush_icache_user_range(stru
 		struct page *page, unsigned long addr, int len);
 #endif
 
-/* This is used only in do_no_page and do_swap_page.  */
+/* This is used only in __do_fault and do_swap_page.  */
 #define flush_icache_page(vma, page) \
   flush_icache_user_range((vma), (page), 0, 0)
 
diff -puN arch/avr32/mm/cache.c~mm-fix-out-of-date-comments-which-refers-non-existent-functions-update arch/avr32/mm/cache.c
--- a/arch/avr32/mm/cache.c~mm-fix-out-of-date-comments-which-refers-non-existent-functions-update
+++ a/arch/avr32/mm/cache.c
@@ -113,7 +113,7 @@ void flush_icache_range(unsigned long st
 }
 
 /*
- * This one is called from do_no_page(), do_swap_page() and install_page().
+ * This one is called from __do_fault() and do_swap_page().
  */
 void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
_

Patches currently in -mm which might be from ozaki.ryota@gmail.com are

linux-next.patch


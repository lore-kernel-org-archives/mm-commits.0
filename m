From: akpm@linux-foundation.org
Subject: + mm-fix-out-of-date-comments-which-refers-non-existent-functions-update.patch added to -mm tree
Date: Mon, 14 Feb 2011 13:57:09 -0800
Message-ID: <201102142157.p1ELv9c2028005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab1BNV5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 16:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ozaki.ryota@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, trivial@kernel.org


The patch titled
     mm-fix-out-of-date-comments-which-refers-non-existent-functions-update
has been added to the -mm tree.  Its filename is
     mm-fix-out-of-date-comments-which-refers-non-existent-functions-update.patch

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

mm-fix-out-of-date-comments-which-refers-non-existent-functions.patch
mm-fix-out-of-date-comments-which-refers-non-existent-functions-update.patch


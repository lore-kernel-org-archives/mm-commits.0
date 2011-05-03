From: akpm@linux-foundation.org
Subject: + xtensa-mm-remove-want_page_virtual.patch added to -mm tree
Date: Tue, 03 May 2011 14:39:16 -0700
Message-ID: <201105032139.p43LdGVY011950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030Ab1ECVjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 17:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastian@breakpoint.cc, chris@zankel.net, tglx@linutronix.de


The patch titled
     xtensa/mm: remove WANT_PAGE_VIRTUAL
has been added to the -mm tree.  Its filename is
     xtensa-mm-remove-want_page_virtual.patch

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
Subject: xtensa/mm: remove WANT_PAGE_VIRTUAL
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

This is not useful: it provides page->virtual and is used with highmem. 
xtensa has no support for highmem and those HIGHMEM bits which are found
by grep are partly implemented.  The interesting functions like kmap() are
missing.  If someone actually implements the complete HIGHMEM support he
could use HASHED_PAGE_VIRTUAL like most others do.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Chris Zankel <chris@zankel.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/page.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/xtensa/include/asm/page.h~xtensa-mm-remove-want_page_virtual arch/xtensa/include/asm/page.h
--- a/arch/xtensa/include/asm/page.h~xtensa-mm-remove-want_page_virtual
+++ a/arch/xtensa/include/asm/page.h
@@ -171,10 +171,6 @@ extern void copy_user_page(void*, void*,
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
-#ifdef CONFIG_MMU
-#define WANT_PAGE_VIRTUAL
-#endif

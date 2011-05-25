From: akpm@linux-foundation.org
Subject: [merged] xtensa-mm-remove-want_page_virtual.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:05 -0700
Message-ID: <201105252025.p4PKPSpU014396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577Ab1EYU0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastian@breakpoint.cc, chris@zankel.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     xtensa/mm: remove WANT_PAGE_VIRTUAL
has been removed from the -mm tree.  Its filename was
     xtensa-mm-remove-want_page_virtual.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

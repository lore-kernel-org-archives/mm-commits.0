From: akpm@linux-foundation.org
Subject: +
 include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page.patch added to -mm tree
Date: Wed, 18 Nov 2015 14:06:06 -0800
Message-ID: <564cf64e.uY254XEw/wH0BVG8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240AbbKRWGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 17:06:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/page.h: remove useless get_user_page() and free_user_page()
has been added to the -mm tree.  Its filename is
     include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <xili_gchen_5257@hotmail.com>
Subject: include/asm-generic/page.h: remove useless get_user_page() and free_user_page()

They are not symmetric with each other and have no users, so remove them.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/page.h       |    3 ---
 arch/arm/include/asm/page-nommu.h |    3 ---
 arch/frv/include/asm/page.h       |    3 ---
 arch/m68k/include/asm/page_mm.h   |    3 ---
 arch/m68k/include/asm/page_no.h   |    3 ---
 arch/openrisc/include/asm/page.h  |    3 ---
 include/asm-generic/page.h        |    3 ---
 7 files changed, 21 deletions(-)

diff -puN arch/arc/include/asm/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page arch/arc/include/asm/page.h
--- a/arch/arc/include/asm/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/arch/arc/include/asm/page.h
@@ -13,9 +13,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)	free_page(addr)
-
 #define clear_page(paddr)		memset((paddr), 0, PAGE_SIZE)
 #define copy_page(to, from)		memcpy((to), (from), PAGE_SIZE)
 
diff -puN arch/arm/include/asm/page-nommu.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page arch/arm/include/asm/page-nommu.h
--- a/arch/arm/include/asm/page-nommu.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/arch/arm/include/asm/page-nommu.h
@@ -17,9 +17,6 @@
 #define KTHREAD_SIZE PAGE_SIZE
 #endif
  
-#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)	free_page(addr)
-
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
diff -puN arch/frv/include/asm/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page arch/frv/include/asm/page.h
--- a/arch/frv/include/asm/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/arch/frv/include/asm/page.h
@@ -8,9 +8,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)		free_page(addr)
-
 #define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
 #define copy_page(to,from)			memcpy((to), (from), PAGE_SIZE)
 
diff -puN arch/m68k/include/asm/page_mm.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page arch/m68k/include/asm/page_mm.h
--- a/arch/m68k/include/asm/page_mm.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/arch/m68k/include/asm/page_mm.h
@@ -6,9 +6,6 @@
 #include <linux/compiler.h>
 #include <asm/module.h>
 
-#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)	free_page(addr)
-
 /*
  * We don't need to check for alignment etc.
  */
diff -puN arch/m68k/include/asm/page_no.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page arch/m68k/include/asm/page_no.h
--- a/arch/m68k/include/asm/page_no.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/arch/m68k/include/asm/page_no.h
@@ -6,9 +6,6 @@
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
-#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)	free_page(addr)
-
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
diff -puN arch/openrisc/include/asm/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page arch/openrisc/include/asm/page.h
--- a/arch/openrisc/include/asm/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/arch/openrisc/include/asm/page.h
@@ -40,9 +40,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define get_user_page(vaddr)            __get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)      free_page(addr)
-
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
 
diff -puN include/asm-generic/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page include/asm-generic/page.h
--- a/include/asm-generic/page.h~include-asm-generic-pageh-remove-useless-get_user_page-and-free_user_page
+++ a/include/asm-generic/page.h
@@ -24,9 +24,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)	free_page(addr)

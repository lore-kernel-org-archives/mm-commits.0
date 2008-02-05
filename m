From: akpm@linux-foundation.org
Subject: - iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:46 -0800
Message-ID: <200802052228.m15MSRo9011884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762815AbYBEWoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mingo@elte.hu, mulix@mulix.org, tglx@linutronix.de, mm-


The patch titled
     iommu sg: kill __clear_bit_string and find_next_zero_string
has been removed from the -mm tree.  Its filename was
     iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg: kill __clear_bit_string and find_next_zero_string
From: FUJITA Tomonori <tomof@acm.org>

This kills unused __clear_bit_string and find_next_zero_string (they
were used by only gart and calgary IOMMUs).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <mulix@mulix.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/Makefile       |    2 +-
 arch/x86/lib/bitstr_64.c    |   28 ----------------------------
 include/asm-x86/bitops_64.h |   16 ----------------
 3 files changed, 1 insertion(+), 45 deletions(-)

diff -puN arch/x86/lib/Makefile~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string arch/x86/lib/Makefile
--- a/arch/x86/lib/Makefile~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string
+++ a/arch/x86/lib/Makefile
@@ -21,7 +21,7 @@ else
 
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
-        lib-y += bitstr_64.o bitops_64.o
+        lib-y += bitops_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 endif
diff -puN arch/x86/lib/bitstr_64.c~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string /dev/null
--- a/arch/x86/lib/bitstr_64.c
+++ /dev/null
@@ -1,28 +0,0 @@
-#include <linux/module.h>
-#include <linux/bitops.h>
-
-/* Find string of zero bits in a bitmap */ 
-unsigned long 
-find_next_zero_string(unsigned long *bitmap, long start, long nbits, int len)
-{ 
-	unsigned long n, end, i; 	
-
- again:
-	n = find_next_zero_bit(bitmap, nbits, start);
-	if (n == -1) 
-		return -1;
-	
-	/* could test bitsliced, but it's hardly worth it */
-	end = n+len;
-	if (end > nbits)
-		return -1; 
-	for (i = n+1; i < end; i++) { 
-		if (test_bit(i, bitmap)) {  
-			start = i+1; 
-			goto again; 
-		} 
-	}
-	return n;
-}
-
-EXPORT_SYMBOL(find_next_zero_string);
diff -puN include/asm-x86/bitops_64.h~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string include/asm-x86/bitops_64.h
--- a/include/asm-x86/bitops_64.h~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string
+++ a/include/asm-x86/bitops_64.h
@@ -37,12 +37,6 @@ static inline long __scanbit(unsigned lo
   ((off)+(__scanbit(~(((*(unsigned long *)addr)) >> (off)),(size)-(off)))) : \
 	find_next_zero_bit(addr,size,off)))
 
-/* 
- * Find string of zero bits in a bitmap. -1 when not found.
- */ 
-extern unsigned long 
-find_next_zero_string(unsigned long *bitmap, long start, long nbits, int len);
-
 static inline void set_bit_string(unsigned long *bitmap, unsigned long i, 
 				  int len) 
 { 
@@ -53,16 +47,6 @@ static inline void set_bit_string(unsign
 	}
 } 
 
-static inline void __clear_bit_string(unsigned long *bitmap, unsigned long i, 
-				    int len) 
-{ 
-	unsigned long end = i + len; 
-	while (i < end) {
-		__clear_bit(i, bitmap); 
-		i++;
-	}
-} 
-
 /**
  * ffz - find first zero in word.
  * @word: The word to search
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch

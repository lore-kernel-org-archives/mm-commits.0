From: akpm@osdl.org
Subject: + fix-sparse-warnings-from-asmnet-checksumh.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:05:56 -0800
Message-ID: <200701032105.l03L5uxl031183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbXACVHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, ak@suse.de, rmk@arm.linux.org.uk, spyro@f2s.com, takata@linux-m32r.org


The patch titled
     fix sparse warnings from {asm,net}/checksum.h
has been added to the -mm tree.  Its filename is
     fix-sparse-warnings-from-asmnet-checksumh.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sparse warnings from {asm,net}/checksum.h
From: Tilman Schmidt <tilman@imap.cc>

Rename the variable "sum" in the __range_ok macros to avoid name collisions
causing lots of "symbol shadows an earlier one" warnings by sparse.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ian Molton <spyro@f2s.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/uaccess.h       |    4 ++--
 include/asm-arm26/uaccess-asm.h |    4 ++--
 include/asm-i386/uaccess.h      |    4 ++--
 include/asm-m32r/uaccess.h      |    4 ++--
 include/asm-x86_64/uaccess.h    |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/asm-arm/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh include/asm-arm/uaccess.h
--- a/include/asm-arm/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh
+++ a/include/asm-arm/uaccess.h
@@ -76,10 +76,10 @@ static inline void set_fs(mm_segment_t f
 
 /* We use 33-bit arithmetic here... */
 #define __range_ok(addr,size) ({ \
-	unsigned long flag, sum; \
+	unsigned long flag, roksum; \
 	__chk_user_ptr(addr);	\
 	__asm__("adds %1, %2, %3; sbcccs %1, %1, %0; movcc %0, #0" \
-		: "=&r" (flag), "=&r" (sum) \
+		: "=&r" (flag), "=&r" (roksum) \
 		: "r" (addr), "Ir" (size), "0" (current_thread_info()->addr_limit) \
 		: "cc"); \
 	flag; })
diff -puN include/asm-arm26/uaccess-asm.h~fix-sparse-warnings-from-asmnet-checksumh include/asm-arm26/uaccess-asm.h
--- a/include/asm-arm26/uaccess-asm.h~fix-sparse-warnings-from-asmnet-checksumh
+++ a/include/asm-arm26/uaccess-asm.h
@@ -34,9 +34,9 @@ static inline void set_fs (mm_segment_t 
 }
 
 #define __range_ok(addr,size) ({					\
-	unsigned long flag, sum;					\
+	unsigned long flag, roksum;					\
 	__asm__ __volatile__("subs %1, %0, %3; cmpcs %1, %2; movcs %0, #0" \
-		: "=&r" (flag), "=&r" (sum)				\
+		: "=&r" (flag), "=&r" (roksum)				\
 		: "r" (addr), "Ir" (size), "0" (current_thread_info()->addr_limit)	\
 		: "cc");						\
 	flag; })
diff -puN include/asm-i386/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh
+++ a/include/asm-i386/uaccess.h
@@ -54,10 +54,10 @@ extern struct movsl_mask {
  * This needs 33-bit arithmetic. We have a carry...
  */
 #define __range_ok(addr,size) ({ \
-	unsigned long flag,sum; \
+	unsigned long flag,roksum; \
 	__chk_user_ptr(addr); \
 	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0" \
-		:"=&r" (flag), "=r" (sum) \
+		:"=&r" (flag), "=r" (roksum) \
 		:"1" (addr),"g" ((int)(size)),"rm" (current_thread_info()->addr_limit.seg)); \
 	flag; })
 
diff -puN include/asm-m32r/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh include/asm-m32r/uaccess.h
--- a/include/asm-m32r/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh
+++ a/include/asm-m32r/uaccess.h
@@ -68,7 +68,7 @@ static inline void set_fs(mm_segment_t s
  * This needs 33-bit arithmetic. We have a carry...
  */
 #define __range_ok(addr,size) ({					\
-	unsigned long flag, sum; 					\
+	unsigned long flag, roksum; 					\
 	__chk_user_ptr(addr);						\
 	asm ( 								\
 		"	cmpu	%1, %1    ; clear cbit\n"		\
@@ -76,7 +76,7 @@ static inline void set_fs(mm_segment_t s
 		"	subx	%0, %0\n"				\
 		"	cmpu	%4, %1\n"				\
 		"	subx	%0, %5\n"				\
-		: "=&r" (flag), "=r" (sum)				\
+		: "=&r" (flag), "=r" (roksum)				\
 		: "1" (addr), "r" ((int)(size)), 			\
 		  "r" (current_thread_info()->addr_limit.seg), "r" (0)	\
 		: "cbit" );						\
diff -puN include/asm-x86_64/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh include/asm-x86_64/uaccess.h
--- a/include/asm-x86_64/uaccess.h~fix-sparse-warnings-from-asmnet-checksumh
+++ a/include/asm-x86_64/uaccess.h
@@ -37,11 +37,11 @@
  * Uhhuh, this needs 65-bit arithmetic. We have a carry..
  */
 #define __range_not_ok(addr,size) ({ \
-	unsigned long flag,sum; \
+	unsigned long flag,roksum; \
 	__chk_user_ptr(addr); \
 	asm("# range_ok\n\r" \
 		"addq %3,%1 ; sbbq %0,%0 ; cmpq %1,%4 ; sbbq $0,%0"  \
-		:"=&r" (flag), "=r" (sum) \
+		:"=&r" (flag), "=r" (roksum) \
 		:"1" (addr),"g" ((long)(size)),"g" (current_thread_info()->addr_limit.seg)); \
 	flag; })
 
_

Patches currently in -mm which might be from tilman@imap.cc are

char-tty_wakeup-cleanup.patch
consolidate-line-discipline-number-definitions-v2.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
fix-sparse-warnings-from-asmnet-checksumh.patch

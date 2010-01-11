From: akpm@linux-foundation.org
Subject: [merged] mn10300-add-cc-clobbers-to-asm-statements.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:22 -0800
Message-ID: <201001112019.o0BKJMwM025563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089Ab0AKUUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:20:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: add cc clobbers to asm statements
has been removed from the -mm tree.  Its filename was
     mn10300-add-cc-clobbers-to-asm-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: add cc clobbers to asm statements
From: Mark Salter <msalter@redhat.com>

gcc 4.2.1 for MN10300 is more agressive than the older gcc in
reordering/moving other insns between an insn that sets flags and an insn
that uses those flags.  This leads to trouble with asm statements which
are missing an explicit "cc" clobber.  This patch adds the explicit "cc"
clobber to asm statements which do indeed clobber the condition flags.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/bitops.h    |    4 ++--
 arch/mn10300/include/asm/div64.h     |    2 ++
 arch/mn10300/include/asm/system.h    |    1 +
 arch/mn10300/include/asm/tlbflush.h  |    2 +-
 arch/mn10300/include/asm/uaccess.h   |    4 ++--
 arch/mn10300/kernel/mn10300-serial.c |    3 ++-
 arch/mn10300/lib/checksum.c          |    1 +
 arch/mn10300/lib/delay.c             |    3 ++-
 arch/mn10300/lib/usercopy.c          |    6 +++---
 arch/mn10300/mm/misalignment.c       |    4 ++--
 10 files changed, 18 insertions(+), 12 deletions(-)

diff -puN arch/mn10300/include/asm/bitops.h~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/include/asm/bitops.h
--- a/arch/mn10300/include/asm/bitops.h~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/include/asm/bitops.h
@@ -165,7 +165,7 @@ static inline __attribute__((const))
 unsigned long __ffs(unsigned long x)
 {
 	int bit;
-	asm("bsch %2,%0" : "=r"(bit) : "0"(0), "r"(x & -x));
+	asm("bsch %2,%0" : "=r"(bit) : "0"(0), "r"(x & -x) : "cc");
 	return bit;
 }
 
@@ -177,7 +177,7 @@ static inline __attribute__((const))
 int __ilog2_u32(u32 n)
 {
 	int bit;
-	asm("bsch %2,%0" : "=r"(bit) : "0"(0), "r"(n));
+	asm("bsch %2,%0" : "=r"(bit) : "0"(0), "r"(n) : "cc");
 	return bit;
 }
 
diff -puN arch/mn10300/include/asm/div64.h~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/include/asm/div64.h
--- a/arch/mn10300/include/asm/div64.h~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/include/asm/div64.h
@@ -72,6 +72,7 @@ unsigned __muldiv64u(unsigned val, unsig
 					 * MDR = MDR:val%div */
 	    : "=r"(result)
 	    : "0"(val), "ir"(mult), "r"(div)
+	    : "cc"
 	    );
 
 	return result;
@@ -92,6 +93,7 @@ signed __muldiv64s(signed val, signed mu
 					 * MDR = MDR:val%div */
 	    : "=r"(result)
 	    : "0"(val), "ir"(mult), "r"(div)
+	    : "cc"
 	    );
 
 	return result;
diff -puN arch/mn10300/include/asm/system.h~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/include/asm/system.h
--- a/arch/mn10300/include/asm/system.h~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/include/asm/system.h
@@ -143,6 +143,7 @@ do {									\
 		"	mov	%0,epsw		\n"			\
 		: "=&d"(tmp)						\
 		: "i"(~EPSW_IM), "r"(__mn10300_irq_enabled_epsw)	\
+		: "cc"							\
 		);							\
 } while (0)
 
diff -puN arch/mn10300/include/asm/tlbflush.h~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/include/asm/tlbflush.h
--- a/arch/mn10300/include/asm/tlbflush.h~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/include/asm/tlbflush.h
@@ -22,7 +22,7 @@ do {								\
 		 "	mov %0,%1		\n"		\
 		 : "=d"(w)					\
 		 : "m"(MMUCTR), "i"(MMUCTR_IIV|MMUCTR_DIV)	\
-		 : "memory"					\
+		 : "cc", "memory"				\
 		 );						\
 } while (0)
 
diff -puN arch/mn10300/include/asm/uaccess.h~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/include/asm/uaccess.h
--- a/arch/mn10300/include/asm/uaccess.h~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/include/asm/uaccess.h
@@ -316,7 +316,7 @@ do {									\
 			"	.previous\n"				\
 			: "=a"(__from), "=a"(__to), "=r"(size), "=&r"(w)\
 			: "0"(__from), "1"(__to), "2"(size)		\
-			: "memory");					\
+			: "cc", "memory");				\
 	}								\
 } while (0)
 
@@ -352,7 +352,7 @@ do {									\
 			"	.previous\n"				\
 			: "=a"(__from), "=a"(__to), "=r"(size), "=&r"(w)\
 			: "0"(__from), "1"(__to), "2"(size)		\
-			: "memory");					\
+			: "cc", "memory");				\
 	}								\
 } while (0)
 
diff -puN arch/mn10300/kernel/mn10300-serial.c~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/kernel/mn10300-serial.c
--- a/arch/mn10300/kernel/mn10300-serial.c~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/kernel/mn10300-serial.c
@@ -380,7 +380,8 @@ static int mask_test_and_clear(volatile 
 	u32 epsw;
 	asm volatile("	bclr	%1,(%2)		\n"
 		     "	mov	epsw,%0		\n"
-		     : "=d"(epsw) : "d"(mask), "a"(ptr));
+		     : "=d"(epsw) : "d"(mask), "a"(ptr)
+		     : "cc", "memory");
 	return !(epsw & EPSW_FLAG_Z);
 }
 
diff -puN arch/mn10300/lib/checksum.c~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/lib/checksum.c
--- a/arch/mn10300/lib/checksum.c~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/lib/checksum.c
@@ -22,6 +22,7 @@ static inline unsigned short from32to16(
 	    "	addc	0xffff,%0	\n"
 	    : "=r" (sum)
 	    : "r" (sum << 16), "0" (sum & 0xffff0000)
+	    : "cc"
 	    );
 	return sum >> 16;
 }
diff -puN arch/mn10300/lib/delay.c~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/lib/delay.c
--- a/arch/mn10300/lib/delay.c~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/lib/delay.c
@@ -28,7 +28,8 @@ void __delay(unsigned long loops)
 		"2:	add	-1,%0	\n"
 		"	bne	2b	\n"
 		: "=&d" (d0)
-		: "0" (loops));
+		: "0" (loops)
+		: "cc");
 }
 EXPORT_SYMBOL(__delay);
 
diff -puN arch/mn10300/lib/usercopy.c~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/lib/usercopy.c
--- a/arch/mn10300/lib/usercopy.c~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/lib/usercopy.c
@@ -62,7 +62,7 @@ do {								\
 		"	.previous"				\
 		:"=&r"(res), "=r"(count), "=&r"(w)		\
 		:"i"(-EFAULT), "1"(count), "a"(src), "a"(dst)	\
-		:"memory");					\
+		: "memory", "cc");					\
 } while (0)
 
 long
@@ -109,7 +109,7 @@ do {						\
 		".previous\n"			\
 		: "+r"(size), "=&r"(w)		\
 		: "a"(addr), "d"(0)		\
-		: "memory");			\
+		: "memory", "cc");		\
 } while (0)
 
 unsigned long
@@ -161,6 +161,6 @@ long strnlen_user(const char *s, long n)
 		".previous\n"
 		:"=d"(res), "=&r"(w)
 		:"0"(0), "a"(s), "r"(n)
-		:"memory");
+		: "memory", "cc");
 	return res;
 }
diff -puN arch/mn10300/mm/misalignment.c~mn10300-add-cc-clobbers-to-asm-statements arch/mn10300/mm/misalignment.c
--- a/arch/mn10300/mm/misalignment.c~mn10300-add-cc-clobbers-to-asm-statements
+++ a/arch/mn10300/mm/misalignment.c
@@ -633,13 +633,13 @@ static int misalignment_addr(unsigned lo
 			goto displace_or_inc;
 		case SD24:
 			tmp = disp << 8;
-			asm("asr 8,%0" : "=r"(tmp) : "0"(tmp));
+			asm("asr 8,%0" : "=r"(tmp) : "0"(tmp) : "cc");
 			disp = (long) tmp;
 			goto displace_or_inc;
 		case SIMM4_2:
 			tmp = opcode >> 4 & 0x0f;
 			tmp <<= 28;
-			asm("asr 28,%0" : "=r"(tmp) : "0"(tmp));
+			asm("asr 28,%0" : "=r"(tmp) : "0"(tmp) : "cc");
 			disp = (long) tmp;
 			goto displace_or_inc;
 		case IMM8:
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch


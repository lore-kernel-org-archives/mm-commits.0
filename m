From: akpm@linux-foundation.org
Subject: - aes-x86_64-asm-implementation-optimization.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:48:27 -0700
Message-ID: <200807301948.m6UJmSne013112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757535AbYG3Tuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, adam@yggdrasil.com, astor@fast.no, herbert@gondor.apana.org.au, linux-crypto@ml.breakpoint.cc, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     AES: x86_64 asm implementation optimization
has been removed from the -mm tree.  Its filename was
     aes-x86_64-asm-implementation-optimization.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: AES: x86_64 asm implementation optimization
From: "Huang, Ying" <ying.huang@intel.com>

This patch increases the performance of AES x86-64 implementation.  The
average increment is more than 6.3% and the max increment is more than 10.2%
on Intel CORE 2 CPU.  The performance increment is gained via the following
methods:

- Two additional temporary registers are used to hold the subset of
  the state, so that the dependency between instructions is reduced.

- The expanded key is loaded via 2 64bit load instead of 4 32-bit load.

Below is the test data via: modprobe tcrypt mode=200

- dmesg_1_core-stockn:	stock kernel data
- dmesg_1_core-op4n:	patched kernel data
- percent.txt:		(time_patched - time_stock) / time_stock * 100

ecb1_128_16	-33.46	
ecb1_128_64	-4.08	
ecb1_128_256	-6.33	
ecb1_128_1024	-7.05	
ecb1_128_8192	-7.40	
ecb1_192_16	-4.17	
ecb1_192_64	-4.55	
ecb1_192_256	-6.68	
ecb1_192_1024	-6.51	
ecb1_192_8192	-6.49	
ecb1_256_16	-4.22	
ecb1_256_64	-4.40	
ecb1_256_256	-5.37	
ecb1_256_1024	-6.31	
ecb1_256_8192	-5.88	
ecb0_128_16	2.62	
ecb0_128_64	-7.01	
ecb0_128_256	-8.38	
ecb0_128_1024	-8.52	
ecb0_128_8192	-8.42	
ecb0_192_16	-4.48	
ecb0_192_64	-7.40	
ecb0_192_256	-7.96	
ecb0_192_1024	-8.12	
ecb0_192_8192	-7.75	
ecb0_256_16	-4.36	
ecb0_256_64	-6.83	
ecb0_256_256	-8.50	
ecb0_256_1024	-8.80	
ecb0_256_8192	-8.87	
cbc1_128_16	-1.85	
cbc1_128_64	-3.77	
cbc1_128_256	-5.70	
cbc1_128_1024	-5.86	
cbc1_128_8192	-5.50	
cbc1_192_16	-3.49	
cbc1_192_64	-4.65	
cbc1_192_256	-5.44	
cbc1_192_1024	-6.14	
cbc1_192_8192	-6.15	
cbc1_256_16	-2.77	
cbc1_256_64	-4.96	
cbc1_256_256	-6.16	
cbc1_256_1024	-6.80	
cbc1_256_8192	-6.53	
cbc0_128_16	-3.77	
cbc0_128_64	-5.26	
cbc0_128_256	-7.76	
cbc0_128_1024	-8.53	
cbc0_128_8192	-8.74	
cbc0_192_16	-6.78	
cbc0_192_64	-7.57	
cbc0_192_256	-8.37	
cbc0_192_1024	-9.36	
cbc0_192_8192	-9.00	
cbc0_256_16	-4.48	
cbc0_256_64	-8.30	
cbc0_256_256	-8.07	
cbc0_256_1024	-8.89	
cbc0_256_8192	-7.95	
lrw1_256_16	-1.74	
lrw1_256_64	-4.33	
lrw1_256_256	-5.84	
lrw1_256_1024	-6.33	
lrw1_256_8192	-6.61	
lrw1_320_16	-2.78	
lrw1_320_64	-3.36	
lrw1_320_256	-6.72	
lrw1_320_1024	-6.98	
lrw1_320_8192	-7.05	
lrw1_384_16	-2.52	
lrw1_384_64	-4.87	
lrw1_384_256	-6.55	
lrw1_384_1024	-7.05	
lrw1_384_8192	-7.18	
lrw0_256_16	-2.02	
lrw0_256_64	-6.22	
lrw0_256_256	-8.36	
lrw0_256_1024	-9.10	
lrw0_256_8192	-9.32	
lrw0_320_16	-2.06	
lrw0_320_64	-5.88	
lrw0_320_256	-8.85	
lrw0_320_1024	-9.72	
lrw0_320_8192	-9.81	
lrw0_384_16	-3.64	
lrw0_384_64	-7.46	
lrw0_384_256	-9.35	
lrw0_384_1024	-10.05	
lrw0_384_8192	-10.17	
xts1_256_16	-5.06	
xts1_256_64	-4.41	
xts1_256_256	-5.17	
xts1_256_1024	-5.59	
xts1_256_8192	-5.51	
xts1_384_16	-5.12	
xts1_384_64	-5.52	
xts1_384_256	-5.87	
xts1_384_1024	-6.05	
xts1_384_8192	-6.19	
xts1_512_16	-5.86	
xts1_512_64	-4.90	
xts1_512_256	-6.17	
xts1_512_1024	-6.84	
xts1_512_8192	-6.86	
xts0_256_16	-5.64	
xts0_256_64	-6.30	
xts0_256_256	-7.22	
xts0_256_1024	-7.82	
xts0_256_8192	-7.78	
xts0_384_16	-5.86	
xts0_384_64	-6.75	
xts0_384_256	-8.62	
xts0_384_1024	-8.37	
xts0_384_8192	-8.38	
xts0_512_16	-6.57	
xts0_512_64	-7.90	
xts0_512_256	-9.04	
xts0_512_1024	-9.23	
xts0_512_8192	-9.47	
average: -6.64
min:     -33.46
max:     2.62

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Adam J. Richter" <adam@yggdrasil.com>
Cc: Alexander Kjeldaas <astor@fast.no>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/crypto/aes-x86_64-asm_64.S |  101 ++++++++++++++------------
 include/crypto/aes.h                |    1 
 2 files changed, 58 insertions(+), 44 deletions(-)

diff -puN arch/x86/crypto/aes-x86_64-asm_64.S~aes-x86_64-asm-implementation-optimization arch/x86/crypto/aes-x86_64-asm_64.S
--- a/arch/x86/crypto/aes-x86_64-asm_64.S~aes-x86_64-asm-implementation-optimization
+++ a/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -46,70 +46,81 @@
 #define R7	%rbp
 #define R7E	%ebp
 #define R8	%r8
+#define R8E	%r8d
 #define R9	%r9
+#define R9E	%r9d
 #define R10	%r10
 #define R11	%r11
+#define R12	%r12
+#define R12E	%r12d
+#define R16	%rsp
 
 #define prologue(FUNC,KEY,B128,B192,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11) \
 	.global	FUNC;			\
 	.type	FUNC,@function;		\
 	.align	8;			\
-FUNC:	movq	r1,r2;			\
-	movq	r3,r4;			\
-	leaq	BASE+KEY+48+4(r8),r9;	\
-	movq	r10,r11;		\
-	movl	(r7),r5 ## E;		\
-	movl	4(r7),r1 ## E;		\
-	movl	8(r7),r6 ## E;		\
-	movl	12(r7),r7 ## E;		\
-	movl	BASE+0(r8),r10 ## E;	\
-	xorl	-48(r9),r5 ## E;	\
-	xorl	-44(r9),r1 ## E;	\
-	xorl	-40(r9),r6 ## E;	\
-	xorl	-36(r9),r7 ## E;	\
-	cmpl	$24,r10 ## E;		\
+FUNC:	subq	$24,r11;		\
+	movl	(r6),r4 ## E;		\
+	leaq	BASE+KEY+48+8(r7),r8;	\
+	movq	r1,(r11);		\
+	movq	r9,r10;			\
+	movl	4(r6),r1 ## E;		\
+	movq	r2,8(r11);		\
+	movl	8(r6),r5 ## E;		\
+	movq	r3,16(r11);		\
+	movl	12(r6),r6 ## E;		\
+	movl	BASE+0(r7),r9 ## E;	\
+	xorl	-48(r8),r4 ## E;	\
+	xorl	-44(r8),r1 ## E;	\
+	xorl	-40(r8),r5 ## E;	\
+	xorl	-36(r8),r6 ## E;	\
+	cmpl	$24,r9 ## E;		\
 	jb	B128;			\
-	leaq	32(r9),r9;		\
+	leaq	32(r8),r8;		\
 	je	B192;			\
-	leaq	32(r9),r9;
+	leaq	32(r8),r8;
 
 #define epilogue(r1,r2,r3,r4,r5,r6,r7,r8,r9) \
-	movq	r1,r2;			\
-	movq	r3,r4;			\
-	movl	r5 ## E,(r9);		\
-	movl	r6 ## E,4(r9);		\
-	movl	r7 ## E,8(r9);		\
-	movl	r8 ## E,12(r9);		\
+	movq	(r9),r1;		\
+	movl	r4 ## E,(r8);		\
+	movq	8(r9),r2;		\
+	movl	r5 ## E,4(r8);		\
+	movq	16(r9),r3;		\
+	movl	r6 ## E,8(r8);		\
+	addq	$24,r9;			\
+	movl	r7 ## E,12(r8);		\
 	ret;
 
-#define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
+#define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,ra,rb,rc,rd) \
 	movzbl	r2 ## H,r5 ## E;	\
 	movzbl	r2 ## L,r6 ## E;	\
+	movl	r4 ## E,r8 ## E;	\
+	shrl	$16,r4 ## E;		\
 	movl	TAB+1024(,r5,4),r5 ## E;\
-	movw	r4 ## X,r2 ## X;	\
 	movl	TAB(,r6,4),r6 ## E;	\
-	roll	$16,r2 ## E;		\
-	shrl	$16,r4 ## E;		\
 	movzbl	r4 ## H,r7 ## E;	\
 	movzbl	r4 ## L,r4 ## E;	\
-	xorl	OFFSET(r8),ra ## E;	\
-	xorl	OFFSET+4(r8),rb ## E;	\
+	movq	OFFSET(r11),r10;	\
+	shrl	$16,r2 ## E;		\
+	movl	r3 ## E,r9 ## E;	\
 	xorl	TAB+3072(,r7,4),r5 ## E;\
 	xorl	TAB+2048(,r4,4),r6 ## E;\
-	movzbl	r1 ## L,r7 ## E;	\
 	movzbl	r1 ## H,r4 ## E;	\
-	movl	TAB+1024(,r4,4),r4 ## E;\
-	movw	r3 ## X,r1 ## X;	\
-	roll	$16,r1 ## E;		\
+	movzbl	r1 ## L,r7 ## E;	\
 	shrl	$16,r3 ## E;		\
+	movl	TAB+1024(,r4,4),r4 ## E;\
 	xorl	TAB(,r7,4),r5 ## E;	\
+	shrl	$16,r1 ## E;		\
 	movzbl	r3 ## H,r7 ## E;	\
 	movzbl	r3 ## L,r3 ## E;	\
 	xorl	TAB+3072(,r7,4),r4 ## E;\
 	xorl	TAB+2048(,r3,4),r5 ## E;\
 	movzbl	r1 ## H,r7 ## E;	\
 	movzbl	r1 ## L,r3 ## E;	\
-	shrl	$16,r1 ## E;		\
+	xorl	r10 ## E,ra ## E;	\
+	movl	r9 ## E,r1 ## E;	\
+	movq	OFFSET+8(r11),r9;	\
+	shrq	$32,r10;		\
 	xorl	TAB+3072(,r7,4),r6 ## E;\
 	movl	TAB+2048(,r3,4),r3 ## E;\
 	movzbl	r1 ## H,r7 ## E;	\
@@ -118,38 +129,40 @@ FUNC:	movq	r1,r2;			\
 	xorl	TAB(,r1,4),r3 ## E;	\
 	movzbl	r2 ## H,r1 ## E;	\
 	movzbl	r2 ## L,r7 ## E;	\
-	shrl	$16,r2 ## E;		\
+	xorl	r9 ## E, rc ## E;	\
+	movl	r8 ## E,r2 ## E;	\
+	shrq	$32,r9;			\
+	xorl	r10 ## E,rb ## E;	\
 	xorl	TAB+3072(,r1,4),r3 ## E;\
 	xorl	TAB+2048(,r7,4),r4 ## E;\
 	movzbl	r2 ## H,r1 ## E;	\
+	xorl	r9 ## E, rd ## E;	\
 	movzbl	r2 ## L,r2 ## E;	\
-	xorl	OFFSET+8(r8),rc ## E;	\
-	xorl	OFFSET+12(r8),rd ## E;	\
-	xorl	TAB+1024(,r1,4),r3 ## E;\
-	xorl	TAB(,r2,4),r4 ## E;
+	xorl	TAB(,r2,4),r4 ## E;	\
+	xorl	TAB+1024(,r1,4),r3 ## E;
 
 #define move_regs(r1,r2,r3,r4) \
 	movl	r3 ## E,r1 ## E;	\
 	movl	r4 ## E,r2 ## E;
 
 #define entry(FUNC,KEY,B128,B192) \
-	prologue(FUNC,KEY,B128,B192,R2,R8,R7,R9,R1,R3,R4,R6,R10,R5,R11)
+	prologue(FUNC,KEY,B128,B192,R2,R7,R12,R1,R3,R4,R6,R10,R5,R11,R16)
 
-#define return epilogue(R8,R2,R9,R7,R5,R6,R3,R4,R11)
+#define return epilogue(R2,R7,R12,R5,R6,R3,R4,R11,R16)
 
 #define encrypt_round(TAB,OFFSET) \
-	round(TAB,OFFSET,R1,R2,R3,R4,R5,R6,R7,R10,R5,R6,R3,R4) \
+	round(TAB,OFFSET,R1,R2,R3,R4,R5,R6,R7,R8,R9,R12,R10,R5,R6,R3,R4) \
 	move_regs(R1,R2,R5,R6)
 
 #define encrypt_final(TAB,OFFSET) \
-	round(TAB,OFFSET,R1,R2,R3,R4,R5,R6,R7,R10,R5,R6,R3,R4)
+	round(TAB,OFFSET,R1,R2,R3,R4,R5,R6,R7,R8,R9,R12,R10,R5,R6,R3,R4)
 
 #define decrypt_round(TAB,OFFSET) \
-	round(TAB,OFFSET,R2,R1,R4,R3,R6,R5,R7,R10,R5,R6,R3,R4) \
+	round(TAB,OFFSET,R2,R1,R4,R3,R6,R5,R7,R8,R9,R12,R10,R5,R6,R3,R4) \
 	move_regs(R1,R2,R5,R6)
 
 #define decrypt_final(TAB,OFFSET) \
-	round(TAB,OFFSET,R2,R1,R4,R3,R6,R5,R7,R10,R5,R6,R3,R4)
+	round(TAB,OFFSET,R2,R1,R4,R3,R6,R5,R7,R8,R9,R12,R10,R5,R6,R3,R4)
 
 /* void aes_enc_blk(stuct crypto_tfm *tfm, u8 *out, const u8 *in) */
 
diff -puN include/crypto/aes.h~aes-x86_64-asm-implementation-optimization include/crypto/aes.h
--- a/include/crypto/aes.h~aes-x86_64-asm-implementation-optimization
+++ a/include/crypto/aes.h
@@ -19,6 +19,7 @@
 
 struct crypto_aes_ctx {
 	u32 key_length;
+	u32 _pad1;
 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
 };
_

Patches currently in -mm which might be from ying.huang@intel.com are

aes-x86_64-asm-implementation-optimization.patch


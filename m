From: akpm@linux-foundation.org
Subject: - md-raid6-clean-up-cpuid-and-fpu-enter-exit-code.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:00 -0800
Message-ID: <200703020506.l22560o2000756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754AbXCBFHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@anvin.org, hpa@zytor.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: RAID6: clean up CPUID and FPU enter/exit code
has been removed from the -mm tree.  Its filename was
     md-raid6-clean-up-cpuid-and-fpu-enter-exit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: RAID6: clean up CPUID and FPU enter/exit code
From: "H. Peter Anvin" <hpa@anvin.org>

- Use kernel_fpu_begin() and kernel_fpu_end()
- Use boot_cpu_has() for feature testing even in userspace

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid6mmx.c  |   16 --
 drivers/md/raid6sse1.c |   17 ---
 drivers/md/raid6sse2.c |   22 +--
 drivers/md/raid6x86.h  |  218 +++------------------------------------
 4 files changed, 32 insertions(+), 241 deletions(-)

diff -puN drivers/md/raid6mmx.c~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code drivers/md/raid6mmx.c
--- a/drivers/md/raid6mmx.c~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code
+++ a/drivers/md/raid6mmx.c
@@ -30,14 +30,8 @@ const struct raid6_mmx_constants {
 
 static int raid6_have_mmx(void)
 {
-#ifdef __KERNEL__
 	/* Not really "boot_cpu" but "all_cpus" */
 	return boot_cpu_has(X86_FEATURE_MMX);
-#else
-	/* User space test code */
-	u32 features = cpuid_features();
-	return ( (features & (1<<23)) == (1<<23) );
-#endif
 }
 
 /*
@@ -48,13 +42,12 @@ static void raid6_mmx1_gen_syndrome(int 
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_mmx_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	raid6_before_mmx(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
 	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
@@ -78,7 +71,7 @@ static void raid6_mmx1_gen_syndrome(int 
 		asm volatile("pxor %mm4,%mm4");
 	}
 
-	raid6_after_mmx(&sa);
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_mmxx1 = {
@@ -96,13 +89,12 @@ static void raid6_mmx2_gen_syndrome(int 
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_mmx_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	raid6_before_mmx(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
 	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
@@ -137,7 +129,7 @@ static void raid6_mmx2_gen_syndrome(int 
 		asm volatile("movq %%mm6,%0" : "=m" (q[d+8]));
 	}
 
-	raid6_after_mmx(&sa);
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_mmxx2 = {
diff -puN drivers/md/raid6sse1.c~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code drivers/md/raid6sse1.c
--- a/drivers/md/raid6sse1.c~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code
+++ a/drivers/md/raid6sse1.c
@@ -33,16 +33,10 @@ extern const struct raid6_mmx_constants 
 
 static int raid6_have_sse1_or_mmxext(void)
 {
-#ifdef __KERNEL__
 	/* Not really boot_cpu but "all_cpus" */
 	return boot_cpu_has(X86_FEATURE_MMX) &&
 		(boot_cpu_has(X86_FEATURE_XMM) ||
 		 boot_cpu_has(X86_FEATURE_MMXEXT));
-#else
-	/* User space test code - this incorrectly breaks on some Athlons */
-	u32 features = cpuid_features();
-	return ( (features & (5<<23)) == (5<<23) );
-#endif
 }
 
 /*
@@ -53,14 +47,12 @@ static void raid6_sse11_gen_syndrome(int
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_mmx_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	/* This is really MMX code, not SSE */
-	raid6_before_mmx(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
 	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
@@ -94,8 +86,8 @@ static void raid6_sse11_gen_syndrome(int
 		asm volatile("movntq %%mm4,%0" : "=m" (q[d]));
 	}
 
-	raid6_after_mmx(&sa);
 	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_sse1x1 = {
@@ -113,13 +105,12 @@ static void raid6_sse12_gen_syndrome(int
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_mmx_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	raid6_before_mmx(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
 	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
@@ -157,8 +148,8 @@ static void raid6_sse12_gen_syndrome(int
 		asm volatile("movntq %%mm6,%0" : "=m" (q[d+8]));
 	}
 
-	raid6_after_mmx(&sa);
 	asm volatile("sfence" : :: "memory");
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_sse1x2 = {
diff -puN drivers/md/raid6sse2.c~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code drivers/md/raid6sse2.c
--- a/drivers/md/raid6sse2.c~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code
+++ a/drivers/md/raid6sse2.c
@@ -30,17 +30,11 @@ static const struct raid6_sse_constants 
 
 static int raid6_have_sse2(void)
 {
-#ifdef __KERNEL__
 	/* Not really boot_cpu but "all_cpus" */
 	return boot_cpu_has(X86_FEATURE_MMX) &&
 		boot_cpu_has(X86_FEATURE_FXSR) &&
 		boot_cpu_has(X86_FEATURE_XMM) &&
 		boot_cpu_has(X86_FEATURE_XMM2);
-#else
-	/* User space test code */
-	u32 features = cpuid_features();
-	return ( (features & (15<<23)) == (15<<23) );
-#endif
 }
 
 /*
@@ -51,13 +45,12 @@ static void raid6_sse21_gen_syndrome(int
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_sse_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	raid6_before_sse2(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5");	/* Zero temp */
@@ -93,8 +86,8 @@ static void raid6_sse21_gen_syndrome(int
 		asm volatile("pxor %xmm4,%xmm4");
 	}
 
-	raid6_after_sse2(&sa);
 	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_sse2x1 = {
@@ -112,13 +105,12 @@ static void raid6_sse22_gen_syndrome(int
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_sse_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	raid6_before_sse2(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5"); /* Zero temp */
@@ -156,8 +148,8 @@ static void raid6_sse22_gen_syndrome(int
 		asm volatile("movntdq %%xmm6,%0" : "=m" (q[d+16]));
 	}
 
-	raid6_after_sse2(&sa);
 	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_sse2x2 = {
@@ -179,13 +171,12 @@ static void raid6_sse24_gen_syndrome(int
 	u8 **dptr = (u8 **)ptrs;
 	u8 *p, *q;
 	int d, z, z0;
-	raid6_sse16_save_t sa;
 
 	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	raid6_before_sse16(&sa);
+	kernel_fpu_begin();
 
 	asm volatile("movdqa %0,%%xmm0" :: "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm2,%xmm2");	/* P[0] */
@@ -256,8 +247,9 @@ static void raid6_sse24_gen_syndrome(int
 		asm volatile("movntdq %%xmm14,%0" : "=m" (q[d+48]));
 		asm volatile("pxor %xmm14,%xmm14");
 	}
+
 	asm volatile("sfence" : : : "memory");
-	raid6_after_sse16(&sa);
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_sse2x4 = {
diff -puN drivers/md/raid6x86.h~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code drivers/md/raid6x86.h
--- a/drivers/md/raid6x86.h~md-raid6-clean-up-cpuid-and-fpu-enter-exit-code
+++ a/drivers/md/raid6x86.h
@@ -21,224 +21,40 @@
 
 #if defined(__i386__) || defined(__x86_64__)
 
-#ifdef __x86_64__
-
-typedef struct {
-	unsigned int fsave[27];
-	unsigned long cr0;
-} raid6_mmx_save_t __attribute__((aligned(16)));
-
-/* N.B.: For SSE we only save %xmm0-%xmm7 even for x86-64, since
-   the code doesn't know about the additional x86-64 registers */
-typedef struct {
-	unsigned int sarea[8*4+2];
-	unsigned long cr0;
-} raid6_sse_save_t __attribute__((aligned(16)));
-
-/* This is for x86-64-specific code which uses all 16 XMM registers */
-typedef struct {
-	unsigned int sarea[16*4+2];
-	unsigned long cr0;
-} raid6_sse16_save_t __attribute__((aligned(16)));
-
-/* On x86-64 the stack *SHOULD* be 16-byte aligned, but currently this
-   is buggy in the kernel and it's only 8-byte aligned in places, so
-   we need to do this anyway.  Sigh. */
-#define SAREA(x) ((unsigned int *)((((unsigned long)&(x)->sarea)+15) & ~15))
-
-#else /* __i386__ */
-
-typedef struct {
-	unsigned int fsave[27];
-	unsigned long cr0;
-} raid6_mmx_save_t;
-
-/* On i386, the stack is only 8-byte aligned, but SSE requires 16-byte
-   alignment.  The +3 is so we have the slack space to manually align
-   a properly-sized area correctly.  */
-typedef struct {
-	unsigned int sarea[8*4+3];
-	unsigned long cr0;
-} raid6_sse_save_t;
-
-/* Find the 16-byte aligned save area */
-#define SAREA(x) ((unsigned int *)((((unsigned long)&(x)->sarea)+15) & ~15))
-
-#endif
-
 #ifdef __KERNEL__ /* Real code */
 
-/* Note: %cr0 is 32 bits on i386 and 64 bits on x86-64 */
-
-static inline unsigned long raid6_get_fpu(void)
-{
-	unsigned long cr0;
-
-	preempt_disable();
-	asm volatile("mov %%cr0,%0 ; clts" : "=r" (cr0));
-	return cr0;
-}
-
-static inline void raid6_put_fpu(unsigned long cr0)
-{
-	asm volatile("mov %0,%%cr0" : : "r" (cr0));
-	preempt_enable();
-}
+#include <asm/i387.h>
 
 #else /* Dummy code for user space testing */
 
-static inline unsigned long raid6_get_fpu(void)
-{
-	return 0xf00ba6;
-}
-
-static inline void raid6_put_fpu(unsigned long cr0)
-{
-	(void)cr0;
-}
-
-#endif
-
-static inline void raid6_before_mmx(raid6_mmx_save_t *s)
-{
-	s->cr0 = raid6_get_fpu();
-	asm volatile("fsave %0 ; fwait" : "=m" (s->fsave[0]));
-}
-
-static inline void raid6_after_mmx(raid6_mmx_save_t *s)
-{
-	asm volatile("frstor %0" : : "m" (s->fsave[0]));
-	raid6_put_fpu(s->cr0);
-}
-
-static inline void raid6_before_sse(raid6_sse_save_t *s)
+static inline void kernel_fpu_begin(void)
 {
-	unsigned int *rsa = SAREA(s);
-
-	s->cr0 = raid6_get_fpu();
-
-	asm volatile("movaps %%xmm0,%0" : "=m" (rsa[0]));
-	asm volatile("movaps %%xmm1,%0" : "=m" (rsa[4]));
-	asm volatile("movaps %%xmm2,%0" : "=m" (rsa[8]));
-	asm volatile("movaps %%xmm3,%0" : "=m" (rsa[12]));
-	asm volatile("movaps %%xmm4,%0" : "=m" (rsa[16]));
-	asm volatile("movaps %%xmm5,%0" : "=m" (rsa[20]));
-	asm volatile("movaps %%xmm6,%0" : "=m" (rsa[24]));
-	asm volatile("movaps %%xmm7,%0" : "=m" (rsa[28]));
 }
 
-static inline void raid6_after_sse(raid6_sse_save_t *s)
+static inline void kernel_fpu_end(void)
 {
-	unsigned int *rsa = SAREA(s);
-
-	asm volatile("movaps %0,%%xmm0" : : "m" (rsa[0]));
-	asm volatile("movaps %0,%%xmm1" : : "m" (rsa[4]));
-	asm volatile("movaps %0,%%xmm2" : : "m" (rsa[8]));
-	asm volatile("movaps %0,%%xmm3" : : "m" (rsa[12]));
-	asm volatile("movaps %0,%%xmm4" : : "m" (rsa[16]));
-	asm volatile("movaps %0,%%xmm5" : : "m" (rsa[20]));
-	asm volatile("movaps %0,%%xmm6" : : "m" (rsa[24]));
-	asm volatile("movaps %0,%%xmm7" : : "m" (rsa[28]));
-
-	raid6_put_fpu(s->cr0);
 }
 
-static inline void raid6_before_sse2(raid6_sse_save_t *s)
-{
-	unsigned int *rsa = SAREA(s);
-
-	s->cr0 = raid6_get_fpu();
+#define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
+#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions
+					   * (fast save and restore) */
+#define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
+#define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
+#define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
 
-	asm volatile("movdqa %%xmm0,%0" : "=m" (rsa[0]));
-	asm volatile("movdqa %%xmm1,%0" : "=m" (rsa[4]));
-	asm volatile("movdqa %%xmm2,%0" : "=m" (rsa[8]));
-	asm volatile("movdqa %%xmm3,%0" : "=m" (rsa[12]));
-	asm volatile("movdqa %%xmm4,%0" : "=m" (rsa[16]));
-	asm volatile("movdqa %%xmm5,%0" : "=m" (rsa[20]));
-	asm volatile("movdqa %%xmm6,%0" : "=m" (rsa[24]));
-	asm volatile("movdqa %%xmm7,%0" : "=m" (rsa[28]));
-}
-
-static inline void raid6_after_sse2(raid6_sse_save_t *s)
+/* Should work well enough on modern CPUs for testing */
+static inline int boot_cpu_has(int flag)
 {
-	unsigned int *rsa = SAREA(s);
+	u32 eax = (flag >> 5) ? 0x80000001 : 1;
+	u32 edx;
 
-	asm volatile("movdqa %0,%%xmm0" : : "m" (rsa[0]));
-	asm volatile("movdqa %0,%%xmm1" : : "m" (rsa[4]));
-	asm volatile("movdqa %0,%%xmm2" : : "m" (rsa[8]));
-	asm volatile("movdqa %0,%%xmm3" : : "m" (rsa[12]));
-	asm volatile("movdqa %0,%%xmm4" : : "m" (rsa[16]));
-	asm volatile("movdqa %0,%%xmm5" : : "m" (rsa[20]));
-	asm volatile("movdqa %0,%%xmm6" : : "m" (rsa[24]));
-	asm volatile("movdqa %0,%%xmm7" : : "m" (rsa[28]));
+	asm volatile("cpuid"
+		     : "+a" (eax), "=d" (edx)
+		     : : "ecx", "ebx");
 
-	raid6_put_fpu(s->cr0);
+	return (edx >> (flag & 31)) & 1;
 }
 
-#ifdef __x86_64__
-
-static inline void raid6_before_sse16(raid6_sse16_save_t *s)
-{
-	unsigned int *rsa = SAREA(s);
-
-	s->cr0 = raid6_get_fpu();
-
-	asm volatile("movdqa %%xmm0,%0" : "=m" (rsa[0]));
-	asm volatile("movdqa %%xmm1,%0" : "=m" (rsa[4]));
-	asm volatile("movdqa %%xmm2,%0" : "=m" (rsa[8]));
-	asm volatile("movdqa %%xmm3,%0" : "=m" (rsa[12]));
-	asm volatile("movdqa %%xmm4,%0" : "=m" (rsa[16]));
-	asm volatile("movdqa %%xmm5,%0" : "=m" (rsa[20]));
-	asm volatile("movdqa %%xmm6,%0" : "=m" (rsa[24]));
-	asm volatile("movdqa %%xmm7,%0" : "=m" (rsa[28]));
-	asm volatile("movdqa %%xmm8,%0" : "=m" (rsa[32]));
-	asm volatile("movdqa %%xmm9,%0" : "=m" (rsa[36]));
-	asm volatile("movdqa %%xmm10,%0" : "=m" (rsa[40]));
-	asm volatile("movdqa %%xmm11,%0" : "=m" (rsa[44]));
-	asm volatile("movdqa %%xmm12,%0" : "=m" (rsa[48]));
-	asm volatile("movdqa %%xmm13,%0" : "=m" (rsa[52]));
-	asm volatile("movdqa %%xmm14,%0" : "=m" (rsa[56]));
-	asm volatile("movdqa %%xmm15,%0" : "=m" (rsa[60]));
-}
-
-static inline void raid6_after_sse16(raid6_sse16_save_t *s)
-{
-	unsigned int *rsa = SAREA(s);
-
-	asm volatile("movdqa %0,%%xmm0" : : "m" (rsa[0]));
-	asm volatile("movdqa %0,%%xmm1" : : "m" (rsa[4]));
-	asm volatile("movdqa %0,%%xmm2" : : "m" (rsa[8]));
-	asm volatile("movdqa %0,%%xmm3" : : "m" (rsa[12]));
-	asm volatile("movdqa %0,%%xmm4" : : "m" (rsa[16]));
-	asm volatile("movdqa %0,%%xmm5" : : "m" (rsa[20]));
-	asm volatile("movdqa %0,%%xmm6" : : "m" (rsa[24]));
-	asm volatile("movdqa %0,%%xmm7" : : "m" (rsa[28]));
-	asm volatile("movdqa %0,%%xmm8" : : "m" (rsa[32]));
-	asm volatile("movdqa %0,%%xmm9" : : "m" (rsa[36]));
-	asm volatile("movdqa %0,%%xmm10" : : "m" (rsa[40]));
-	asm volatile("movdqa %0,%%xmm11" : : "m" (rsa[44]));
-	asm volatile("movdqa %0,%%xmm12" : : "m" (rsa[48]));
-	asm volatile("movdqa %0,%%xmm13" : : "m" (rsa[52]));
-	asm volatile("movdqa %0,%%xmm14" : : "m" (rsa[56]));
-	asm volatile("movdqa %0,%%xmm15" : : "m" (rsa[60]));
-
-	raid6_put_fpu(s->cr0);
-}
-
-#endif /* __x86_64__ */
-
-/* User space test hack */
-#ifndef __KERNEL__
-static inline int cpuid_features(void)
-{
-	u32 eax = 1;
-	u32 ebx, ecx, edx;
-
-	asm volatile("cpuid" :
-		     "+a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx));
-
-	return edx;
-}
 #endif /* ndef __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from hpa@anvin.org are

origin.patch

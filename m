Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4493FEB0A
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633848; cv=none; b=KlECKdP569bRMtgduDgALiSzHkGkyjTfL4IXxWIs/aKYfxBg8Y51rznsCqRg/bkq87MSu5HpDipw7+ih9opbFKiFvFHUAyXqTVYtL1d60eEb4IuFQay5hk/Jm8KH+Xe+0VNfnYkbYXDSddBRRBOE2t6Lxqyl9Anw61MwaZrWyB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633848; c=relaxed/simple;
	bh=TQXt5MaDJPGXXVezmWACW5Ux+uIIaB0DlLGydCgVHlQ=;
	h=Date:To:From:Subject:Message-Id; b=Y1E/VrwhykCkjTdBryuFKAKOT20UbX+PaJfP1TbFw8GSlfkei/DcOWYoBgz2bE8m+wYG0ao9hWqfI9odAkUzeFwFJlF8JYXvdrYfXb9Lo2q7pp0ThwQQQTcj0soFcNpxodzRCdScE4OKLJSsKVcW6AIqHYtJ6HYzh8EWZ/x5ygk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JrkhQs6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JrkhQs6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD0DC19423;
	Fri, 27 Mar 2026 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633848;
	bh=TQXt5MaDJPGXXVezmWACW5Ux+uIIaB0DlLGydCgVHlQ=;
	h=Date:To:From:Subject:From;
	b=JrkhQs6c/SHdMc6fernAkl4/Gi+6gJpr/9PRiKGJwiLxfTahdOCoQkyaOcHOrFlfG
	 7hB7tC5YMa44FKP/lxOpgFUp/fVZ+PuL44NqR0iUhth5zsTVDwpgYKiHg3cyOM47gN
	 YtiYfxpMzLehvxtOFYcD70p1zzs7SseRYDlrbmOU=
Date: Fri, 27 Mar 2026 10:50:47 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-move-the-xor-code-to-lib-raid.patch added to mm-nonmm-unstable branch
Message-Id: <20260327175048.8CD0DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: move the XOR code to lib/raid/
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-move-the-xor-code-to-lib-raid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-move-the-xor-code-to-lib-raid.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: s390: move the XOR code to lib/raid/
Date: Fri, 27 Mar 2026 07:16:50 +0100

Move the optimized XOR into lib/raid and include it it in xor.ko instead
of unconditionally building it into the main kernel image.

Link: https://lkml.kernel.org/r/20260327061704.3707577-19-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Sterba <dsterba@suse.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/lib/Makefile  |    2 
 arch/s390/lib/xor.c     |  136 --------------------------------------
 lib/raid/xor/Makefile   |    1 
 lib/raid/xor/s390/xor.c |  134 +++++++++++++++++++++++++++++++++++++
 4 files changed, 136 insertions(+), 137 deletions(-)

--- a/arch/s390/lib/Makefile~s390-move-the-xor-code-to-lib-raid
+++ a/arch/s390/lib/Makefile
@@ -5,7 +5,7 @@
 
 lib-y += delay.o string.o uaccess.o find.o spinlock.o tishift.o
 lib-y += csum-partial.o
-obj-y += mem.o xor.o
+obj-y += mem.o
 lib-$(CONFIG_KPROBES) += probes.o
 lib-$(CONFIG_UPROBES) += probes.o
 obj-$(CONFIG_S390_KPROBES_SANITY_TEST) += test_kprobes_s390.o
diff --git a/arch/s390/lib/xor.c a/arch/s390/lib/xor.c
deleted file mode 100644
--- a/arch/s390/lib/xor.c
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Optimized xor_block operation for RAID4/5
- *
- * Copyright IBM Corp. 2016
- * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
- */
-
-#include <linux/types.h>
-#include <linux/export.h>
-#include <linux/raid/xor_impl.h>
-#include <asm/xor.h>
-
-static void xor_xc_2(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2)
-{
-	asm volatile(
-		"	aghi	%0,-1\n"
-		"	jm	3f\n"
-		"	srlg	0,%0,8\n"
-		"	ltgr	0,0\n"
-		"	jz	1f\n"
-		"0:	xc	0(256,%1),0(%2)\n"
-		"	la	%1,256(%1)\n"
-		"	la	%2,256(%2)\n"
-		"	brctg	0,0b\n"
-		"1:	exrl	%0,2f\n"
-		"	j	3f\n"
-		"2:	xc	0(1,%1),0(%2)\n"
-		"3:"
-		: "+a" (bytes), "+a" (p1), "+a" (p2)
-		: : "0", "cc", "memory");
-}
-
-static void xor_xc_3(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2,
-		     const unsigned long * __restrict p3)
-{
-	asm volatile(
-		"	aghi	%0,-1\n"
-		"	jm	4f\n"
-		"	srlg	0,%0,8\n"
-		"	ltgr	0,0\n"
-		"	jz	1f\n"
-		"0:	xc	0(256,%1),0(%2)\n"
-		"	xc	0(256,%1),0(%3)\n"
-		"	la	%1,256(%1)\n"
-		"	la	%2,256(%2)\n"
-		"	la	%3,256(%3)\n"
-		"	brctg	0,0b\n"
-		"1:	exrl	%0,2f\n"
-		"	exrl	%0,3f\n"
-		"	j	4f\n"
-		"2:	xc	0(1,%1),0(%2)\n"
-		"3:	xc	0(1,%1),0(%3)\n"
-		"4:"
-		: "+a" (bytes), "+a" (p1), "+a" (p2), "+a" (p3)
-		: : "0", "cc", "memory");
-}
-
-static void xor_xc_4(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2,
-		     const unsigned long * __restrict p3,
-		     const unsigned long * __restrict p4)
-{
-	asm volatile(
-		"	aghi	%0,-1\n"
-		"	jm	5f\n"
-		"	srlg	0,%0,8\n"
-		"	ltgr	0,0\n"
-		"	jz	1f\n"
-		"0:	xc	0(256,%1),0(%2)\n"
-		"	xc	0(256,%1),0(%3)\n"
-		"	xc	0(256,%1),0(%4)\n"
-		"	la	%1,256(%1)\n"
-		"	la	%2,256(%2)\n"
-		"	la	%3,256(%3)\n"
-		"	la	%4,256(%4)\n"
-		"	brctg	0,0b\n"
-		"1:	exrl	%0,2f\n"
-		"	exrl	%0,3f\n"
-		"	exrl	%0,4f\n"
-		"	j	5f\n"
-		"2:	xc	0(1,%1),0(%2)\n"
-		"3:	xc	0(1,%1),0(%3)\n"
-		"4:	xc	0(1,%1),0(%4)\n"
-		"5:"
-		: "+a" (bytes), "+a" (p1), "+a" (p2), "+a" (p3), "+a" (p4)
-		: : "0", "cc", "memory");
-}
-
-static void xor_xc_5(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2,
-		     const unsigned long * __restrict p3,
-		     const unsigned long * __restrict p4,
-		     const unsigned long * __restrict p5)
-{
-	asm volatile(
-		"	aghi	%0,-1\n"
-		"	jm	6f\n"
-		"	srlg	0,%0,8\n"
-		"	ltgr	0,0\n"
-		"	jz	1f\n"
-		"0:	xc	0(256,%1),0(%2)\n"
-		"	xc	0(256,%1),0(%3)\n"
-		"	xc	0(256,%1),0(%4)\n"
-		"	xc	0(256,%1),0(%5)\n"
-		"	la	%1,256(%1)\n"
-		"	la	%2,256(%2)\n"
-		"	la	%3,256(%3)\n"
-		"	la	%4,256(%4)\n"
-		"	la	%5,256(%5)\n"
-		"	brctg	0,0b\n"
-		"1:	exrl	%0,2f\n"
-		"	exrl	%0,3f\n"
-		"	exrl	%0,4f\n"
-		"	exrl	%0,5f\n"
-		"	j	6f\n"
-		"2:	xc	0(1,%1),0(%2)\n"
-		"3:	xc	0(1,%1),0(%3)\n"
-		"4:	xc	0(1,%1),0(%4)\n"
-		"5:	xc	0(1,%1),0(%5)\n"
-		"6:"
-		: "+a" (bytes), "+a" (p1), "+a" (p2), "+a" (p3), "+a" (p4),
-		  "+a" (p5)
-		: : "0", "cc", "memory");
-}
-
-struct xor_block_template xor_block_xc = {
-	.name = "xc",
-	.do_2 = xor_xc_2,
-	.do_3 = xor_xc_3,
-	.do_4 = xor_xc_4,
-	.do_5 = xor_xc_5,
-};
-EXPORT_SYMBOL(xor_block_xc);
--- a/lib/raid/xor/Makefile~s390-move-the-xor-code-to-lib-raid
+++ a/lib/raid/xor/Makefile
@@ -20,6 +20,7 @@ xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vm
 xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o riscv/xor-glue.o
 xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
+xor-$(CONFIG_S390)		+= s390/xor.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
diff --git a/lib/raid/xor/s390/xor.c a/lib/raid/xor/s390/xor.c
new file mode 100664
--- /dev/null
+++ a/lib/raid/xor/s390/xor.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Optimized xor_block operation for RAID4/5
+ *
+ * Copyright IBM Corp. 2016
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#include <linux/types.h>
+#include <linux/raid/xor_impl.h>
+#include <asm/xor.h>
+
+static void xor_xc_2(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2)
+{
+	asm volatile(
+		"	aghi	%0,-1\n"
+		"	jm	3f\n"
+		"	srlg	0,%0,8\n"
+		"	ltgr	0,0\n"
+		"	jz	1f\n"
+		"0:	xc	0(256,%1),0(%2)\n"
+		"	la	%1,256(%1)\n"
+		"	la	%2,256(%2)\n"
+		"	brctg	0,0b\n"
+		"1:	exrl	%0,2f\n"
+		"	j	3f\n"
+		"2:	xc	0(1,%1),0(%2)\n"
+		"3:"
+		: "+a" (bytes), "+a" (p1), "+a" (p2)
+		: : "0", "cc", "memory");
+}
+
+static void xor_xc_3(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2,
+		     const unsigned long * __restrict p3)
+{
+	asm volatile(
+		"	aghi	%0,-1\n"
+		"	jm	4f\n"
+		"	srlg	0,%0,8\n"
+		"	ltgr	0,0\n"
+		"	jz	1f\n"
+		"0:	xc	0(256,%1),0(%2)\n"
+		"	xc	0(256,%1),0(%3)\n"
+		"	la	%1,256(%1)\n"
+		"	la	%2,256(%2)\n"
+		"	la	%3,256(%3)\n"
+		"	brctg	0,0b\n"
+		"1:	exrl	%0,2f\n"
+		"	exrl	%0,3f\n"
+		"	j	4f\n"
+		"2:	xc	0(1,%1),0(%2)\n"
+		"3:	xc	0(1,%1),0(%3)\n"
+		"4:"
+		: "+a" (bytes), "+a" (p1), "+a" (p2), "+a" (p3)
+		: : "0", "cc", "memory");
+}
+
+static void xor_xc_4(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2,
+		     const unsigned long * __restrict p3,
+		     const unsigned long * __restrict p4)
+{
+	asm volatile(
+		"	aghi	%0,-1\n"
+		"	jm	5f\n"
+		"	srlg	0,%0,8\n"
+		"	ltgr	0,0\n"
+		"	jz	1f\n"
+		"0:	xc	0(256,%1),0(%2)\n"
+		"	xc	0(256,%1),0(%3)\n"
+		"	xc	0(256,%1),0(%4)\n"
+		"	la	%1,256(%1)\n"
+		"	la	%2,256(%2)\n"
+		"	la	%3,256(%3)\n"
+		"	la	%4,256(%4)\n"
+		"	brctg	0,0b\n"
+		"1:	exrl	%0,2f\n"
+		"	exrl	%0,3f\n"
+		"	exrl	%0,4f\n"
+		"	j	5f\n"
+		"2:	xc	0(1,%1),0(%2)\n"
+		"3:	xc	0(1,%1),0(%3)\n"
+		"4:	xc	0(1,%1),0(%4)\n"
+		"5:"
+		: "+a" (bytes), "+a" (p1), "+a" (p2), "+a" (p3), "+a" (p4)
+		: : "0", "cc", "memory");
+}
+
+static void xor_xc_5(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2,
+		     const unsigned long * __restrict p3,
+		     const unsigned long * __restrict p4,
+		     const unsigned long * __restrict p5)
+{
+	asm volatile(
+		"	aghi	%0,-1\n"
+		"	jm	6f\n"
+		"	srlg	0,%0,8\n"
+		"	ltgr	0,0\n"
+		"	jz	1f\n"
+		"0:	xc	0(256,%1),0(%2)\n"
+		"	xc	0(256,%1),0(%3)\n"
+		"	xc	0(256,%1),0(%4)\n"
+		"	xc	0(256,%1),0(%5)\n"
+		"	la	%1,256(%1)\n"
+		"	la	%2,256(%2)\n"
+		"	la	%3,256(%3)\n"
+		"	la	%4,256(%4)\n"
+		"	la	%5,256(%5)\n"
+		"	brctg	0,0b\n"
+		"1:	exrl	%0,2f\n"
+		"	exrl	%0,3f\n"
+		"	exrl	%0,4f\n"
+		"	exrl	%0,5f\n"
+		"	j	6f\n"
+		"2:	xc	0(1,%1),0(%2)\n"
+		"3:	xc	0(1,%1),0(%3)\n"
+		"4:	xc	0(1,%1),0(%4)\n"
+		"5:	xc	0(1,%1),0(%5)\n"
+		"6:"
+		: "+a" (bytes), "+a" (p1), "+a" (p2), "+a" (p3), "+a" (p4),
+		  "+a" (p5)
+		: : "0", "cc", "memory");
+}
+
+struct xor_block_template xor_block_xc = {
+	.name = "xc",
+	.do_2 = xor_xc_2,
+	.do_3 = xor_xc_3,
+	.do_4 = xor_xc_4,
+	.do_5 = xor_xc_5,
+};
_

Patches currently in -mm which might be from hch@lst.de are

xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch
arm-xor-remove-in_interrupt-handling.patch
arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch
um-xor-cleanup-xorh.patch
xor-move-to-lib-raid.patch
xor-small-cleanups.patch
xor-cleanup-registration-and-probing.patch
xor-split-xorh.patch
xor-remove-macro-abuse-for-xor-implementation-registrations.patch
xor-move-generic-implementations-out-of-asm-generic-xorh.patch
alpha-move-the-xor-code-to-lib-raid.patch
arm-move-the-xor-code-to-lib-raid.patch
arm64-move-the-xor-code-to-lib-raid.patch
loongarch-move-the-xor-code-to-lib-raid.patch
powerpc-move-the-xor-code-to-lib-raid.patch
riscv-move-the-xor-code-to-lib-raid.patch
sparc-move-the-xor-code-to-lib-raid.patch
s390-move-the-xor-code-to-lib-raid.patch
x86-move-the-xor-code-to-lib-raid.patch
xor-avoid-indirect-calls-for-arm64-optimized-ops.patch
xor-make-xorko-self-contained-in-lib-raid.patch
xor-add-a-better-public-api.patch
xor-add-a-better-public-api-2.patch
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch


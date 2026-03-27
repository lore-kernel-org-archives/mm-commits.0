Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885333F7AA3
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632710; cv=none; b=C0ebNJN687jCpqgRgJRyv7ZLiyiFFOIBuoVqisOWm29KT+XgymmPEQIgofVEMf9k0WK9CDSM1Ugg0jKlQmQhWB7662N4rtU4WXy+le/7u3X1j111f3c+eE7W1NgVUwjDHDlf5MZqCTq2fjDoyeL2CEWHwuqCWlLnojpIdXwV5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632710; c=relaxed/simple;
	bh=gCJwWqG585DmptXMJWAh7duayg9aodqSbJAwLhsh6DY=;
	h=Date:To:From:Subject:Message-Id; b=A7T5D3SzuACWfhOqp8kTx0usgNdfIC/vpaFJbWyCB3+DWtI5+dwuINwII4qpXsT/XG1K0B5EbsMOk2aY7YUKZyx1JZ3E6PL3431D0Nghkb7Ud9pW2lIRcfKA/6JssYsi2BaOOVdmE1rI9TfdbV1UeBOQULOKzkCBpnKRnaX85FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WeVeEkuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WeVeEkuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F063C19423;
	Fri, 27 Mar 2026 17:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632710;
	bh=gCJwWqG585DmptXMJWAh7duayg9aodqSbJAwLhsh6DY=;
	h=Date:To:From:Subject:From;
	b=WeVeEkuGukRdoMlhqNBB1RNf9nvlS+Cv5pZGnNkH4cI05RpGm9f+V+6GuiLn6WCbN
	 Df6yet9G/sebBFLF1wE8kACj80VOQBzqNpKeNqJFQKLlFe6ZV3ucTQ6ebPe0N20W+S
	 Ziloj2g63sEm+U7xIl6JWT/Jhd/RoROe8WOGQzjg=
Date: Fri, 27 Mar 2026 10:31:49 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xor-split-xorh.patch removed from -mm tree
Message-Id: <20260327173150.2F063C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: split xor.h
has been removed from the -mm tree.  Its filename was
     xor-split-xorh.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: split xor.h
Date: Tue, 24 Mar 2026 07:21:43 +0100

Keep xor.h for the public API, and split the struct xor_block_template
definition that is only needed by the xor.ko core and
architecture-specific optimizations into a separate xor_impl.h header.

Link: https://lkml.kernel.org/r/20260324062211.3216301-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
Cc: Heiko Carstens <hca@linux.ibm.com>
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

 arch/arm/lib/xor-neon.c       |    1 +
 arch/arm64/lib/xor-neon.c     |    1 +
 arch/s390/lib/xor.c           |    2 +-
 include/linux/raid/xor.h      |   22 +---------------------
 include/linux/raid/xor_impl.h |   25 +++++++++++++++++++++++++
 lib/raid/xor/xor-core.c       |    1 +
 6 files changed, 30 insertions(+), 22 deletions(-)

--- a/arch/arm64/lib/xor-neon.c~xor-split-xorh
+++ a/arch/arm64/lib/xor-neon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <linux/module.h>
 #include <asm/neon-intrinsics.h>
 
--- a/arch/arm/lib/xor-neon.c~xor-split-xorh
+++ a/arch/arm/lib/xor-neon.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <linux/module.h>
 
 MODULE_DESCRIPTION("NEON accelerated XOR implementation");
--- a/arch/s390/lib/xor.c~xor-split-xorh
+++ a/arch/s390/lib/xor.c
@@ -8,7 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/export.h>
-#include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <asm/xor.h>
 
 static void xor_xc_2(unsigned long bytes, unsigned long * __restrict p1,
--- a/include/linux/raid/xor.h~xor-split-xorh
+++ a/include/linux/raid/xor.h
@@ -7,24 +7,4 @@
 extern void xor_blocks(unsigned int count, unsigned int bytes,
 	void *dest, void **srcs);
 
-struct xor_block_template {
-        struct xor_block_template *next;
-        const char *name;
-        int speed;
-	void (*do_2)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_3)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_4)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_5)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-};
-
-#endif
+#endif /* _XOR_H */
diff --git a/include/linux/raid/xor_impl.h a/include/linux/raid/xor_impl.h
new file mode 100644
--- /dev/null
+++ a/include/linux/raid/xor_impl.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _XOR_IMPL_H
+#define _XOR_IMPL_H
+
+struct xor_block_template {
+	struct xor_block_template *next;
+	const char *name;
+	int speed;
+	void (*do_2)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict);
+	void (*do_3)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict);
+	void (*do_4)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict);
+	void (*do_5)(unsigned long, unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict,
+		     const unsigned long * __restrict);
+};
+
+#endif /* _XOR_IMPL_H */
--- a/lib/raid/xor/xor-core.c~xor-split-xorh
+++ a/lib/raid/xor/xor-core.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/raid/xor.h>
+#include <linux/raid/xor_impl.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
 #include <asm/xor.h>
_

Patches currently in -mm which might be from hch@lst.de are

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
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch


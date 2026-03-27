Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4CD3F99D2
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633912; cv=none; b=hpsj5SJGxt10e2jJ4yZJ3kAgawpmGvCngrE1pGSTERMYqZCIobSfz7SOql9VWqDKZJdN8EQndHOuHMcr2YKckE1WNJcUeYSPy/z221KP6JjExE/dydGhsNYxCm6Mnqtxxbo2lEiB7DmYi5LxvHrv/67HE9Sk5iuFiaJ2a/yVdJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633912; c=relaxed/simple;
	bh=BzVS2JbM3nFZ2gl5eDIZvoM8tYvz/0FBQK+xnslJeLg=;
	h=Date:To:From:Subject:Message-Id; b=hW92J4Qkhav14mW61v6cABZ+KVlUGbgSBc/X7D9cc0a/bVsieCeE6GR8Z+jiN03rNbHrSgTO1ZWmzUlslphJW1kHceRUKHK0ySOgWTeDMOlHMhwDnNfRsyxbDdih1U/BfOF7to6Rl/ANi16q+J9xovoq1ryzupTYfVs5iO8jAJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pVigbvaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pVigbvaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839FFC19423;
	Fri, 27 Mar 2026 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633912;
	bh=BzVS2JbM3nFZ2gl5eDIZvoM8tYvz/0FBQK+xnslJeLg=;
	h=Date:To:From:Subject:From;
	b=pVigbvaMoB267rz4ApvWu6amLJ4kTkFhddiiS8ee1Eu46O52ouQ92/LRrv88sc6ql
	 ndhxjcAKFJGzq9vi1WfE7bO1kiIrg7G72JzKtkxXFShJTciXlmmgShK8DbT61m9d+t
	 EXo1BuWyiThD+UCU+w3fS6HwAuKRN+BQ7YrpiXHY=
Date: Fri, 27 Mar 2026 10:51:51 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-add-a-kunit-test-case.patch added to mm-nonmm-unstable branch
Message-Id: <20260327175152.839FFC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: add a kunit test case
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-add-a-kunit-test-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-add-a-kunit-test-case.patch

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
Subject: xor: add a kunit test case
Date: Fri, 27 Mar 2026 07:17:00 +0100

Add a test case for the XOR routines loosely based on the CRC kunit
test.

Link: https://lkml.kernel.org/r/20260327061704.3707577-29-hch@lst.de
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

 lib/raid/.kunitconfig          |    3 
 lib/raid/Kconfig               |   11 +
 lib/raid/xor/Makefile          |    2 
 lib/raid/xor/tests/Makefile    |    3 
 lib/raid/xor/tests/xor_kunit.c |  187 +++++++++++++++++++++++++++++++
 5 files changed, 205 insertions(+), 1 deletion(-)

--- a/lib/raid/Kconfig~xor-add-a-kunit-test-case
+++ a/lib/raid/Kconfig
@@ -17,3 +17,14 @@ config XOR_BLOCKS_ARCH
 	default y if X86_32
 	default y if X86_64
 	bool
+
+config XOR_KUNIT_TEST
+	tristate "KUnit tests for xor_gen" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on XOR_BLOCKS
+	default KUNIT_ALL_TESTS
+	help
+	  Unit tests for the XOR library functions.
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
diff --git a/lib/raid/.kunitconfig a/lib/raid/.kunitconfig
new file mode 100644
--- /dev/null
+++ a/lib/raid/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_BTRFS_FS=y
+CONFIG_XOR_KUNIT_TEST=y
--- a/lib/raid/xor/Makefile~xor-add-a-kunit-test-case
+++ a/lib/raid/xor/Makefile
@@ -29,7 +29,7 @@ xor-$(CONFIG_SPARC64)		+= sparc/xor-spar
 xor-$(CONFIG_S390)		+= s390/xor.o
 xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
 xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
-
+obj-y				+= tests/
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
 CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
diff --git a/lib/raid/xor/tests/Makefile a/lib/raid/xor/tests/Makefile
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/tests/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_XOR_KUNIT_TEST) += xor_kunit.o
diff --git a/lib/raid/xor/tests/xor_kunit.c a/lib/raid/xor/tests/xor_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/tests/xor_kunit.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Unit test the XOR library functions.
+ *
+ * Copyright 2024 Google LLC
+ * Copyright 2026 Christoph Hellwig
+ *
+ * Based on the CRC tests by Eric Biggers <ebiggers@google.com>.
+ */
+#include <kunit/test.h>
+#include <linux/prandom.h>
+#include <linux/string_choices.h>
+#include <linux/vmalloc.h>
+#include <linux/raid/xor.h>
+
+#define XOR_KUNIT_SEED			42
+#define XOR_KUNIT_MAX_BYTES		16384
+#define XOR_KUNIT_MAX_BUFFERS		64
+#define XOR_KUNIT_NUM_TEST_ITERS	1000
+
+static struct rnd_state rng;
+static void *test_buffers[XOR_KUNIT_MAX_BUFFERS];
+static void *test_dest;
+static void *test_ref;
+static size_t test_buflen;
+
+static u32 rand32(void)
+{
+	return prandom_u32_state(&rng);
+}
+
+/* Reference implementation using dumb byte-wise XOR */
+static void xor_ref(void *dest, void **srcs, unsigned int src_cnt,
+		unsigned int bytes)
+{
+	unsigned int off, idx;
+	u8 *d = dest;
+
+	for (off = 0; off < bytes; off++) {
+		for (idx = 0; idx < src_cnt; idx++) {
+			u8 *src = srcs[idx];
+
+			d[off] ^= src[off];
+		}
+	}
+}
+
+/* Generate a random length that is a multiple of 512. */
+static unsigned int random_length(unsigned int max_length)
+{
+	return round_up((rand32() % max_length) + 1, 512);
+}
+
+/* Generate a random alignment that is a multiple of 64. */
+static unsigned int random_alignment(unsigned int max_alignment)
+{
+	return ((rand32() % max_alignment) + 1) & ~63;
+}
+
+static void xor_generate_random_data(void)
+{
+	int i;
+
+	prandom_bytes_state(&rng, test_dest, test_buflen);
+	memcpy(test_ref, test_dest, test_buflen);
+	for (i = 0; i < XOR_KUNIT_MAX_BUFFERS; i++)
+		prandom_bytes_state(&rng, test_buffers[i], test_buflen);
+}
+
+/* Test that xor_gen gives the same result as a reference implementation. */
+static void xor_test(struct kunit *test)
+{
+	void *aligned_buffers[XOR_KUNIT_MAX_BUFFERS];
+	size_t i;
+
+	for (i = 0; i < XOR_KUNIT_NUM_TEST_ITERS; i++) {
+		unsigned int nr_buffers =
+			(rand32() % XOR_KUNIT_MAX_BUFFERS) + 1;
+		unsigned int len = random_length(XOR_KUNIT_MAX_BYTES);
+		unsigned int max_alignment, align = 0;
+		void *buffers;
+
+		if (rand32() % 8 == 0)
+			/* Refresh the data occasionally. */
+			xor_generate_random_data();
+
+		/*
+		 * If we're not using the entire buffer size, inject randomize
+		 * alignment into the buffer.
+		 */
+		max_alignment = XOR_KUNIT_MAX_BYTES - len;
+		if (max_alignment == 0) {
+			buffers = test_buffers;
+		} else if (rand32() % 2 == 0) {
+			/* Use random alignments mod 64 */
+			int j;
+
+			for (j = 0; j < nr_buffers; j++)
+				aligned_buffers[j] = test_buffers[j] +
+					random_alignment(max_alignment);
+			buffers = aligned_buffers;
+			align = random_alignment(max_alignment);
+		} else {
+			/* Go up to the guard page, to catch buffer overreads */
+			int j;
+
+			align = test_buflen - len;
+			for (j = 0; j < nr_buffers; j++)
+				aligned_buffers[j] = test_buffers[j] + align;
+			buffers = aligned_buffers;
+		}
+
+		/*
+		 * Compute the XOR, and verify that it equals the XOR computed
+		 * by a simple byte-at-a-time reference implementation.
+		 */
+		xor_ref(test_ref + align, buffers, nr_buffers, len);
+		xor_gen(test_dest + align, buffers, nr_buffers, len);
+		KUNIT_EXPECT_MEMEQ_MSG(test, test_ref + align,
+				test_dest + align, len,
+				"Wrong result with buffers=%u, len=%u, unaligned=%s, at_end=%s",
+				nr_buffers, len,
+				str_yes_no(max_alignment),
+				str_yes_no(align + len == test_buflen));
+	}
+}
+
+static struct kunit_case xor_test_cases[] = {
+	KUNIT_CASE(xor_test),
+	{},
+};
+
+static int xor_suite_init(struct kunit_suite *suite)
+{
+	int i;
+
+	/*
+	 * Allocate the test buffer using vmalloc() with a page-aligned length
+	 * so that it is immediately followed by a guard page.  This allows
+	 * buffer overreads to be detected, even in assembly code.
+	 */
+	test_buflen = round_up(XOR_KUNIT_MAX_BYTES, PAGE_SIZE);
+	test_ref = vmalloc(test_buflen);
+	if (!test_ref)
+		return -ENOMEM;
+	test_dest = vmalloc(test_buflen);
+	if (!test_dest)
+		goto out_free_ref;
+	for (i = 0; i < XOR_KUNIT_MAX_BUFFERS; i++) {
+		test_buffers[i] = vmalloc(test_buflen);
+		if (!test_buffers[i])
+			goto out_free_buffers;
+	}
+
+	prandom_seed_state(&rng, XOR_KUNIT_SEED);
+	xor_generate_random_data();
+	return 0;
+
+out_free_buffers:
+	while (--i >= 0)
+		vfree(test_buffers[i]);
+	vfree(test_dest);
+out_free_ref:
+	vfree(test_ref);
+	return -ENOMEM;
+}
+
+static void xor_suite_exit(struct kunit_suite *suite)
+{
+	int i;
+
+	vfree(test_ref);
+	vfree(test_dest);
+	for (i = 0; i < XOR_KUNIT_MAX_BUFFERS; i++)
+		vfree(test_buffers[i]);
+}
+
+static struct kunit_suite xor_test_suite = {
+	.name		= "xor",
+	.test_cases	= xor_test_cases,
+	.suite_init	= xor_suite_init,
+	.suite_exit	= xor_suite_exit,
+};
+kunit_test_suite(xor_test_suite);
+
+MODULE_DESCRIPTION("Unit test for the XOR library functions");
+MODULE_LICENSE("GPL");
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


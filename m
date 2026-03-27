Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51CC3FBECF
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633773; cv=none; b=rySvw9bBliz3T/EtaaygqJCn2ulilHvHJEOn7mOuobBYMSP5SshxmcWkY1OAHQ2IP6/pVx7UmE4yULdifjGPZxnyIwbnAhVg09n81sZmmokAtPm0Bprv6f6L7JlT2Kc0RxdxxJUwZG7YLQpEJX1qN7jpG2f/mx/J3tYLV2fTr40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633773; c=relaxed/simple;
	bh=b0ljOgizgLvfT/hZmjxVytvBrquffbv/0NTkEa6ZCq8=;
	h=Date:To:From:Subject:Message-Id; b=sukfLehC4E3sxssaRkke3BUfcYidqQ/sw6DJHz9p46sdarUbZjuoUZn7vvSMZ5Jh4EHQXt48Zx7+HCsWhX0ygtHSolUgEgaH+acJiM+L3l3u20ZyolnzQQ5SjMJohng4Zdxz9BhfdQ12MJ9/nfTik5Mj9MbpEJoND2klrQ45cpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B+6tPCOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B+6tPCOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A77CC19423;
	Fri, 27 Mar 2026 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633773;
	bh=b0ljOgizgLvfT/hZmjxVytvBrquffbv/0NTkEa6ZCq8=;
	h=Date:To:From:Subject:From;
	b=B+6tPCOn+Qu7ctdOkNdc55Biq6BHpOIWHeHH0QlE2DbwptlvdxtDrdwD+R5wIdNnO
	 Or9FKUZNpMtCSvskg13dFRWfNoe3yYi9INrqHxYbCDn2zBWioSsgYoXOB5cdUhWdTY
	 7u+n0/uCxdVfXdCiQiMX8wby4Qmm0XvMOfyhKcMM=
Date: Fri, 27 Mar 2026 10:49:32 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-move-to-lib-raid.patch added to mm-nonmm-unstable branch
Message-Id: <20260327174933.3A77CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: move to lib/raid/
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-move-to-lib-raid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-move-to-lib-raid.patch

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
Subject: xor: move to lib/raid/
Date: Fri, 27 Mar 2026 07:16:37 +0100

Move the RAID XOR code to lib/raid/ as it has nothing to do with the
crypto API.

Link: https://lkml.kernel.org/r/20260327061704.3707577-6-hch@lst.de
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

 crypto/Kconfig          |    2 
 crypto/Makefile         |    1 
 crypto/xor.c            |  176 --------------------------------------
 lib/Kconfig             |    1 
 lib/Makefile            |    2 
 lib/raid/Kconfig        |    4 
 lib/raid/Makefile       |    3 
 lib/raid/xor/Makefile   |    5 +
 lib/raid/xor/xor-core.c |  176 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 190 insertions(+), 180 deletions(-)

--- a/crypto/Kconfig~xor-move-to-lib-raid
+++ a/crypto/Kconfig
@@ -2,8 +2,6 @@
 #
 # Generic algorithms support
 #
-config XOR_BLOCKS
-	tristate
 
 #
 # async_tx api: hardware offloaded memory transfer/transform support
--- a/crypto/Makefile~xor-move-to-lib-raid
+++ a/crypto/Makefile
@@ -196,7 +196,6 @@ obj-$(CONFIG_CRYPTO_ECRDSA) += ecrdsa_ge
 #
 # generic algorithms and the async_tx api
 #
-obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
 crypto_simd-y := simd.o
diff --git a/crypto/xor.c a/crypto/xor.c
deleted file mode 100644
--- a/crypto/xor.c
+++ /dev/null
@@ -1,176 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * xor.c : Multiple Devices driver for Linux
- *
- * Copyright (C) 1996, 1997, 1998, 1999, 2000,
- * Ingo Molnar, Matti Aarnio, Jakub Jelinek, Richard Henderson.
- *
- * Dispatch optimized RAID-5 checksumming functions.
- */
-
-#define BH_TRACE 0
-#include <linux/module.h>
-#include <linux/gfp.h>
-#include <linux/raid/xor.h>
-#include <linux/jiffies.h>
-#include <linux/preempt.h>
-#include <asm/xor.h>
-
-#ifndef XOR_SELECT_TEMPLATE
-#define XOR_SELECT_TEMPLATE(x) (x)
-#endif
-
-/* The xor routines to use.  */
-static struct xor_block_template *active_template;
-
-void
-xor_blocks(unsigned int src_count, unsigned int bytes, void *dest, void **srcs)
-{
-	unsigned long *p1, *p2, *p3, *p4;
-
-	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
-
-	p1 = (unsigned long *) srcs[0];
-	if (src_count == 1) {
-		active_template->do_2(bytes, dest, p1);
-		return;
-	}
-
-	p2 = (unsigned long *) srcs[1];
-	if (src_count == 2) {
-		active_template->do_3(bytes, dest, p1, p2);
-		return;
-	}
-
-	p3 = (unsigned long *) srcs[2];
-	if (src_count == 3) {
-		active_template->do_4(bytes, dest, p1, p2, p3);
-		return;
-	}
-
-	p4 = (unsigned long *) srcs[3];
-	active_template->do_5(bytes, dest, p1, p2, p3, p4);
-}
-EXPORT_SYMBOL(xor_blocks);
-
-/* Set of all registered templates.  */
-static struct xor_block_template *__initdata template_list;
-
-#ifndef MODULE
-static void __init do_xor_register(struct xor_block_template *tmpl)
-{
-	tmpl->next = template_list;
-	template_list = tmpl;
-}
-
-static int __init register_xor_blocks(void)
-{
-	active_template = XOR_SELECT_TEMPLATE(NULL);
-
-	if (!active_template) {
-#define xor_speed	do_xor_register
-		// register all the templates and pick the first as the default
-		XOR_TRY_TEMPLATES;
-#undef xor_speed
-		active_template = template_list;
-	}
-	return 0;
-}
-#endif
-
-#define BENCH_SIZE	4096
-#define REPS		800U
-
-static void __init
-do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
-{
-	int speed;
-	unsigned long reps;
-	ktime_t min, start, t0;
-
-	tmpl->next = template_list;
-	template_list = tmpl;
-
-	preempt_disable();
-
-	reps = 0;
-	t0 = ktime_get();
-	/* delay start until time has advanced */
-	while ((start = ktime_get()) == t0)
-		cpu_relax();
-	do {
-		mb(); /* prevent loop optimization */
-		tmpl->do_2(BENCH_SIZE, b1, b2);
-		mb();
-	} while (reps++ < REPS || (t0 = ktime_get()) == start);
-	min = ktime_sub(t0, start);
-
-	preempt_enable();
-
-	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
-	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
-	tmpl->speed = speed;
-
-	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
-}
-
-static int __init
-calibrate_xor_blocks(void)
-{
-	void *b1, *b2;
-	struct xor_block_template *f, *fastest;
-
-	fastest = XOR_SELECT_TEMPLATE(NULL);
-
-	if (fastest) {
-		printk(KERN_INFO "xor: automatically using best "
-				 "checksumming function   %-10s\n",
-		       fastest->name);
-		goto out;
-	}
-
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
-	if (!b1) {
-		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
-		return -ENOMEM;
-	}
-	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
-
-	/*
-	 * If this arch/cpu has a short-circuited selection, don't loop through
-	 * all the possible functions, just test the best one
-	 */
-
-#define xor_speed(templ)	do_xor_speed((templ), b1, b2)
-
-	printk(KERN_INFO "xor: measuring software checksum speed\n");
-	template_list = NULL;
-	XOR_TRY_TEMPLATES;
-	fastest = template_list;
-	for (f = fastest; f; f = f->next)
-		if (f->speed > fastest->speed)
-			fastest = f;
-
-	pr_info("xor: using function: %s (%d MB/sec)\n",
-	       fastest->name, fastest->speed);
-
-#undef xor_speed
-
-	free_pages((unsigned long)b1, 2);
-out:
-	active_template = fastest;
-	return 0;
-}
-
-static __exit void xor_exit(void) { }
-
-MODULE_DESCRIPTION("RAID-5 checksumming functions");
-MODULE_LICENSE("GPL");
-
-#ifndef MODULE
-/* when built-in xor.o must initialize before drivers/md/md.o */
-core_initcall(register_xor_blocks);
-#endif
-
-module_init(calibrate_xor_blocks);
-module_exit(xor_exit);
--- a/lib/Kconfig~xor-move-to-lib-raid
+++ a/lib/Kconfig
@@ -138,6 +138,7 @@ config TRACE_MMIO_ACCESS
 
 source "lib/crc/Kconfig"
 source "lib/crypto/Kconfig"
+source "lib/raid/Kconfig"
 
 config XXHASH
 	tristate
--- a/lib/Makefile~xor-move-to-lib-raid
+++ a/lib/Makefile
@@ -120,7 +120,7 @@ endif
 obj-$(CONFIG_DEBUG_INFO_REDUCED) += debug_info.o
 CFLAGS_debug_info.o += $(call cc-option, -femit-struct-debug-detailed=any)
 
-obj-y += math/ crc/ crypto/ tests/ vdso/
+obj-y += math/ crc/ crypto/ tests/ vdso/ raid/
 
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
diff --git a/lib/raid/Kconfig a/lib/raid/Kconfig
new file mode 100644
--- /dev/null
+++ a/lib/raid/Kconfig
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config XOR_BLOCKS
+	tristate
diff --git a/lib/raid/Makefile a/lib/raid/Makefile
new file mode 100644
--- /dev/null
+++ a/lib/raid/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y				+= xor/
diff --git a/lib/raid/xor/Makefile a/lib/raid/xor/Makefile
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_XOR_BLOCKS)	+= xor.o
+
+xor-y				+= xor-core.o
diff --git a/lib/raid/xor/xor-core.c a/lib/raid/xor/xor-core.c
new file mode 100664
--- /dev/null
+++ a/lib/raid/xor/xor-core.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * xor.c : Multiple Devices driver for Linux
+ *
+ * Copyright (C) 1996, 1997, 1998, 1999, 2000,
+ * Ingo Molnar, Matti Aarnio, Jakub Jelinek, Richard Henderson.
+ *
+ * Dispatch optimized RAID-5 checksumming functions.
+ */
+
+#define BH_TRACE 0
+#include <linux/module.h>
+#include <linux/gfp.h>
+#include <linux/raid/xor.h>
+#include <linux/jiffies.h>
+#include <linux/preempt.h>
+#include <asm/xor.h>
+
+#ifndef XOR_SELECT_TEMPLATE
+#define XOR_SELECT_TEMPLATE(x) (x)
+#endif
+
+/* The xor routines to use.  */
+static struct xor_block_template *active_template;
+
+void
+xor_blocks(unsigned int src_count, unsigned int bytes, void *dest, void **srcs)
+{
+	unsigned long *p1, *p2, *p3, *p4;
+
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+
+	p1 = (unsigned long *) srcs[0];
+	if (src_count == 1) {
+		active_template->do_2(bytes, dest, p1);
+		return;
+	}
+
+	p2 = (unsigned long *) srcs[1];
+	if (src_count == 2) {
+		active_template->do_3(bytes, dest, p1, p2);
+		return;
+	}
+
+	p3 = (unsigned long *) srcs[2];
+	if (src_count == 3) {
+		active_template->do_4(bytes, dest, p1, p2, p3);
+		return;
+	}
+
+	p4 = (unsigned long *) srcs[3];
+	active_template->do_5(bytes, dest, p1, p2, p3, p4);
+}
+EXPORT_SYMBOL(xor_blocks);
+
+/* Set of all registered templates.  */
+static struct xor_block_template *__initdata template_list;
+
+#ifndef MODULE
+static void __init do_xor_register(struct xor_block_template *tmpl)
+{
+	tmpl->next = template_list;
+	template_list = tmpl;
+}
+
+static int __init register_xor_blocks(void)
+{
+	active_template = XOR_SELECT_TEMPLATE(NULL);
+
+	if (!active_template) {
+#define xor_speed	do_xor_register
+		// register all the templates and pick the first as the default
+		XOR_TRY_TEMPLATES;
+#undef xor_speed
+		active_template = template_list;
+	}
+	return 0;
+}
+#endif
+
+#define BENCH_SIZE	4096
+#define REPS		800U
+
+static void __init
+do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
+{
+	int speed;
+	unsigned long reps;
+	ktime_t min, start, t0;
+
+	tmpl->next = template_list;
+	template_list = tmpl;
+
+	preempt_disable();
+
+	reps = 0;
+	t0 = ktime_get();
+	/* delay start until time has advanced */
+	while ((start = ktime_get()) == t0)
+		cpu_relax();
+	do {
+		mb(); /* prevent loop optimization */
+		tmpl->do_2(BENCH_SIZE, b1, b2);
+		mb();
+	} while (reps++ < REPS || (t0 = ktime_get()) == start);
+	min = ktime_sub(t0, start);
+
+	preempt_enable();
+
+	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
+	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
+	tmpl->speed = speed;
+
+	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
+}
+
+static int __init
+calibrate_xor_blocks(void)
+{
+	void *b1, *b2;
+	struct xor_block_template *f, *fastest;
+
+	fastest = XOR_SELECT_TEMPLATE(NULL);
+
+	if (fastest) {
+		printk(KERN_INFO "xor: automatically using best "
+				 "checksumming function   %-10s\n",
+		       fastest->name);
+		goto out;
+	}
+
+	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	if (!b1) {
+		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
+		return -ENOMEM;
+	}
+	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
+
+	/*
+	 * If this arch/cpu has a short-circuited selection, don't loop through
+	 * all the possible functions, just test the best one
+	 */
+
+#define xor_speed(templ)	do_xor_speed((templ), b1, b2)
+
+	printk(KERN_INFO "xor: measuring software checksum speed\n");
+	template_list = NULL;
+	XOR_TRY_TEMPLATES;
+	fastest = template_list;
+	for (f = fastest; f; f = f->next)
+		if (f->speed > fastest->speed)
+			fastest = f;
+
+	pr_info("xor: using function: %s (%d MB/sec)\n",
+	       fastest->name, fastest->speed);
+
+#undef xor_speed
+
+	free_pages((unsigned long)b1, 2);
+out:
+	active_template = fastest;
+	return 0;
+}
+
+static __exit void xor_exit(void) { }
+
+MODULE_DESCRIPTION("RAID-5 checksumming functions");
+MODULE_LICENSE("GPL");
+
+#ifndef MODULE
+/* when built-in xor.o must initialize before drivers/md/md.o */
+core_initcall(register_xor_blocks);
+#endif
+
+module_init(calibrate_xor_blocks);
+module_exit(xor_exit);
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


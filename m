Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4458934EEE1
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198494; cv=none; b=adn9lDUhVAFav26Xh9B4Po0jbtaWV/hr4QrefFBd+PyDTvDwkzpVudLoamUzj8VHmPXIk9lCqYTJLZtWOPYcFWprJjj0CAW5JxcOn2Id0y/xXGwdLY5EmE1+1ib/7txda6alQKCFpCwnnboumZdB1OVnpDSQEvlvsZyR8iq8t9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198494; c=relaxed/simple;
	bh=zrI0AZWrkgJXNUpRIUIGrFTuq5fsY3GyYoj22yBNLAY=;
	h=Date:To:From:Subject:Message-Id; b=bCqEfLr8bgAfM9QCGW2YpKRaeysyUbpIqajqY4oaoCK85DVfCX2RcqNZfTQQBvvUjtmTClj4HC2mzPU/ndUkakQnR8baM2kK86rI9UDRE3sOYw9cCu961rX2RD5VYTcVryOlfrffqCGiFiCG8MLK89bh/QQowH85QZqlU4bGN98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V0YPSZlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V0YPSZlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CEEC4CEF7;
	Fri,  3 Apr 2026 06:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198494;
	bh=zrI0AZWrkgJXNUpRIUIGrFTuq5fsY3GyYoj22yBNLAY=;
	h=Date:To:From:Subject:From;
	b=V0YPSZlxefnLa3Vwc4ys9tZ74AufiqvQN4GeyOz49KEhxi77hj+HK7muKCfK0gbZl
	 m2xr6lshbe4GtH9YKUZ6AKQrc0E7ERHOSmgN4eMKChHuBx3ejtzAp9vFNbmb5mGUQV
	 Sn6wtNo1CULmqxAz8n6JlpHWxI4INJGcLybptigE=
Date: Thu, 02 Apr 2026 23:41:33 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-move-to-lib-raid.patch removed from -mm tree
Message-Id: <20260403064134.05CEEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: move to lib/raid/
has been removed from the -mm tree.  Its filename was
     xor-move-to-lib-raid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: move to lib/raid/
Date: Fri, 27 Mar 2026 07:16:37 +0100

Move the RAID XOR code to lib/raid/ as it has nothing to do with the
crypto API.

Link: https://lkml.kernel.org/r/20260327061704.3707577-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9053637104F
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632708; cv=none; b=YzSPQndAvb0WWym3LJs5OPRU5ywhXv+Bf5DDz3QxJCGGJRM6TvokgkifyKU/MqgGZfVlYP8UuFToNIw/TeeARI+qwo8JoQsQ6fpqNoyNU7QGB49WHXp4GW4ZT1ERAyUJQBwHfKCiy8wXRh8ni6oL7zkB2WN6l5Op1+QKFwHQ9uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632708; c=relaxed/simple;
	bh=6fKbNdpcoyjwynZN1F25qf5T2czMlBCxvQM6lNZQnDg=;
	h=Date:To:From:Subject:Message-Id; b=HoSxD9Wn6+ua8BgGEywW7e85L/rk+DfipKB8vjh253GS5e53nj+0DZsXe8M8xaFfEu7mrzrQVEF3qcV7sziKXrwARKJCZgEDYfKdpRlEYYvNWG1nssaheHKbNZEnqW7tGl9Uc1JZP6ZYGQzshDSu2E08eupwlp/jbBp9gzdgweU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FarXH6dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FarXH6dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C44BC19424;
	Fri, 27 Mar 2026 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632708;
	bh=6fKbNdpcoyjwynZN1F25qf5T2czMlBCxvQM6lNZQnDg=;
	h=Date:To:From:Subject:From;
	b=FarXH6dkhhKRSD+i8Owyp0SR4RTDlflRoYTpuGH/TtB+IziXUOWmBcS7bnAubNwtA
	 IGzsfRs/9R3AtYwpNq5ZSz+EqNP0/F+Fx6Hlqeqlh5B0iywhlR1CHq9B4NeGNNePx3
	 +TYMaQoMwHIUW15k95PbcQo8jSyc1R5/WRiKx2J8=
Date: Fri, 27 Mar 2026 10:31:47 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xor-cleanup-registration-and-probing.patch removed from -mm tree
Message-Id: <20260327173148.2C44BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: cleanup registration and probing
has been removed from the -mm tree.  Its filename was
     xor-cleanup-registration-and-probing.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: cleanup registration and probing
Date: Tue, 24 Mar 2026 07:21:42 +0100

Originally, the XOR code benchmarked all algorithms at load time, but it
has since then been hacked multiple times to allow forcing an algorithm,
and then commit 524ccdbdfb52 ("crypto: xor - defer load time benchmark to
a later time") changed the logic to a two-step process or registration and
benchmarking, but only when built-in.

Rework this, so that the XOR_TRY_TEMPLATES macro magic now always just
deals with adding the templates to the list, and benchmarking is always
done in a second pass; for modular builds from module_init, and for the
built-in case using a separate init call level.

Link: https://lkml.kernel.org/r/20260324062211.3216301-7-hch@lst.de
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

 lib/raid/xor/xor-core.c |   98 ++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 50 deletions(-)

--- a/lib/raid/xor/xor-core.c~xor-cleanup-registration-and-probing
+++ a/lib/raid/xor/xor-core.c
@@ -52,29 +52,14 @@ EXPORT_SYMBOL(xor_blocks);
 
 /* Set of all registered templates.  */
 static struct xor_block_template *__initdata template_list;
+static bool __initdata xor_forced = false;
 
-#ifndef MODULE
 static void __init do_xor_register(struct xor_block_template *tmpl)
 {
 	tmpl->next = template_list;
 	template_list = tmpl;
 }
 
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
 #define BENCH_SIZE	4096
 #define REPS		800U
 
@@ -85,9 +70,6 @@ do_xor_speed(struct xor_block_template *
 	unsigned long reps;
 	ktime_t min, start, t0;
 
-	tmpl->next = template_list;
-	template_list = tmpl;
-
 	preempt_disable();
 
 	reps = 0;
@@ -111,63 +93,79 @@ do_xor_speed(struct xor_block_template *
 	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
 }
 
-static int __init
-calibrate_xor_blocks(void)
+static int __init calibrate_xor_blocks(void)
 {
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	fastest = XOR_SELECT_TEMPLATE(NULL);
-
-	if (fastest) {
-		printk(KERN_INFO "xor: automatically using best "
-				 "checksumming function   %-10s\n",
-		       fastest->name);
-		goto out;
-	}
+	if (xor_forced)
+		return 0;
 
 	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
 	if (!b1) {
-		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
+		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
 
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
+	pr_info("xor: measuring software checksum speed\n");
 	fastest = template_list;
-	for (f = fastest; f; f = f->next)
+	for (f = template_list; f; f = f->next) {
+		do_xor_speed(f, b1, b2);
 		if (f->speed > fastest->speed)
 			fastest = f;
-
+	}
+	active_template = fastest;
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
+	free_pages((unsigned long)b1, 2);
+	return 0;
+}
+
+static int __init xor_init(void)
+{
+	/*
+	 * If this arch/cpu has a short-circuited selection, don't loop through
+	 * all the possible functions, just use the best one.
+	 */
+	active_template = XOR_SELECT_TEMPLATE(NULL);
+	if (active_template) {
+		pr_info("xor: automatically using best checksumming function   %-10s\n",
+			active_template->name);
+		xor_forced = true;
+		return 0;
+	}
+
+#define xor_speed	do_xor_register
+	XOR_TRY_TEMPLATES;
 #undef xor_speed
 
-	free_pages((unsigned long)b1, 2);
-out:
-	active_template = fastest;
+#ifdef MODULE
+	return calibrate_xor_blocks();
+#else
+	/*
+	 * Pick the first template as the temporary default until calibration
+	 * happens.
+	 */
+	active_template = template_list;
 	return 0;
+#endif
 }
 
-static __exit void xor_exit(void) { }
+static __exit void xor_exit(void)
+{
+}
 
 MODULE_DESCRIPTION("RAID-5 checksumming functions");
 MODULE_LICENSE("GPL");
 
+/*
+ * When built-in we must register the default template before md, but we don't
+ * want calibration to run that early as that would delay the boot process.
+ */
 #ifndef MODULE
-/* when built-in xor.o must initialize before drivers/md/md.o */
-core_initcall(register_xor_blocks);
+__initcall(calibrate_xor_blocks);
 #endif
-
-module_init(calibrate_xor_blocks);
+core_initcall(xor_init);
 module_exit(xor_exit);
_

Patches currently in -mm which might be from hch@lst.de are

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
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch


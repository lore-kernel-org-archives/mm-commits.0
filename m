Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930333F99ED
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632746; cv=none; b=gkpA8hkPVJo3M4kzT1v/bdgOMpUir36zdYR3d7SZ5ShXcJ1aWAJTS6KYRnr3eFFqVX6FSCzWP4J3bKFYHCj70EXADqLPA0p/vjRtnxcc3s3S9VZsjt39Dhknu2nbhC8HV86ysbqMJw+GvgUyQ3PwnN5+jM6AzUQXDkmYFC9uYNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632746; c=relaxed/simple;
	bh=bboqRUo+YbyCqvDqcDVXhwfL1Knhubiu78fJpgjPGyQ=;
	h=Date:To:From:Subject:Message-Id; b=VQJ8HQzLxmvO3LowUJoMsgiycC7Ppk9OC26BZ4UIhuXTH3AHRX/IRNlX6bKjV1h/ojBdSeMz8Tn4ZD6lbE/4GcpU4fJ5b8JkioCY4rrqcwDAO7iEewtT2sdXDZD+eWXR4vRErUQ4hhUsNhjGvLIZ+WvX8VZ1jQkA2IvZ4Ha4jkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bStBByd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bStBByd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B77C19423;
	Fri, 27 Mar 2026 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632746;
	bh=bboqRUo+YbyCqvDqcDVXhwfL1Knhubiu78fJpgjPGyQ=;
	h=Date:To:From:Subject:From;
	b=bStBByd4kGFZxDWLNGEp+8hs5nWf2aqH1aGXvGNJLBRD3JtV8VpNn3g8BpGX/ueoy
	 xT0rcFj4PH0dg3E6LvhjPleCLY9iazlmZkqsWNhe9Ay/wU0jsOb3MY4itarepiehE3
	 yQq1U0ZuL43iyvQr1Oo0VG292gj1KzstKPgfK9yA=
Date: Fri, 27 Mar 2026 10:32:25 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xor-use-static_call-for-xor_gen.patch removed from -mm tree
Message-Id: <20260327173226.15B77C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: use static_call for xor_gen
has been removed from the -mm tree.  Its filename was
     xor-use-static_call-for-xor_gen.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: use static_call for xor_gen
Date: Tue, 24 Mar 2026 07:22:01 +0100

Avoid the indirect call for xor_generation by using a static_call.

Link: https://lkml.kernel.org/r/20260324062211.3216301-26-hch@lst.de
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

 lib/raid/xor/xor-core.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/lib/raid/xor/xor-core.c~xor-use-static_call-for-xor_gen
+++ a/lib/raid/xor/xor-core.c
@@ -11,10 +11,10 @@
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
+#include <linux/static_call.h>
 #include "xor_impl.h"
 
-/* The xor routine to use.  */
-static struct xor_block_template *active_template;
+DEFINE_STATIC_CALL_NULL(xor_gen_impl, *xor_block_8regs.xor_gen);
 
 /**
  * xor_gen - generate RAID-style XOR information
@@ -36,13 +36,13 @@ void xor_gen(void *dest, void **srcs, un
 	lockdep_assert_preemption_enabled();
 	WARN_ON_ONCE(bytes & 511);
 
-	active_template->xor_gen(dest, srcs, src_cnt, bytes);
+	static_call(xor_gen_impl)(dest, srcs, src_cnt, bytes);
 }
 EXPORT_SYMBOL(xor_gen);
 
 /* Set of all registered templates.  */
 static struct xor_block_template *__initdata template_list;
-static bool __initdata xor_forced = false;
+static struct xor_block_template *forced_template;
 
 /**
  * xor_register - register a XOR template
@@ -68,7 +68,7 @@ void __init xor_register(struct xor_bloc
  */
 void __init xor_force(struct xor_block_template *tmpl)
 {
-	active_template = tmpl;
+	forced_template = tmpl;
 }
 
 #define BENCH_SIZE	4096
@@ -110,7 +110,7 @@ static int __init calibrate_xor_blocks(v
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	if (xor_forced)
+	if (forced_template)
 		return 0;
 
 	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
@@ -127,7 +127,7 @@ static int __init calibrate_xor_blocks(v
 		if (f->speed > fastest->speed)
 			fastest = f;
 	}
-	active_template = fastest;
+	static_call_update(xor_gen_impl, fastest->xor_gen);
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
@@ -155,10 +155,10 @@ static int __init xor_init(void)
 	 * If this arch/cpu has a short-circuited selection, don't loop through
 	 * all the possible functions, just use the best one.
 	 */
-	if (active_template) {
+	if (forced_template) {
 		pr_info("xor: automatically using best checksumming function   %-10s\n",
-			active_template->name);
-		xor_forced = true;
+			forced_template->name);
+		static_call_update(xor_gen_impl, forced_template->xor_gen);
 		return 0;
 	}
 
@@ -169,7 +169,7 @@ static int __init xor_init(void)
 	 * Pick the first template as the temporary default until calibration
 	 * happens.
 	 */
-	active_template = template_list;
+	static_call_update(xor_gen_impl, template_list->xor_gen);
 	return 0;
 #endif
 }
_

Patches currently in -mm which might be from hch@lst.de are

xor-add-a-kunit-test-case.patch


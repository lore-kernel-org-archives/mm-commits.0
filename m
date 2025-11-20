Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF43232FA11
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676272; cv=none; b=dZJPYrTnGdbA6pKWE+uHCM8XNpmcRdXh9oEAkVaZSqGKlJ/jjy2dPt71SG/JA0qUPCZ8wqHvpNXwzLwZ9cXCjpKUgTLVLbmoPZulcvuvaw5rvl374AA3Y8jLsqWrBbG4nrLSAxg0vh9KH+Bo6P8W9ZNaWhsAOrK6mBRoIcZBCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676272; c=relaxed/simple;
	bh=/GZ4N+Fi80FxhPADkqbQ4UmCpNXZMmBgA9JdsJvVFqI=;
	h=Date:To:From:Subject:Message-Id; b=m4VlB76ctjWIsxeKWwnFAJgIQZRIJGWsfq1Yg8q9Cigb9ZBwCilNJX9+WDDZ39shY9lNXlcHCvfk+o6JGMzEPeyWKZTWqri5xZ/oZs70kRaaVUpDtGclnCPBy/Omfs1RVff7XGyqGELDtR7y0/uvrNOXg1PIqJai3hFXCK/KWeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xP6V29SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xP6V29SX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41519C4CEF1;
	Thu, 20 Nov 2025 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676272;
	bh=/GZ4N+Fi80FxhPADkqbQ4UmCpNXZMmBgA9JdsJvVFqI=;
	h=Date:To:From:Subject:From;
	b=xP6V29SXdU+MQRZHtnrPeCODSUXRNj+jXWwRVk53Vyz4OVIz0NU820Dcc89KsY58K
	 fct80DFyw/cRudX8Tym3Z5ule/zOUKJh7QQhgbJPpb5A2mjlWpn60PAvyrayksryJa
	 kPUkPqH+AaHDLBZw7Q3m/xfvxk3mmNSEGz8L3EDw=
Date: Thu, 20 Nov 2025 14:04:31 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch removed from -mm tree
Message-Id: <20251120220432.41519C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_mul_u64_u64_div_u64(): test the 32bit code on 64bit
has been removed from the -mm tree.  Its filename was
     lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <david.laight.linux@gmail.com>
Subject: lib: test_mul_u64_u64_div_u64(): test the 32bit code on 64bit
Date: Wed, 5 Nov 2025 20:10:35 +0000

There are slight differences in the mul_u64_add_u64_div_u64() code between
32bit and 64bit systems.

Compile and test the 32bit version on 64bit hosts for better test
coverage.

Link: https://lkml.kernel.org/r/20251105201035.64043-10-david.laight.linux@gmail.com
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Nicolas Pitre <npitre@baylibre.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/test_mul_u64_u64_div_u64.c |   29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/lib/math/test_mul_u64_u64_div_u64.c~lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit
+++ a/lib/math/test_mul_u64_u64_div_u64.c
@@ -74,6 +74,10 @@ done
  */
 
 static u64 test_mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d);
+#if __LONG_WIDTH__ >= 64
+#define TEST_32BIT_DIV
+static u64 test_mul_u64_add_u64_div_u64_32bit(u64 a, u64 b, u64 c, u64 d);
+#endif
 
 static int __init test_run(unsigned int fn_no, const char *fn_name)
 {
@@ -100,6 +104,12 @@ static int __init test_run(unsigned int
 			result = test_mul_u64_add_u64_div_u64(a, b, 0, d);
 			result_up = test_mul_u64_add_u64_div_u64(a, b, d - 1, d);
 			break;
+#ifdef TEST_32BIT_DIV
+		case 2:
+			result = test_mul_u64_add_u64_div_u64_32bit(a, b, 0, d);
+			result_up = test_mul_u64_add_u64_div_u64_32bit(a, b, d - 1, d);
+			break;
+#endif
 		}
 
 		tests += 2;
@@ -131,6 +141,10 @@ static int __init test_init(void)
 		return -EINVAL;
 	if (test_run(1, "test_mul_u64_u64_div_u64"))
 		return -EINVAL;
+#ifdef TEST_32BIT_DIV
+	if (test_run(2, "test_mul_u64_u64_div_u64_32bit"))
+		return -EINVAL;
+#endif
 	return 0;
 }
 
@@ -153,6 +167,21 @@ static void __exit test_exit(void)
 
 #include "div64.c"
 
+#ifdef TEST_32BIT_DIV
+/* Recompile the generic code for 32bit long */
+#undef test_mul_u64_add_u64_div_u64
+#define test_mul_u64_add_u64_div_u64 test_mul_u64_add_u64_div_u64_32bit
+#undef BITS_PER_ITER
+#define BITS_PER_ITER 16
+
+#define mul_u64_u64_add_u64 mul_u64_u64_add_u64_32bit
+#undef mul_u64_long_add_u64
+#undef add_u64_long
+#undef mul_add
+
+#include "div64.c"
+#endif
+
 module_init(test_init);
 module_exit(test_exit);
 
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are



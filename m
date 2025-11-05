Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCCE2F28FC
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382670; cv=none; b=tA80rVZsIhy3Dd1AkTvJBnsGzfHojM7xld8CsKix4m8Qe6c14+mVrxA/qosv4tMJ9r9VxOfkADlL4WeJcs0AuAVaeqcqywFUXcxs/ce/JSPGsr/o/mC3vAjtTYyLrby0lIAGkofqFb1IJPS0nfFXQqb+2XcS7QGgO0yfHgSYsws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382670; c=relaxed/simple;
	bh=nl05+F0odhnojIyIuGWzf0BaIByCSqt5a0oBz9BlJmw=;
	h=Date:To:From:Subject:Message-Id; b=fUzeAbYaQiEHDoIEnyFbum9iZijxlK1HYE6ajk8ZKW15kh1drcSLiQ2PoyUDvg0mLclBSFnBZMjL1/TepJJ7f16Su5AkGtv/KcTeiY0vHGGZzkM+B92xfcNoOIplQVrtQPfvs4e8O6IsV3GYY+MPLPMkBG3AISC1fuBi4PR7VkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KU89fcTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KU89fcTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA09C4CEF5;
	Wed,  5 Nov 2025 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382670;
	bh=nl05+F0odhnojIyIuGWzf0BaIByCSqt5a0oBz9BlJmw=;
	h=Date:To:From:Subject:From;
	b=KU89fcTs4r3wgYGgkeDykuFA2Cg5VlEyV+efG3nPy70ozI/3D45UQbuXrcZo9jwRc
	 K3kHCali91K1cHJH6hmbvjctwY0DWZeq/nSutUOXEVgmwC4sq5bDpI1Zh9OptEzp8L
	 wht/a6n3grQ92o0XDBoajV6X3dDeT00Vv1j9DmFg=
Date: Wed, 05 Nov 2025 14:44:29 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224430.3EA09C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_mul_u64_u64_div_u64(): test the 32bit code on 64bit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch
lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch
lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch
lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch
lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch
lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch
lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch
lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch


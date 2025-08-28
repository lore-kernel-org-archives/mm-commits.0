Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A6F13DDAA;
	Thu, 28 Aug 2025 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359977; cv=none; b=C094vMAGwrRQTt623ER19WHTnH/KlmhW8egDR34AfHZviotqaa15k6tRDxW5z0nyhA0jAm2Ghawi+wc2p9ziAc2XGGRzQM6HyWlOPgZLG30XQBp7pA+MKph+poSRjknjJrj0wlRo4s7B99lTymYOBiasnk9yopO4Otjm+keGM6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359977; c=relaxed/simple;
	bh=3fOb2+o6PmfqNXMY3ECAyyOTBDI7BBROTvDBvqLQuj4=;
	h=Date:To:From:Subject:Message-Id; b=WadYqRAnZqNVAFnuNgyaVQfb831UwOIEjgzkLbg1sknH2HoJUw58cM588sOrAkfw74TBNbCtwuW9dwBeNF8J+S7MJwsW2ysihUGBlHQGveF/si8bH6INqlJ6xBx57GCXJWD8rAr+dcjHhhWYVYP3CfNAnuQUBEqRJqpK15vhPqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ajdeyGw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ajdeyGw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1155C4CEEB;
	Thu, 28 Aug 2025 05:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359976;
	bh=3fOb2+o6PmfqNXMY3ECAyyOTBDI7BBROTvDBvqLQuj4=;
	h=Date:To:From:Subject:From;
	b=ajdeyGw/ZsAhbMcMNfdF3l2MH3LkPblt9FVWi38FAbGLkKYS9s4UUAr/j89Yo5RvC
	 pf1qSY3W+edQ1tx/ecKoiH+weAW5andwZw/ToWplURZlx57pYQBaxE6nSY5F4fmUOt
	 Hwj0aoQpwSJdu5o29jFxmJoT7+jN5PQzYhQRoTUw=
Date: Wed, 27 Aug 2025 22:46:16 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch removed from -mm tree
Message-Id: <20250828054616.C1155C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: kasan_test: disable fortify string checker on kasan_strings() test
has been removed from the -mm tree.  Its filename was
     kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kunit: kasan_test: disable fortify string checker on kasan_strings() test
Date: Fri, 1 Aug 2025 13:02:36 +0100

Similar to commit 09c6304e38e4 ("kasan: test: fix compatibility with
FORTIFY_SOURCE") the kernel is panicing in kasan_string().

This is due to the `src` and `ptr` not being hidden from the optimizer
which would disable the runtime fortify string checker.

Call trace:
  __fortify_panic+0x10/0x20 (P)
  kasan_strings+0x980/0x9b0
  kunit_try_run_case+0x68/0x190
  kunit_generic_run_threadfn_adapter+0x34/0x68
  kthread+0x1c4/0x228
  ret_from_fork+0x10/0x20
 Code: d503233f a9bf7bfd 910003fd 9424b243 (d4210000)
 ---[ end trace 0000000000000000 ]---
 note: kunit_try_catch[128] exited with irqs disabled
 note: kunit_try_catch[128] exited with preempt_count 1
     # kasan_strings: try faulted: last
** replaying previous printk message **
     # kasan_strings: try faulted: last line seen mm/kasan/kasan_test_c.c:1600
     # kasan_strings: internal error occurred preventing test case from running: -4

Link: https://lkml.kernel.org/r/20250801120236.2962642-1-yeoreum.yun@arm.com
Fixes: 73228c7ecc5e ("KASAN: port KASAN Tests to KUnit")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test
+++ a/mm/kasan/kasan_test_c.c
@@ -1578,9 +1578,11 @@ static void kasan_strings(struct kunit *
 
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	OPTIMIZER_HIDE_VAR(ptr);
 
 	src = kmalloc(KASAN_GRANULE_SIZE, GFP_KERNEL | __GFP_ZERO);
 	strscpy(src, "f0cacc1a0000000", KASAN_GRANULE_SIZE);
+	OPTIMIZER_HIDE_VAR(src);
 
 	/*
 	 * Make sure that strscpy() does not trigger KASAN if it overreads into
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kasan-hw-tags-introduce-kasanwrite_only-option.patch
kasan-apply-write-only-mode-in-kasan-kunit-testcases.patch


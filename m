Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F908DF71;
	Fri,  1 Aug 2025 20:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754079264; cv=none; b=G7CtdojoCWOhhN1YaXuGjgkUbhc7L2yRWpqUAIcOm8ZQzSUjL0GbcxQAF1j0fOpv6wDZSYjxU2cDRJ/ejrQsWuHnuJM5gg5Mz4zCxdXfJL1LFfi3A4+vx4gJQZZs4vPMfyyz5Wr3k1h0mWMjafIq+mHCJjIX2cUDJcNCgBRXEJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754079264; c=relaxed/simple;
	bh=d2XZyV+/gWsZx/bSr/1trDF83S2snHbP0P55uU9+S5Q=;
	h=Date:To:From:Subject:Message-Id; b=u/Lg19bGJAeY5ThEEfExQEb7z6ynHXvx21xayHdPii9WCqPBw98e4VFlSkuIyx2JvJohtBojBin1vtNA0USjEPxcD01XUfRPp8Wep2FHTlIPD61BB7Jcjz/ViLVmdcGoyU6/oL/Xw7SNpdj6BLVcJ7UWwvLLgs91VdtwGY0ljr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aiwa2GL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aiwa2GL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD0EC4CEE7;
	Fri,  1 Aug 2025 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754079264;
	bh=d2XZyV+/gWsZx/bSr/1trDF83S2snHbP0P55uU9+S5Q=;
	h=Date:To:From:Subject:From;
	b=Aiwa2GL5/tx3Sec5ZB7gCySzFABtxOy50miN4+URgVTFRJ3eGNGVQbN4cO1um4nHz
	 1C8lw4Zcuc37g6y7K5XGIm66svEw9ujNUVoDD4FNhdsBtLDrN8W6sZxhKdmPPFlige
	 U+DxVhjHewl1dSVuk/v180V88FLeHY1mrOODgqiY=
Date: Fri, 01 Aug 2025 13:14:23 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20250801201423.EDD0EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: kasan_test: disable fortify string checker on kasan_strings() test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch


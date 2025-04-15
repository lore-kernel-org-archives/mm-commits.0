Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C691361;
	Tue, 15 Apr 2025 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744675869; cv=none; b=L4Sdvac4oxlMx+Qf4ZH8jMYGeQclUTDK0cmH/vzW7enZ/HpTJZkCOQWgvdaOi2BUqi6guufnzeZ2jd/T+8UQwn3dEzOhg3jesrAax1aIxNkwF3OZ5YXWsVX76C6/dvA8APQWGjKovRlPVIWlW/TM1zepZDCBmCqLz/GLlzIF6jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744675869; c=relaxed/simple;
	bh=KQUKYquf80Jjc7PCKVNEqJWzgQ+LkrCovnf84LnvUo8=;
	h=Date:To:From:Subject:Message-Id; b=sJ3escaVOTum3ag6GvQcC9dgO7Gitt6BBNbDUj/zkMY4sCg1JN6ymKk2YaZLvQYcVsplvj4/kZZ265Zo0Ax/HOM1kNjXMOCzaVItrrpKz4TtLfvU5MEEuLkL5HAxPInSFmfEbnUiU92vp6MI82OnRGz0I6F+oxIAv+SZscGNGyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDxAbgs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDxAbgs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E0BC4CEE2;
	Tue, 15 Apr 2025 00:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744675868;
	bh=KQUKYquf80Jjc7PCKVNEqJWzgQ+LkrCovnf84LnvUo8=;
	h=Date:To:From:Subject:From;
	b=RDxAbgs5HuVDvjyjUvfEjWl0aWHc/ibfgASWIRtuvBVRw7/JdNAc03rEgzyTbhGYp
	 F12WZZTlzJLio8oztHwH8WqGVSM8t0P0wcrqTNYxBub1MS4omL5kNxDZrMzEw68B4M
	 cX5KCcTdqEoqJ6m26Ylj2VjA6cqVw/DZ2IsQ+wvY=
Date: Mon, 14 Apr 2025 17:11:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,elver@google.com,andreyknvl@gmail.com,smostafa@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds.patch added to mm-hotfixes-unstable branch
Message-Id: <20250415001108.79E0BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_ubsan.c: fix panic from test_ubsan_out_of_bounds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds.patch

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
From: Mostafa Saleh <smostafa@google.com>
Subject: lib/test_ubsan.c: fix panic from test_ubsan_out_of_bounds
Date: Mon, 14 Apr 2025 21:36:48 +0000

Running lib_ubsan.ko on arm64 (without CONFIG_UBSAN_TRAP) panics the
kernel

[   31.616546] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: test_ubsan_out_of_bounds+0x158/0x158 [test_ubsan]
[   31.646817] CPU: 3 UID: 0 PID: 179 Comm: insmod Not tainted 6.15.0-rc2 #1 PREEMPT
[   31.648153] Hardware name: linux,dummy-virt (DT)
[   31.648970] Call trace:
[   31.649345]  show_stack+0x18/0x24 (C)
[   31.650960]  dump_stack_lvl+0x40/0x84
[   31.651559]  dump_stack+0x18/0x24
[   31.652264]  panic+0x138/0x3b4
[   31.652812]  __ktime_get_real_seconds+0x0/0x10
[   31.653540]  test_ubsan_load_invalid_value+0x0/0xa8 [test_ubsan]
[   31.654388]  init_module+0x24/0xff4 [test_ubsan]
[   31.655077]  do_one_initcall+0xd4/0x280
[   31.655680]  do_init_module+0x58/0x2b4

That happens because the test corrupts other data in the stack:
400:   d5384108        mrs     x8, sp_el0
404:   f9426d08        ldr     x8, [x8, #1240]
408:   f85f83a9        ldur    x9, [x29, #-8]
40c:   eb09011f        cmp     x8, x9
410:   54000301        b.ne    470 <test_ubsan_out_of_bounds+0x154>  // b.any

As there is no guarantee the compiler will order the local variables
as declared in the module:
	volatile char above[4] = { }; /* Protect surrounding memory. */
	volatile int arr[4];
	volatile char below[4] = { }; /* Protect surrounding memory. */

So, instead of writing out-of-bound, we can read out-of-bound which
still triggers UBSAN but doesn't corrupt the stack.

Link: https://lkml.kernel.org/r/20250414213648.2660150-1-smostafa@google.com
Fixes: 4a26f49b7b3d ubsan: ("expand tests and reporting")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Macro Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_ubsan.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/lib/test_ubsan.c~lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds
+++ a/lib/test_ubsan.c
@@ -77,18 +77,15 @@ static void test_ubsan_shift_out_of_boun
 
 static void test_ubsan_out_of_bounds(void)
 {
-	volatile int i = 4, j = 5, k = -1;
-	volatile char above[4] = { }; /* Protect surrounding memory. */
+	volatile int j = 5, k = -1;
+	volatile int scratch[4] = { };
 	volatile int arr[4];
-	volatile char below[4] = { }; /* Protect surrounding memory. */
-
-	above[0] = below[0];
 
 	UBSAN_TEST(CONFIG_UBSAN_BOUNDS, "above");
-	arr[j] = i;
+	scratch[1] = arr[j];
 
 	UBSAN_TEST(CONFIG_UBSAN_BOUNDS, "below");
-	arr[k] = i;
+	scratch[2] = arr[k];
 }
 
 enum ubsan_test_enum {
_

Patches currently in -mm which might be from smostafa@google.com are

lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds.patch


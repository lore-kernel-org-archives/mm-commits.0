Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215DE20C492;
	Wed, 16 Apr 2025 05:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744782126; cv=none; b=ecPgfPP2unaVo8E/Gi9NDHyo4ltCdTyLHVsLG8mhw6vpbzERj+qcDdCwq3G+3NS0TcJ76eBGZkt5Z34CyF9uUxUI29pAvY/VTiOeLe5aq4AVleMqxMUgc2zBl6TnLDjHie9R7KNSn+sbchWbuHE7b6US2rXPVj3Sd9ZyVB/koj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744782126; c=relaxed/simple;
	bh=FIIrc2KpQ0cUSt8kyBynHnGfa3z8ZUAagEBwf0wnyhE=;
	h=Date:To:From:Subject:Message-Id; b=noGyEBqtodzIEx3KVKAs/wFQWSo5CnRBddG0eGrQ0FI+yWNaBXUBwZ6G+oKr9wXSPjVZbJ0MLYrqsc9bMnMWu4kT4lqrd/61MV6wO7nBrCMV/Rez7dQuD0Of5jiAxE/Lw//U8R47mHhl/Msu3NslZYsncfL3++A8DLge3TDcsBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wyb/aJui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wyb/aJui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6CDC4CEE2;
	Wed, 16 Apr 2025 05:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744782125;
	bh=FIIrc2KpQ0cUSt8kyBynHnGfa3z8ZUAagEBwf0wnyhE=;
	h=Date:To:From:Subject:From;
	b=Wyb/aJui3fhSWD7QVB++IplidciUNWSGjimUrqU0tAI6mb0cblTXSh6MOyB6rF9Qn
	 nElKgx7eX6dDA9PxSmmKFN96bdxju1+wnu0TZyKakE2SqG6JRKBFO1akVzUB+pz4hW
	 qqlPeniqbBOMelIGxabYow4ZnSOapp7iqPj04GQI=
Date: Tue, 15 Apr 2025 22:42:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,elver@google.com,andreyknvl@gmail.com,smostafa@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds.patch removed from -mm tree
Message-Id: <20250416054205.4B6CDC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_ubsan.c: fix panic from test_ubsan_out_of_bounds
has been removed from the -mm tree.  Its filename was
     lib-test_ubsanc-fix-panic-from-test_ubsan_out_of_bounds.patch

This patch was dropped because an alternative patch was or shall be merged

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



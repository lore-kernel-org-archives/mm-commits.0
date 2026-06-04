Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B2B3BBFA5;
	Thu,  4 Jun 2026 21:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609802; cv=none; b=niggQd9KhIB1gc6R5dat38vdwrY3cVcBQKcGQ5lAGc747HWYS9IfAydPwJKa+8eaitnVCWe6Ni7LQSU4fjeWMhKIbe5VTcEhKxCHYWbg5L66bI0s8TneDrJXh0mKmZjxMKDAwdyvbhgiOts1Y3nAvexwaoI2IoLikAtfa4o/Wc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609802; c=relaxed/simple;
	bh=9EhIGdZklBULdOUS1EPY0hX5GuoVzuDlnIP4Ir5NK3o=;
	h=Date:To:From:Subject:Message-Id; b=RlwOzd/jTuLneIUJ7lDT2DpPmeHQvh8aNZyQtiU2f/nL/nG9fOfQbKiljiIeShw9CJXzCi8/G/zIVFvpP1zLJTgKe2IUW54a1Qm8VDKJcUlx11qskNHUnOcS7iJSK6YMY6bALjNEDWL2FzHbzs30jKVu6RBroMb4mUAaixDMpm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n9fRAhiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n9fRAhiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C001F0089A;
	Thu,  4 Jun 2026 21:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609801;
	bh=lDk6s8g291GpMqugPFSLdNsxtA0JHhxevunRftc4xlo=;
	h=Date:To:From:Subject;
	b=n9fRAhiWhuExL/MC5bbMeUZURHJ6C8Df60zGRD0eQ6F4qApW7NhOrPZGNB+tUWnV1
	 RDyA5N0TIFa4f9DFlZgX8/Go9vY8XmOqdK9xbH7635OsPqm0G7l73S7GbhLn4yxFz3
	 W2EFZG9mWm5BE5VPfcb6BZNnFEvfjhDCBl7rvGqs=
Date: Thu, 04 Jun 2026 14:50:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,kees@kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-use-write_once-for-selftest-mode-stores.patch removed from -mm tree
Message-Id: <20260604215001.94C001F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: use WRITE_ONCE() for selftest mode stores
has been removed from the -mm tree.  Its filename was
     kcov-use-write_once-for-selftest-mode-stores.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: kcov: use WRITE_ONCE() for selftest mode stores
Date: Tue, 26 May 2026 13:47:15 +0200

The KCOV selftest enables coverage by setting current->kcov_mode to
KCOV_MODE_TRACE_PC without installing a coverage area.  If an interrupt
records coverage in that window, the access should fault and expose the
bug.

When building for QEMU raspi0 (Raspberry Pi Zero, ARMv6, CONFIG_CPU_V6K=y,
CONFIG_CURRENT_POINTER_IN_TPIDRURO=y) with GCC 13.3.0, the store that
enables the mode is removed.  The generated kcov_init() code only stores
zero after the wait loop:

  mrc	15, 0, r3, cr13, cr0, {3}
  str	r4, [r3, #2028]

where r4 is zero.  There is no store of KCOV_MODE_TRACE_PC before the
loop, so the selftest reports success without exercising coverage.

Use WRITE_ONCE() for the temporary mode stores.  With the same compiler
and config, kcov_init() contains the intended mode store:

  mov	r3, #2
  mrc	15, 0, r2, cr13, cr0, {3}
  str	r3, [r2, #2028]

Now that the KCOV selftest is actually executed, it may expose KCOV
instrumentation issues depending on the kernel config.  That is expected
for a selftest that was intended to catch coverage from interrupt paths.

Link: https://lore.kernel.org/20260526114715.38280-1-kmehltretter@gmail.com
Fixes: 6cd0dd934b03 ("kcov: Add interrupt handling self test")
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c~kcov-use-write_once-for-selftest-mode-stores
+++ a/kernel/kcov.c
@@ -1119,10 +1119,10 @@ static void __init selftest(void)
 	 * potentially traced functions in this region.
 	 */
 	start = jiffies;
-	current->kcov_mode = KCOV_MODE_TRACE_PC;
+	WRITE_ONCE(current->kcov_mode, KCOV_MODE_TRACE_PC);
 	while ((jiffies - start) * MSEC_PER_SEC / HZ < 300)
 		;
-	current->kcov_mode = 0;
+	WRITE_ONCE(current->kcov_mode, 0);
 	pr_err("done running self test\n");
 }
 #endif
_

Patches currently in -mm which might be from kmehltretter@gmail.com are



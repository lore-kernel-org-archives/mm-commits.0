Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C983740B6DC;
	Tue, 26 May 2026 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779819495; cv=none; b=uR3d0dZ25MGWv/e5vYaSl6A2Gjymx7GJWBZges1fwGM05n6voOOMf42IaS79X5g3F0+6bhk3kxlci2wCtPCW8gd8uwcIaRy75aUls8nLj4nYmkyWYqsXts2s/DUBveoyFu9wsO02Sch35mSvtzqxeiGC+mqTIcvqn0MyHt5S30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779819495; c=relaxed/simple;
	bh=SDhlbdhio/Fm5EHseNKzLXWK6u0znuB9FATXc4Ps5j8=;
	h=Date:To:From:Subject:Message-Id; b=QsvJhJqtEfJjBh95sWjECkKOTAFhtIcv45sdu0DVKRb1yHOEPe59W/Nu5KeaHLBfxpHkPTjytY4vWXwMsuxE9RfmO0Cl+6JO4JirwiXEf5MpgFWl6NHMb8aajvroNoKdnSzuf4jlbDz3LzsUlC5BZ/WADzaPnEzV4dNuSIWWsN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQiRW5A8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQiRW5A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4931F000E9;
	Tue, 26 May 2026 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779819492;
	bh=+SRgWQKEPH5Yc8Rb8It1nmmpoHHNIZT5kuovoJE8WUM=;
	h=Date:To:From:Subject;
	b=FQiRW5A8qP+x+4AQdVXnhp+UFy3yquOrWES9ZDD9C0cIU7QMdZdMOadNg9dO35mvJ
	 leSISoq69iiySz5Wydb+V3CN5ql+OTihUZxieTMrrhDXGdarZReFAAPJvo5EvJfgWC
	 bg4M6BEpKaszK5osN0JAPrPDj2qHaDAwnRL9shSA=
Date: Tue, 26 May 2026 11:18:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,kees@kernel.org,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-use-write_once-for-selftest-mode-stores.patch added to mm-nonmm-unstable branch
Message-Id: <20260526181812.BF4931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: use WRITE_ONCE() for selftest mode stores
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-use-write_once-for-selftest-mode-stores.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-use-write_once-for-selftest-mode-stores.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

kcov-use-write_once-for-selftest-mode-stores.patch


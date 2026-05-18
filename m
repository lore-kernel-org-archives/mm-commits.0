Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2767619E819
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779145319; cv=none; b=J2eP5TMjNJqkW4x2OQkKhyLdCPTHfKLzPN/1Ixwzj6S6nKK8EVIHFBjRYlaFuDTRorABNk9twWk2zM1uO56A46tJGPWKrYm3eAFFD9f6CW0A4CkyCjU2fselJ2sOyZqylLQUJf/28obZYk8undhIOPT1r3tN5uIiu9nLia9MBhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779145319; c=relaxed/simple;
	bh=F8pghapTTmeYJUO5o48H2wNgFJyfL0+8CYkLjN2O/Eo=;
	h=Date:To:From:Subject:Message-Id; b=jEVaRsv8xMUkUwUsLnw6Ax6URoyrNPMT+uXBuu2AJQcxO1lNDUD4eGdpgqq7aKg5jdrvpJb5cBQosc39TU+FssvRTISjITHWQt34gpgKifcgVcCSRDpyhF+fpZvUZksDBN4EAvSMpixgKeTa7SONgdaQRIyuHLgqwVmjqlSPCGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hg4FW1Cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hg4FW1Cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C82C2BCB7;
	Mon, 18 May 2026 23:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779145319;
	bh=F8pghapTTmeYJUO5o48H2wNgFJyfL0+8CYkLjN2O/Eo=;
	h=Date:To:From:Subject:From;
	b=Hg4FW1Cl8S3wpA+dzGnpOeaP9Lz3VhTcegr652oe9hOaUfBzboqqQl6WFZmoCQHvt
	 0ewp8HWZPoG1yu245+DJggM2vSrMXgorLxHtyZknKOFTFFeOL4l+A4XwaVUVbeVAe4
	 z3FpCTM/uT7yUa52GRlLgddhl56Lkm2lfSkNntak=
Date: Mon, 18 May 2026 16:01:58 -0700
To: mm-commits@vger.kernel.org,npitre@baylibre.com,nico@fluxnic.net,akpm@linux-foundation.org,costa.shul@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-remove-unused-cnt32_to_63h.patch added to mm-nonmm-unstable branch
Message-Id: <20260518230158.E1C82C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include: remove unused cnt32_to_63.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-remove-unused-cnt32_to_63h.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-remove-unused-cnt32_to_63h.patch

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
From: Costa Shulyupin <costa.shul@redhat.com>
Subject: include: remove unused cnt32_to_63.h
Date: Fri, 15 May 2026 21:34:24 +0300

All users have been removed over time as ARM and other architectures
switched to generic sched_clock.  The last user was microblaze, removed in
commit 839396ab88e4 ("microblaze: timer: Use generic sched_clock
implementation").

Assisted-by: Claude:claude-opus-4-6
Link: https://lore.kernel.org/20260515183429.1503740-1-costa.shul@redhat.com
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cnt32_to_63.h |  104 ----------------------------------
 1 file changed, 104 deletions(-)

diff --git a/include/linux/cnt32_to_63.h a/include/linux/cnt32_to_63.h
deleted file mode 100644
--- a/include/linux/cnt32_to_63.h
+++ /dev/null
@@ -1,104 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  Extend a 32-bit counter to 63 bits
- *
- *  Author:	Nicolas Pitre
- *  Created:	December 3, 2006
- *  Copyright:	MontaVista Software, Inc.
- */
-
-#ifndef __LINUX_CNT32_TO_63_H__
-#define __LINUX_CNT32_TO_63_H__
-
-#include <linux/compiler.h>
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
-/* this is used only to give gcc a clue about good code generation */
-union cnt32_to_63 {
-	struct {
-#if defined(__LITTLE_ENDIAN)
-		u32 lo, hi;
-#elif defined(__BIG_ENDIAN)
-		u32 hi, lo;
-#endif
-	};
-	u64 val;
-};
-
-
-/**
- * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
- * @cnt_lo: The low part of the counter
- *
- * Many hardware clock counters are only 32 bits wide and therefore have
- * a relatively short period making wrap-arounds rather frequent.  This
- * is a problem when implementing sched_clock() for example, where a 64-bit
- * non-wrapping monotonic value is expected to be returned.
- *
- * To overcome that limitation, let's extend a 32-bit counter to 63 bits
- * in a completely lock free fashion. Bits 0 to 31 of the clock are provided
- * by the hardware while bits 32 to 62 are stored in memory.  The top bit in
- * memory is used to synchronize with the hardware clock half-period.  When
- * the top bit of both counters (hardware and in memory) differ then the
- * memory is updated with a new value, incrementing it when the hardware
- * counter wraps around.
- *
- * Because a word store in memory is atomic then the incremented value will
- * always be in synch with the top bit indicating to any potential concurrent
- * reader if the value in memory is up to date or not with regards to the
- * needed increment.  And any race in updating the value in memory is harmless
- * as the same value would simply be stored more than once.
- *
- * The restrictions for the algorithm to work properly are:
- *
- * 1) this code must be called at least once per each half period of the
- *    32-bit counter;
- *
- * 2) this code must not be preempted for a duration longer than the
- *    32-bit counter half period minus the longest period between two
- *    calls to this code;
- *
- * Those requirements ensure proper update to the state bit in memory.
- * This is usually not a problem in practice, but if it is then a kernel
- * timer should be scheduled to manage for this code to be executed often
- * enough.
- *
- * And finally:
- *
- * 3) the cnt_lo argument must be seen as a globally incrementing value,
- *    meaning that it should be a direct reference to the counter data which
- *    can be evaluated according to a specific ordering within the macro,
- *    and not the result of a previous evaluation stored in a variable.
- *
- * For example, this is wrong:
- *
- *	u32 partial = get_hw_count();
- *	u64 full = cnt32_to_63(partial);
- *	return full;
- *
- * This is fine:
- *
- *	u64 full = cnt32_to_63(get_hw_count());
- *	return full;
- *
- * Note that the top bit (bit 63) in the returned value should be considered
- * as garbage.  It is not cleared here because callers are likely to use a
- * multiplier on the returned value which can get rid of the top bit
- * implicitly by making the multiplier even, therefore saving on a runtime
- * clear-bit instruction. Otherwise caller must remember to clear the top
- * bit explicitly.
- */
-#define cnt32_to_63(cnt_lo) \
-({ \
-	static u32 __m_cnt_hi; \
-	union cnt32_to_63 __x; \
-	__x.hi = __m_cnt_hi; \
- 	smp_rmb(); \
-	__x.lo = (cnt_lo); \
-	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
-		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
-	__x.val; \
-})
-
-#endif
_

Patches currently in -mm which might be from costa.shul@redhat.com are

include-remove-unused-cnt32_to_63h.patch


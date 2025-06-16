Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13CF1C5F14
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115775; cv=none; b=hL1F4Et17TcbsDesX8gzlU2F3+ALv72UUeWKP9RaOj1koUX5Of93NM3jaNjOdS7XrqMNhXtghAc2X8yvk8QXlbYjCzGNhhOMwIpje2r/rtaXDEK+p+nwQb+dz8WuzDmUWM3SeuZeZyOODC2f1QDy1usyJ7NHYtELgGFgkurxq1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115775; c=relaxed/simple;
	bh=lA0Hr6GXZhoQ4CDu/hl8AbM9I5iNjmnxf0uAn0y0zHc=;
	h=Date:To:From:Subject:Message-Id; b=MFJqCepc1E82uiLW9QMa16kUaNE0uUzG3Nhh+G8Yd22YVy/0b5AZUhBD+EAccxuu8FMJTN//JMvNyGillrnTcOMnJ8oYSlECQ1AWjmY4bBVFgXpd00fr6h2X7HMecyJSHbxUm5PibDjtZTeLNc7xMzpj0bu2qli9XUM0pQawavc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KPuZWsxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KPuZWsxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6966FC4CEEA;
	Mon, 16 Jun 2025 23:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115774;
	bh=lA0Hr6GXZhoQ4CDu/hl8AbM9I5iNjmnxf0uAn0y0zHc=;
	h=Date:To:From:Subject:From;
	b=KPuZWsxqSuJvXfajJc7l2OhiRdbpGBb6cVWX5pWYWr4EqKe6j7a6+Gu+LhYNaSiUg
	 z1F+eKe6i+4nZdP/8UKZ7K/EQhKvjiNHGjES/Ln9diOGfN4M7smur8W/6/ZR7zMXP/
	 mSdt8kd8zW5FoM8nWD3FzHLw7kW0hc6p4mC+0C0o=
Date: Mon, 16 Jun 2025 16:16:13 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,peterz@infradead.org,oleg@redhat.com,linux@weissschuh.net,david.laight.linux@gmail.com,biju.das.jz@bp.renesas.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mul_u64_u64_div_u64-fix-the-division-by-zero-behavior.patch added to mm-nonmm-unstable branch
Message-Id: <20250616231614.6966FC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mul_u64_u64_div_u64: fix the division-by-zero behavior
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mul_u64_u64_div_u64-fix-the-division-by-zero-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mul_u64_u64_div_u64-fix-the-division-by-zero-behavior.patch

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
From: Nicolas Pitre <npitre@baylibre.com>
Subject: mul_u64_u64_div_u64: fix the division-by-zero behavior
Date: Mon, 16 Jun 2025 15:22:44 -0400 (EDT)

The current implementation forces a compile-time 1/0 division, which
generates an undefined instruction (ud2 on x86) rather than a proper
runtime division-by-zero exception.

Change to trigger an actual div-by-0 exception at runtime, consistent with
other division operations.  Use a non-1 dividend to prevent the compiler
from optimizing the division into a comparison.

Link: https://lkml.kernel.org/r/q246p466-1453-qon9-29so-37105116009q@onlyvoer.pbz
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/lib/math/div64.c~mul_u64_u64_div_u64-fix-the-division-by-zero-behavior
+++ a/lib/math/div64.c
@@ -212,12 +212,13 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 #endif
 
-	/* make sure c is not zero, trigger exception otherwise */
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Wdiv-by-zero"
-	if (unlikely(c == 0))
-		return 1/0;
-#pragma GCC diagnostic pop
+	/* make sure c is not zero, trigger runtime exception otherwise */
+	if (unlikely(c == 0)) {
+		unsigned long zero = 0;
+
+		OPTIMIZER_HIDE_VAR(zero);
+		return ~0UL/zero;
+	}
 
 	int shift = __builtin_ctzll(c);
 
_

Patches currently in -mm which might be from npitre@baylibre.com are

mul_u64_u64_div_u64-fix-the-division-by-zero-behavior.patch


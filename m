Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62F417741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127162; cv=none; b=Q8vi2l6w6QwPem6lPP4KlvHnHKlCB9XBi9z/Bb8sPp2fZLXciZbqx7Gb7A+j7qj0vn1yGc9E8wEVCQcLnUV1O4uBCzCkMBEDvtKRhS7EYt7h/Cs3CH0IhdJBqQV5TwlnFV7TXKiYUX28VOlXRG3647sYab+2ML1MkK2tOCJd45w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127162; c=relaxed/simple;
	bh=PHIQsKKx8KQLVW4mA0XDvEC0FHKQHoK/SqKaXXDXVeE=;
	h=Date:To:From:Subject:Message-Id; b=lv2jWH2t5pvHJ7Bj/FS8cgEb/lKCf2mOmMlAeToS4yGNB3Y0NUwIeXb43ocY2oY93ZCoNTv7zw8VgFgaJxOCjA2kik6u7EoNWKY+LBGYHRdDYgw+wq/NU9jyaFpOdra9I6Z5K0crCrN9rcsgllUVZV9fDjKWk0Lu+hjJXUP9cIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LdBcu03p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LdBcu03p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89535C4CEE3;
	Thu, 10 Jul 2025 05:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127162;
	bh=PHIQsKKx8KQLVW4mA0XDvEC0FHKQHoK/SqKaXXDXVeE=;
	h=Date:To:From:Subject:From;
	b=LdBcu03pVLFt7HzJBvJBbC6I3AGpJ5CYV97tW1SEZXfHovLK+LfStqa1q9y8K8EID
	 smUe1AFGikJ9If86c7TSFsMd3ylmBj3xb/llq2MnYGjEDdDIeJebeWTFkpVj7kTN7M
	 iDg1YvySAcAKFEIGdzRTTWIp2BAQJ6XbvbuOHiiM=
Date: Wed, 09 Jul 2025 22:59:22 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,peterz@infradead.org,oleg@redhat.com,linux@weissschuh.net,david.laight.linux@gmail.com,biju.das.jz@bp.renesas.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mul_u64_u64_div_u64-fix-the-division-by-zero-behavior.patch removed from -mm tree
Message-Id: <20250710055922.89535C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mul_u64_u64_div_u64: fix the division-by-zero behavior
has been removed from the -mm tree.  Its filename was
     mul_u64_u64_div_u64-fix-the-division-by-zero-behavior.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



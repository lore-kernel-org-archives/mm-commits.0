Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCD31FA4
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573977; cv=none; b=oTvlm4bC06npA7Xy9+n0xHd9cTM16sP9TtjIWYOXnvhQ6uheROKTqX+UKSnrvAMiA1tKu5cv+D4mQgPwrQHFQsA7fVo4uwzNdXCRcbEluCnvP/uoBSNF8WqUDt0GrynjWKjqiwqpgmklyLZGVf5YnIcFIzA4LwF/mWcm6yAEVW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573977; c=relaxed/simple;
	bh=tY7OK3Ir+Y0IFjX/O8RHTPQnLZaN9pby2+JCCsz6dos=;
	h=Date:To:From:Subject:Message-Id; b=c+gTGytY1ivspvEAPgSpiVVVLAA+qE2gVGGZGyC5FxVgy0xAeDre0jz5QrdLxSRl8uWnrFH89XXnKpo0+HpdRE8Dm5r5G+JPis60yJbovF0gKF7xFId9FdNaqu/IwsdSTb+BG2AjWW5k8PpOVJjooo8tVOteQDPsBS7cVK42wb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iLGRRHbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iLGRRHbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B328C433C7;
	Mon,  4 Mar 2024 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709573977;
	bh=tY7OK3Ir+Y0IFjX/O8RHTPQnLZaN9pby2+JCCsz6dos=;
	h=Date:To:From:Subject:From;
	b=iLGRRHbz050S/4tn+2wFLeCZg9CLWYXPvgYqxIcs9bfeLYeSngyZ/XZ5fhBIogVuW
	 msj+EsvuoXBelrnHEkhAHEK051BydXnH4uAsGQtaLPnckIEmj9oCX1mUhKOcyEbNbW
	 GPZWofMtZyv7ZwNmtYKH54worQypiOkiiJ+8Iecg=
Date: Mon, 04 Mar 2024 09:39:37 -0800
To: mm-commits@vger.kernel.org,biju.das.jz@bp.renesas.com,u.kleine-koenig@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b.patch added to mm-nonmm-unstable branch
Message-Id: <20240304173937.8B328C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mul_u64_u64_div_u64: increase precision by conditionally swapping a and b
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b.patch

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
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: mul_u64_u64_div_u64: increase precision by conditionally swapping a and b
Date: Sun, 3 Mar 2024 10:24:09 +0100

As indicated in the added comment, the algorithm works better if b is big.
As multiplication is commutative, a and b can be swapped.  Do this if a
is bigger than b.

Link: https://lkml.kernel.org/r/20240303092408.662449-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/lib/math/div64.c~mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b
+++ a/lib/math/div64.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/math.h>
 #include <linux/math64.h>
+#include <linux/minmax.h>
 #include <linux/log2.h>
 
 /* Not needed on 64bit architectures */
@@ -191,6 +192,20 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 	/* can a * b overflow ? */
 	if (ilog2(a) + ilog2(b) > 62) {
 		/*
+		 * Note that the algorithm after the if block below might lose
+		 * some precision and the result is more exact for b > a. So
+		 * exchange a and b if a is bigger than b.
+		 *
+		 * For example with a = 43980465100800, b = 100000000, c = 1000000000
+		 * the below calculation doesn't modify b at all because div == 0
+		 * and then shift becomes 45 + 26 - 62 = 9 and so the result
+		 * becomes 4398035251080. However with a and b swapped the exact
+		 * result is calculated (i.e. 4398046510080).
+		 */
+		if (a > b)
+			swap(a, b);
+
+		/*
 		 * (b * a) / c is equal to
 		 *
 		 *      (b / c) * a +
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b.patch


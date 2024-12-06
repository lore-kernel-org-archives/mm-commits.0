Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F77192B8F
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457342; cv=none; b=QKhx4N1CX7iySoNyITTiwN8BaOG5D2YC9eBVVH2P6x8vHzC4yJlJ4A6CxRgYX7aAb1ec3WnfUPV/DNJXfDqWd0RlIjZ+WTFocc/b2pMmcdluk/vYXvCOtIfV1/iv5r1r3f0LoTITbPSYlcnXBUHmIy3ZR+N+WYVyZ/Up5XrBEVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457342; c=relaxed/simple;
	bh=uXuoyF2wQkopxD5wTVMbcVthJDwCPHdb0qvj16XTmsw=;
	h=Date:To:From:Subject:Message-Id; b=K1b+v7Y+fyyiq9Ko7a/sSpfufo54SNXa9sF+l6qsHy6AkCiSLN8h2kJJXJeZ0l9TnH6fhF9rQTNJ5ddB+c6G0DEtJbtwKzrZEkGWkL2eqB26BWHXoFL9xd5+URk9B7EZ95l6cw+8LMlS9npBIQe6syxQQBY79yf2sR0WTPltuhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7NdVENg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7NdVENg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12DFC4CED1;
	Fri,  6 Dec 2024 03:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457341;
	bh=uXuoyF2wQkopxD5wTVMbcVthJDwCPHdb0qvj16XTmsw=;
	h=Date:To:From:Subject:From;
	b=n7NdVENgMnxPz3UgXzj3hrm4Mv8d4J32umvmt/E1ceof6bjOnKKBsLgCnPmN5RX+5
	 CGtzmN6bZPOeKnyK9Fm7e0C902qqBcIpC3xeMZbHSHPDjgF4NkHYesbWSFHVQRDDXu
	 z2peQx8fdgwxeNx7A6FvPJ58PTfoe3Fzcjv3RZH0=
Date: Thu, 05 Dec 2024 19:55:41 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,linus.walleij@linaro.org,lars@metafoo.de,Jonathan.Cameron@huawei.com,david.laight@aculab.com,jahau@rocketmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] iio-magnetometer-yas530-use-signed-integer-type-for-clamp-limits.patch removed from -mm tree
Message-Id: <20241206035541.D12DFC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iio: magnetometer: yas530: use signed integer type for clamp limits
has been removed from the -mm tree.  Its filename was
     iio-magnetometer-yas530-use-signed-integer-type-for-clamp-limits.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakob Hauser <jahau@rocketmail.com>
Subject: iio: magnetometer: yas530: use signed integer type for clamp limits
Date: Fri, 29 Nov 2024 22:25:07 +0100

In the function yas537_measure() there is a clamp_val() with limits of
-BIT(13) and BIT(13) - 1.  The input clamp value h[] is of type s32.  The
BIT() is of type unsigned long integer due to its define in
include/vdso/bits.h.  The lower limit -BIT(13) is recognized as -8192 but
expressed as an unsigned long integer.  The size of an unsigned long
integer differs between 32-bit and 64-bit architectures.  Converting this
to type s32 may lead to undesired behavior.

Additionally, in the calculation lines h[0], h[1] and h[2] the unsigned
long integer divisor BIT(13) causes an unsigned division, shifting the
left-hand side of the equation back and forth, possibly ending up in large
positive values instead of negative values on 32-bit architectures.

To solve those two issues, declare a signed integer with a value of
BIT(13).

There is another omission in the clamp line: clamp_val() returns a value
and it's going nowhere here.  Self-assign it to h[i] to make use of the
clamp macro.

Finally, replace clamp_val() macro by clamp() because after changing the
limits from type unsigned long integer to signed integer it's fine that
way.

Link: https://lkml.kernel.org/r/11609b2243c295d65ab4d47e78c239d61ad6be75.1732914810.git.jahau@rocketmail.com
Fixes: 65f79b501030 ("iio: magnetometer: yas530: Add YAS537 variant")
Signed-off-by: Jakob Hauser <jahau@rocketmail.com>

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411230458.dhZwh3TT-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202411282222.oF0B4110-lkp@intel.com/
Reviewed-by: David Laight <david.laight@aculab.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/magnetometer/yamaha-yas530.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/iio/magnetometer/yamaha-yas530.c~iio-magnetometer-yas530-use-signed-integer-type-for-clamp-limits
+++ a/drivers/iio/magnetometer/yamaha-yas530.c
@@ -372,6 +372,7 @@ static int yas537_measure(struct yas5xx
 	u8 data[8];
 	u16 xy1y2[3];
 	s32 h[3], s[3];
+	int half_range = BIT(13);
 	int i, ret;
 
 	mutex_lock(&yas5xx->lock);
@@ -406,13 +407,13 @@ static int yas537_measure(struct yas5xx
 	/* The second version of YAS537 needs to include calibration coefficients */
 	if (yas5xx->version == YAS537_VERSION_1) {
 		for (i = 0; i < 3; i++)
-			s[i] = xy1y2[i] - BIT(13);
-		h[0] = (c->k *   (128 * s[0] + c->a2 * s[1] + c->a3 * s[2])) / BIT(13);
-		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / BIT(13);
-		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / BIT(13);
+			s[i] = xy1y2[i] - half_range;
+		h[0] = (c->k *   (128 * s[0] + c->a2 * s[1] + c->a3 * s[2])) / half_range;
+		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / half_range;
+		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / half_range;
 		for (i = 0; i < 3; i++) {
-			clamp_val(h[i], -BIT(13), BIT(13) - 1);
-			xy1y2[i] = h[i] + BIT(13);
+			h[i] = clamp(h[i], -half_range, half_range - 1);
+			xy1y2[i] = h[i] + half_range;
 		}
 	}
 
_

Patches currently in -mm which might be from jahau@rocketmail.com are



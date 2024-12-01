Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44E4382
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733019919; cv=none; b=AG8Uvufsk1BgVdvsRBHslw2jyeGOl/DZ/WvUZXWFS1ZNB2w3dZdpDwDuvac9+vFN6LgKr0s5Z97Dzgh8SQM7T7+MtpnsjNycxja7YzPYtPJqefAW+IxUzD1EDOtzed5N0eoluv7aiFtrjt1N6PvhIUpg0qQ8SfjcqrbmAZ0RhOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733019919; c=relaxed/simple;
	bh=1VpJ2WLZROdjQ3o1T7Oky8sE9b82XxWZ9jr1WvvOuN4=;
	h=Date:To:From:Subject:Message-Id; b=gvza4bB2DuJ2icKMd56wur1l2F3lAhydAFkmfCIhXmXBvNtYJwbPE57SPSW1vpShngyk6cZTfYx+z1pOU9cMcWe+W8HPE8k33+BXoxzXIkNX62Oc/diuuYf4jKkDIBsts+zgT+IHZ6QCQlUdTjOaE8vqrO1GJ8/Wuje490DiYr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LtlfsJxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LtlfsJxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B77C4CECC;
	Sun,  1 Dec 2024 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733019918;
	bh=1VpJ2WLZROdjQ3o1T7Oky8sE9b82XxWZ9jr1WvvOuN4=;
	h=Date:To:From:Subject:From;
	b=LtlfsJxy+GUCDvsy1M2dISr1pKgPVsj4uQPT1Fs6Y9P2w1CPXvs/8e4YCC123Ffjw
	 DFsZXwxJrEtzEQ6efc1UYbe2W6J33KP4GLVSc7D//Apzi4l3BAukfpdT6/MbJtMymM
	 mmpVJCBEJ64o1fmAKpdCShdI3Wi4Pcy4CoB8SGNs=
Date: Sat, 30 Nov 2024 18:25:17 -0800
To: mm-commits@vger.kernel.org,jahau@rocketmail.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch removed from -mm tree
Message-Id: <20241201022518.34B77C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/iio/magnetometer/yamaha-yas530.c: hack around build error
has been removed from the -mm tree.  Its filename was
     drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/iio/magnetometer/yamaha-yas530.c: hack around build error
Date: Fri Nov 29 10:26:17 PM PST 2024

a temporary thing to avoid breaking people's builds

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Jakob Hauser <jahau@rocketmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/magnetometer/yamaha-yas530.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/magnetometer/yamaha-yas530.c~drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error
+++ a/drivers/iio/magnetometer/yamaha-yas530.c
@@ -411,7 +411,10 @@ static int yas537_measure(struct yas5xx
 		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / BIT(13);
 		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / BIT(13);
 		for (i = 0; i < 3; i++) {
-			clamp_val(h[i], -BIT(13), BIT(13) - 1);
+			if (h[i] < (s32)-BIT(13))
+				h[i] = (s32)-BIT(13);
+			if (h[i] > (s32)BIT(13) - 1)
+				h[i] = (s32)BIT(13) - 1;
 			xy1y2[i] = h[i] + BIT(13);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch


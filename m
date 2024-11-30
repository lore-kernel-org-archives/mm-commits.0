Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045F156CA
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 06:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732949122; cv=none; b=e4jil3RGEVpQSBaR1F1XYIc3ibuzydTwSQWCvPY0ToroG9hhuXLuRxS8Gqkeni3K15gynbWG4oK8h83OJvNPkfHG4t4cKn/q2d1yb43dd3n4rfSwztCEUMp4oiVTNADg20c7K2E9J2emvD8tUEPnZdKr6vGTt+42Psy08CSyOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732949122; c=relaxed/simple;
	bh=cPnAcdDoajnBumcWW4x4Y9aiDiAIHUSAIYjyl17bcX4=;
	h=Date:To:From:Subject:Message-Id; b=GdVIMMGdmDUkhvHqVpdoUP24CD+KcfHSH5pCSX3Iixea07rXaTs6+xsB4CaRbJO1fbWAVTxvPjQ1V8v80H2F8og9QNE7Nxjy9wawY/rD5PVUtNlGPOlCrXUytnWU5JTAUxV9veK++eFEE13aVi9hRxnrj/xwQykEsgqH9XTM7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CEXQ0Fdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CEXQ0Fdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04220C4CED3;
	Sat, 30 Nov 2024 06:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732949122;
	bh=cPnAcdDoajnBumcWW4x4Y9aiDiAIHUSAIYjyl17bcX4=;
	h=Date:To:From:Subject:From;
	b=CEXQ0FdraEPDqdzU5dWgTa6kn3kHJT8Y+EP00CTwsyGeQ4YFPrOIdRdQvJl+n22zu
	 JCKxuwSDnaAqr9u+dyU4lxqkCPzxSIpuMKm7rzY0OYevw/nbrbgHneoy8PXVINgGUb
	 q3n8QnrhgAnpDrWouKZ9cqzd4ghymW9MKSvLi+H8=
Date: Fri, 29 Nov 2024 22:45:21 -0800
To: mm-commits@vger.kernel.org,jahau@rocketmail.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch added to mm-nonmm-unstable branch
Message-Id: <20241130064522.04220C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/iio/magnetometer/yamaha-yas530.c: hack around build error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/iio/magnetometer/yamaha-yas530.c: hack around build error
Date: Fri Nov 29 10:26:17 PM PST 2024

a temporary thing to avoid breaking people's builds

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Jakob Hauser <jahau@rocketmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/magnetometer/yamaha-yas530.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/magnetometer/yamaha-yas530.c~drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error
+++ a/drivers/iio/magnetometer/yamaha-yas530.c
@@ -411,8 +411,10 @@ static int yas537_measure(struct yas5xx
 		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / BIT(13);
 		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / BIT(13);
 		for (i = 0; i < 3; i++) {
-			clamp_val(h[i], -BIT(13), BIT(13) - 1);
-			xy1y2[i] = h[i] + BIT(13);
+			if (h[i] < (s32)-BIT(13))
+				h[i] = (s32)-BIT(13);
+			if (h[i] > (s32)BIT(13) - 1)
+				h[i] = (s32)BIT(13) - 1;
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792947250;
	b=1YEc/LYOcsiB+hFeK9LI6ocmhfzRXY+XCV/hDuhrGZJJBl/5Ej3KbxMkYqMlxNfhJMeK
	 VpNUVMFt5Q3vTkCKNnH5VJLah6EFaLMEO3QqKmFsXYL4VsKPCGlkgWtY2sZk+MQJREHmf
	 EfRdN6abZbeWI2kIgsCgT0JVnC14ZOOAByxf0gBXCu3+XOTYxSiDhhD7gGKTaM3FaA80J
	 OFUSEzPldxrxEC6DUP+09Gd+JIkSZL7utLMdvtyIa04aDDZJf+/nZUGoL5N5TxQovmPnl
	 bStE5C3DgcOzzoYO5zsyuUW6rObzhehJNg1AR69M1luE/78TB/cRa/XdsbQMPbOA9kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792947250;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8eKo3eNr9yqWutlJ/Xr1i5FwST0lwW2Lspvh+8T+3L0=;
	b=rbdLy56tjYluFjMCeR+fPLjTkI9NTxPeEIhy3wBjjmaE6SjQm5J8OAeCVQr35eRPd4sN
	 VFYYwMqpLjfbhVb52cqO+xID/eLCC/Hcahkd8SLa/9RHdQ/xfEZuT1onL/HZbSxZEeE0U
	 H2LYfeQnG98mUiO3lc+hKaxx/sPJaCwzLOhMoOS5KhQ2Gr+4EIW7XR9US4qx4q5ZtP/rh
	 gh5Z1AHyxyPSjdNmtujHzoi0TEKN680Yvw/ba5mZTSF9B+r/HOHGvRftzJfGADNkvLWOQ
	 6y3TGioYebItDfZ/+ETFbyofqtv28bESv1T4rOUzOtJrHvY5OrqN5K8mbkVpplnoSVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ou7aahYw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F420606A31E;
	Sun, 25 Oct 2026 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ou7aahYw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148021F01825;
	Sun, 25 Oct 2026 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792947250;
	bh=8eKo3eNr9yqWutlJ/Xr1i5FwST0lwW2Lspvh+8T+3L0=;
	h=Date:To:From:Subject;
	b=ou7aahYwi6XfeG3PxSvfZaSe/n3n9n5mZGXXmgVz4oI78s3dhi0m5Q4kwKiy+8ta6
	 P0IapPD646iXfCIr7qpkTICNRX7XwD07Cmmd88UTQwoQLs/UQ7iWGh9yhZc/FwYmzS
	 WYeSyw7Ci+aNwtD9pFPsV3oz7TLEqxGnA/QJq6Oo=
Date: Sun, 25 Oct 2026 09:54:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiayuan.chen@shopee.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch added to mm-unstable branch
Message-Id: <20261025165410.148021F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: move static variable rotation to damon_ctx
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch

This patch will later appear in the mm-unstable branch at
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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: move static variable rotation to damon_ctx
Date: Sun, 25 Oct 2026 09:48:06 -0700

damon_split_some_reigons() uses a static variable, rotation, to remember
how many times it was called.  It is again used to determine fair
selection of regions to split.  Since it is a static variable, it can be
indeterministic and therefore less fair.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort and indeterministic monitoring accuracy could be slightly
more indeterministic when multiple kdamonds are used in parallel.

Fix the problem by moving the static variable into the damon_ctx struct.

Link: https://lore.kernel.org/20261025164808.152048-4-sj@kernel.org
Fixes: 1a582e6e0174 ("mm/damon/core: split a fraction of regions when nr_regions exceeds max/2")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: <stable@vger.kernel.org> # 7.3.x
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-move-static-variable-rotation-to-damon_ctx
+++ a/include/linux/damon.h
@@ -963,6 +963,11 @@ struct damon_ctx {
 	 * for more details.
 	 */
 	unsigned long last_nr_regions;
+	/*
+	 * number of damon_split_some_regions() invocations for this context.
+	 * Read damon_split_some_regions() for more details.
+	 */
+	unsigned long region_split_rotation;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
--- a/mm/damon/core.c~mm-damon-core-move-static-variable-rotation-to-damon_ctx
+++ a/mm/damon/core.c
@@ -3753,12 +3753,13 @@ static void damon_split_regions_of(struc
 static void damon_split_some_regions(struct damon_ctx *ctx,
 				     unsigned long split_step)
 {
-	static unsigned long rotation;
 	struct damon_target *t;
 	struct damon_region *r, *next;
-	unsigned long offset = rotation++ % split_step;
+	unsigned long offset;
 	unsigned long idx = 0;
 
+	offset = ctx->region_split_rotation++ % split_step;
+
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			unsigned long sz_region, sz_sub;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch
mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch
mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch


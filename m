Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832542;
	b=0KQCajSNM4bRpsC+QzuJTKRs6z8ywWnRfOsL0mb0uQ2VDJ4QaU6EMYstSlPIBx1S3nW0
	 iq7p6C9kpyOcmaKLinhzVnJSni32l2q90MbFaqZpS5drsGiznhfSyTsIIppgj9oAX/QuM
	 s26zIrLv5B7uUfxT4KblapwvWTNInbZsHjrOGHyvhGAXMBRirTR+AoKEZWTo6iviljRmV
	 h0sXMxx4q0n+wW5ipSt07r6EoQAft2AIUkQz4y/kqQURoxlSjSzyd5aAig9bjYs5Pz95R
	 J16A7TqRrfDiQZM138KuwUfcOLo1J9+LnKYvCjOZjOhV4QVC4w7d4pDvhOUmItsjvog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832542;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ysJDE5za3VEHpTvwAAPWE01ogIHOrgmmQ7RBVCv4EJA=;
	b=ffCJno4CAbGT0LUkNaSw8WBoayJIcukm0KCb5yN5qPT7eyKnojtPRWMWkWqOOL87dkvX
	 DMUAE4YSwCoj1nSJfQq71FcdGljzBXdTaLzy0661bVVzxJtL/tt7JO7dup9q5yNvgLRGg
	 6hS/YtlzB2V4Bg86UU534pi2rLDRbz3zas0YkFUWA//dyLnSaencBmyUqxGIoze+CdZmj
	 SOHCrlNkkdpqqhTS9WA7iyoZffywxaA4AfpQyQ0EGXqFnzty18R0DV5duCsEH5FOrHYA0
	 LLyQ/j3us3KWoyE6Jf0SMjx1fUwiUqKL723QX+PcIvF3VkONUvkGrDxRWr3mbIqGUDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="X/ZVD9x3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9C606A31A;
	Sat, 24 Oct 2026 09:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X/ZVD9x3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0662B1F01828;
	Sat, 24 Oct 2026 09:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832542;
	bh=ysJDE5za3VEHpTvwAAPWE01ogIHOrgmmQ7RBVCv4EJA=;
	h=Date:To:From:Subject;
	b=X/ZVD9x3dNkWmxUfmaEivvQc6zx1yYNDVjhqWOTNXl2RAkwxjaPrtHNvH0HM3k5Mz
	 vuQ4rstc4obxSAXAFPzDVtm1sOuCR0SwsIgxbyE/D0LuwrFZbZub9w27D4IqIv9sSX
	 OZVI526bhAVpyeeX/dGEFZjjdVYWr+XBQY5qIKm4=
Date: Sat, 24 Oct 2026 02:02:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-unreachable-damos-charge_targetaddr_from.patch removed from -mm tree
Message-Id: <20261024090222.0662B1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: remove unreachable damos charge_{target,addr}_from
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-unreachable-damos-charge_targetaddr_from.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Mon, 19 Oct 2026 19:39:56 -0700

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
---

 mm/damon/core.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-remove-unreachable-damos-charge_targetaddr_from
+++ a/mm/damon/core.c
@@ -3383,6 +3383,26 @@ static void damos_trace_esz(struct damon
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3418,6 +3438,8 @@ static void damos_adjust_quota(struct da
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (damos_quota_is_full(quota, c->min_region_sz))
 		return;
 	if (!c->ops.get_scheme_score)
_

Patches currently in -mm which might be from sj@kernel.org are



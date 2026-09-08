Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFE3598BEB;
	Tue,  8 Sep 2026 18:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893580; cv=none; b=tfizELLd50BkstzacofZznMuNRBe9adlQd9OmObLzJg6tnCYtFn4Daa6aqm1CsMnzlAvglwVr5vChrYK18MD4fqaZxwmqm+WyrM/gG9aPKnUMchRl7g3urDxCCM2HNltBsmKqllEraLvO/uHpIyu3FkjqACin652+8Q6ygdgwjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893580; c=relaxed/simple;
	bh=FkOlW4BSLjtPbdVhL1BHPnX43nPaswMx+gHYElEBNUs=;
	h=Date:To:From:Subject:Message-Id; b=YlrQTuxWMivyrbIUeyHp9ATAYvxFHGynZceHMAAm5Ehnd3W1gdrf7IPZ1BnAg7yb8M7MnRB0CsWCuu1aCIQADlBOImwcooapZBsNH0rynPd7DHIzcA/P1/Lm5CVPhpXyFPyPkhbqRbpp4pjL6pZ/XK3kyAWw4fwG/2YNOc+if2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHCLzMSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHCLzMSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51551F00A3D;
	Tue,  8 Sep 2026 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788893579;
	bh=BKe8T6nROiVRH3fvgVTEmXzzXU79Kao3I62VQ9CFsR4=;
	h=Date:To:From:Subject;
	b=AHCLzMSYmWVBdO/rkwGg58oOqdTv4As56fek05xsKOrIeVCaB6PJ4zWqzSBmsfoIp
	 PKm8IFACiNumibz9+4W4FWy4PPF9HqnVXnCC56XRfVQjRQbQ3RUgeynZqz49hLjmFy
	 d5FWVjbx1KfuV9k+z2jWx+XRvv/NnocQU/SC3jKo=
Date: Tue, 08 Sep 2026 11:52:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-allow-esz-to-be-set-to-zero.patch added to mm-hotfixes-unstable branch
Message-Id: <20260908185258.E51551F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: allow esz to be set to zero
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-allow-esz-to-be-set-to-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-allow-esz-to-be-set-to-zero.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/core: allow esz to be set to zero
Date: Tue, 8 Sep 2026 06:54:11 -0700

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the esz becomes
zero.  However, damos_set_effective_quota() clamps the esz to
min_region_sz when quota->ms is set.

This is a minor issue, the main problem is that it doesn't match the
description in the documentation, which state that if the goal has already
been [over-]achieved, the quota will be set to zero.

Fix this by set quota (esz) as minimum as possible.

Link: https://lore.kernel.org/20260908135413.97570-1-sj@kernel.org
Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # v7.1.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-allow-esz-to-be-set-to-zero
+++ a/mm/damon/core.c
@@ -3091,6 +3091,7 @@ static void damos_set_effective_quota(st
 	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
+	unsigned long esz_time;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -3111,8 +3112,8 @@ static void damos_set_effective_quota(st
 					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
-		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz_time = max(throughput * quota->ms, ctx->min_region_sz);
+		esz = min(esz_time, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-core-allow-esz-to-be-set-to-zero.patch
docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch


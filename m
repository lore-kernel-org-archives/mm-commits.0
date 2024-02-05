Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19F248783;
	Mon,  5 Feb 2024 20:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707166590; cv=none; b=W+FEbjQ0LCIC/Yqx3B4yd74Pap+rtHyrqiNXnpydRe0f5EGTpsPTjQk8wovqosf+CGPxJtzlMgXOidcMhP2br+QCXQIybbD2CTc1nBSUiMcrXuP0iwE55qkK3dgTGGRDO62XBrjc75BvJQTPUB95XnIiG3qsVc7txUhSkCcHZ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707166590; c=relaxed/simple;
	bh=gDZ6wrndIFbg/VL02kI6xzC1bj6/RUzS32l0qNprLPk=;
	h=Date:To:From:Subject:Message-Id; b=ufEzRyJ7DoNGfOSPkKJhNwtdjR2eciT/QXE4kdVQ/ow/WF3In0py5A6C33Uu1BFRUFc2v11JUlpAWeEHcbQQ+ExsG0SD7dOO20zeK5JA2+MSiA0S5pc3nQObjOIdj0iw5DvoTVU05kyGlEliYkRTUr194HhjnFuk3qF1YF3jdv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=taVV21zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="taVV21zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B6EC433C7;
	Mon,  5 Feb 2024 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707166589;
	bh=gDZ6wrndIFbg/VL02kI6xzC1bj6/RUzS32l0qNprLPk=;
	h=Date:To:From:Subject:From;
	b=taVV21zwDiifwrFKZhW/caHf8gn1pt9GMdBqbropKxNDyStne15NDOhs9SV5G/xWk
	 tspRI3ue/ovXnEWWk+npfOmNLgrVdR1pxlWMosBTf+d3Ipt+QTRoPRZs5mEy1CcDYT
	 arkNE0+9///7/TsUsfRvRgUWNJMyLw+3WdOC5CkE=
Date: Mon, 05 Feb 2024 12:56:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch added to mm-hotfixes-unstable branch
Message-Id: <20240205205629.45B6EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: check apply interval in damon_do_apply_schemes()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: check apply interval in damon_do_apply_schemes()
Date: Mon, 5 Feb 2024 12:13:06 -0800

kdamond_apply_schemes() checks apply intervals of schemes and avoid
further applying any schemes if no scheme passed its apply interval. 
However, the following schemes applying function, damon_do_apply_schemes()
iterates all schemes without the apply interval check.  As a result, the
shortest apply interval is applied to all schemes.  Fix the problem by
checking the apply interval in damon_do_apply_schemes().

Link: https://lkml.kernel.org/r/20240205201306.88562-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-check-apply-interval-in-damon_do_apply_schemes
+++ a/mm/damon/core.c
@@ -1026,6 +1026,9 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1176,10 +1179,6 @@ static void kdamond_apply_schemes(struct
 		if (c->passed_sample_intervals != s->next_apply_sis)
 			continue;
 
-		s->next_apply_sis +=
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
-
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1195,6 +1194,14 @@ static void kdamond_apply_schemes(struct
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
+
+	damon_for_each_scheme(s, c) {
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+		s->next_apply_sis +=
+			(s->apply_interval_us ? s->apply_interval_us :
+			 c->attrs.aggr_interval) / sample_interval;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch


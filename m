Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30CE3AC0E4
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019225; cv=none; b=hjDu+QUy6KjWjTbTrHu67xsEkeCoCG2h9BNWHKmhZ2PNnzrwQb8r68Tk+PmwOQxkQF95x0qp6YeWCjszQ66AFHlxNpHLSWxlZAQJ4wYiaQajfmmhOxaQk2ugZc0/TbngIro2Pucvdz1stexz6Oc8FloS/nZJetTZVdIqYy8jguc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019225; c=relaxed/simple;
	bh=muuE6z1mIHatOn4p6eNNlHiE48FAsUbFvdLE4U9aOew=;
	h=Date:To:From:Subject:Message-Id; b=GR7uw+jTxcVNH79kw1juYkil82Y8kB2WnUw3WOTeHG9hOn95k40bgIPCLWONe5a/ofqjq00rr5NiNslWc8ObrC6Z0FxhfKTbzSuznlDNP6e6nnQMDuJ4d8mLgjl2X/nvLPbOIrr8wQN48+Hls9iBr+U8cuteXlEhzztSMUJSIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PrjH2Ld0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PrjH2Ld0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E20E1F00893;
	Mon, 21 Sep 2026 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019223;
	bh=e1nMgInP9gK38lTplAjYYDiWbSUEvwWrAwWcVSKuHzs=;
	h=Date:To:From:Subject;
	b=PrjH2Ld0UxpSFPGtMVg2Typ2wOHK5iYQyjEpNb1SSahlLHPOyd1AmDzlBKxXUEYTE
	 tXeTPFK9LCEeOk4FYeqPgfttUTIigQ+QYo/01w/65zdNztgiAigMaqwWiL8zMYfPM/
	 h0wVb2Jc0zZAKEW/jxdNIGlwmq695McAT8d5p8wA=
Date: Mon, 21 Sep 2026 12:33:43 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,wangxuewen@kylinos.cn,sj@kernel.org,karthiproffesional@gmail.com,adrianhuang0701@gmail.com,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch added to mm-new branch
Message-Id: <20260921193343.7E20E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: skip quota score setup when the quota is full
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/damon/core: skip quota score setup when the quota is full
Date: Mon, 21 Sep 2026 08:15:43 -0700

Patch series "mm/damon: improvements in efficiency, error handling,
documents".

Four various improvements.  Patch 1 from Liew Rui Yan skips unnecessary
quota setup work when relevant.  Patch 2 from Xuewen Wang propagates
ignored damon_call() error to sysfs users.  Patch 3 from Adrian Huang
(Lenovo) fixes typos in comments.  Patch 4 from Karthikeyan KS clarifies
zero sample interval acceptance on kernel-doc comment.


This patch (of 4):

In damos_adjust_quota(), the quota could already be full.

In this situation, damos_adjust_quota() will still calculates
quota->min_score.  However, this min_score will not be used in this
window, because in damon_do_apply_schemes(), damos_quota_is_full() will
always returns true, preventing the scheme from being applied to any
region.

Therefore, add a short circuit for 'esz < min_region_sz' schemes to early
return from damos_adjust_quota() before calculating min_score.

Link: https://lore.kernel.org/20260921151547.78472-1-sj@kernel.org
Link: https://lore.kernel.org/20260921151547.78472-2-sj@kernel.org
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-skip-quota-score-setup-when-the-quota-is-full
+++ a/mm/damon/core.c
@@ -3369,6 +3369,8 @@ static void damos_adjust_quota(struct da
 			damos_trace_esz(c, s, quota);
 	}
 
+	if (damos_quota_is_full(quota, c->min_region_sz))
+		return;
 	if (!c->ops.get_scheme_score)
 		return;
 
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch
docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch
mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch


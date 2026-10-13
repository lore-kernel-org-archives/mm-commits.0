Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4239484255
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866050; cv=none; b=oXcShglxq7cAkEauu0ekuKaHYy01n9Ub0QqZWS/Jkh7WQc0wJQ30/rcoZ173ilyd9i31u60vqtSYbvcbdAb0doJ5XSvKiLoTIuc5YJhPNqXWxHSqfa/ZTvL/TOHWPsWLlgn7eX5sAXaRsjd2ww4VY+MVnCwvYg/8pNRph1O2YIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866050; c=relaxed/simple;
	bh=agmMbTTN6lvSOzYWXKe1bDhOXpkVT4KDBj8BKrBkpkg=;
	h=Date:To:From:Subject:Message-Id; b=SF9rByn5E7HbwvlJcSROSA/vdfoJlxH71BbW5dHL3qGfbpkPL5SzERzlKb0lUKTFy3Q4+Nv90pXFxTSWlF9/s87aqvTOqm1Ue5A4aMCL2w+nuSc+XTKXb6/TBxd8hAG5rrakP4WTvadah14T/cAeVccyUou+FYcvlTbZ2W2xyPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dgf1hTn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dgf1hTn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5FC1F00899;
	Tue, 13 Oct 2026 04:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866046;
	bh=R+c5Dp/NZpCuj/z5uTp3R1lqk1aj3MBsdey3eLA9FFc=;
	h=Date:To:From:Subject;
	b=Dgf1hTn4gY85Mry/Ws4pvySLkUhn+MTSsmY4lza3R2hnDW4ekikoVgE7zbIY1/2ku
	 RewqA+4QGCkM8ksUg3mKcmTF3a2QdqHdzTX4R0chgSoyLaRljmf+NRfRc2y1J6O/mX
	 Ltj7IfDFg4Wdq2yaAbXzhelssw+kGpg4/RhD84Ho=
Date: Mon, 12 Oct 2026 21:34:06 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,wangxuewen@kylinos.cn,sj@kernel.org,karthiproffesional@gmail.com,adrianhuang0701@gmail.com,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch removed from -mm tree
Message-Id: <20261013043406.8B5FC1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: skip quota score setup when the quota is full
has been removed from the -mm tree.  Its filename was
     mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3385,6 +3385,8 @@ static void damos_adjust_quota(struct da
 			damos_trace_esz(c, s, quota);
 	}
 
+	if (damos_quota_is_full(quota, c->min_region_sz))
+		return;
 	if (!c->ops.get_scheme_score)
 		return;
 
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3752485930
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866059; cv=none; b=PxEsajx2ovLHa2/Bld9Vi5hU4JPfen2Tb0kKTHpaDxyv6B7wOKNzCXKOTvETbaA2v2gtYd0pgfqVACi6+SeYzb/cVM0wRDbnas6LQhri3v/OXbqiEqhrqMMowHO9kqnOo7G+k7zUXggpspRS70kBMOhJkrKwUVAvRSjrNoc/qnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866059; c=relaxed/simple;
	bh=SKXKoQZLsj87ZFFgPmzcM3PbLIPUQ6glW9vBqYnJsgw=;
	h=Date:To:From:Subject:Message-Id; b=PxtxhklNA6uFbvaRGGvj6M19DxVwoRNWWjGRppfbSw8NWPQXjDTK/ZNqzjWZtfcNQ/2RT2qGuoSf9viiimhI1COWHU576sJKDJsaWRpQ1gXJT1NULJuPqeqwQonb7he9rtVlYatL0tzgITiOaFhZbsM95DGKOU0smjIEoBO5DK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdhSUfxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdhSUfxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D3F1F00893;
	Tue, 13 Oct 2026 04:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866047;
	bh=OJFTTZCyEXqk/MPOCrXXXkh0D25LZVIQU1PX2F5f9xk=;
	h=Date:To:From:Subject;
	b=vdhSUfxDS4oO4o9+g+zTuoFjQd9RuChLtuswDf+DQJDvSFQZvKny6xka/44KiHLAA
	 sScSfb3YmLpEdQkq67qtJ9lRQIZBmwPosvA2w3RonDIsIUPHA3s7c9we9jQrpVrjEZ
	 gG/MnBI0GRrEw1dh0MQd5S+X1ZVeLAU7nYCJP0KA=
Date: Mon, 12 Oct 2026 21:34:07 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,sj@kernel.org,karthiproffesional@gmail.com,aethernet65535@gmail.com,adrianhuang0701@gmail.com,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on.patch removed from -mm tree
Message-Id: <20261013043407.95D3F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: propagate damon_call() error in turn_damon_on
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: mm/damon/sysfs: propagate damon_call() error in turn_damon_on
Date: Mon, 21 Sep 2026 08:15:44 -0700

damon_sysfs_turn_damon_on() ignored the return value of damon_call() for
the repeat call control registration and always returned the stale result
of damon_start() (0 at that point).  When damon_call() fails, e.g., the
kdamond is already exiting, the user still gets success from the state
file write while monitoring is not actually on.

Save and return the damon_call() result instead.  No rollback of
damon_start() is needed since a failed damon_call() guarantees the context
is stopped.

Link: https://lore.kernel.org/20260921151547.78472-3-sj@kernel.org
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---

 mm/damon/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-propagate-damon_call-error-in-turn_damon_on
+++ a/mm/damon/sysfs.c
@@ -2607,7 +2607,8 @@ static int damon_sysfs_turn_damon_on(str
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	if (damon_call(ctx, repeat_call_control))
+	err = damon_call(ctx, repeat_call_control);
+	if (err)
 		kfree(repeat_call_control);
 	return err;
 }
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECAE3E47B
	for <mm-commits@vger.kernel.org>; Mon, 16 Sep 2024 07:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726472504; cv=none; b=kObhJElloUuLkXl+sNApltUhPMOV4DP5RZ7c3rK1i87rZLZDqwD9HEVlpg1xKbOaE34UsMy7WgjVjpVrLFgVpydlr0P6zURTbNGmt5ExDQiDLwh2HM1c2dcyZRxvcCVi7p/vA5L6BfIhv7lXvF/3JxhKJsvxPvHKtV517ikNnLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726472504; c=relaxed/simple;
	bh=F+53MfhHSeP+BoXJ8tK4FEhQD5/iy42yucpnErjWiew=;
	h=Date:To:From:Subject:Message-Id; b=g6whRwjqjvXyUmmSCQ9nYEh06zUMOSbM7kOCuia03sLuM9A7AsbeECfcbW1DuuashmBMSk+9oty0ud/9m0SfNy9AmI1WLOc92dUd+UxRWerCgBHBz34Zr/xAcHt+nTV4S5q14+3Z6EcItpoe+bLQFg9Tjf4GC+kJ0UVCj+YCklM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hXy/ThXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hXy/ThXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FDCC4CEC5;
	Mon, 16 Sep 2024 07:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726472504;
	bh=F+53MfhHSeP+BoXJ8tK4FEhQD5/iy42yucpnErjWiew=;
	h=Date:To:From:Subject:From;
	b=hXy/ThXR4m5PB+Wz3SaZuUNaePhUeo3KPgHlhtsurVgCv7biwl8QMdNGMCTl6sFkL
	 VdUmppN0l3yJSLWYKgi5+F/mhRI3yGOW/fPG9ILKERADI2dakoi8MFx/0z1byPj2Ab
	 GQty+01PYIf7CRBiP4qrZcSil9FPGDoStMFmAT2U=
Date: Mon, 16 Sep 2024 00:41:41 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch added to mm-unstable branch
Message-Id: <20240916074144.20FDCC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch

This patch will later appear in the mm-unstable branch at
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
From: Jingxiang Zeng <linuszeng@tencent.com>
Subject: mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2
Date: Fri, 13 Sep 2024 16:44:53 +0800

Link: https://lkml.kernel.org/r/20240830082244.156923-1-jingxiangzeng.cas@gmail.com
Link: https://lkml.kernel.org/r/20240913084453.3605621-1-jingxiangzeng.cas@gmail.com
Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2
+++ a/mm/memcontrol-v1.c
@@ -2729,8 +2729,6 @@ static const char *const memcg1_stat_nam
 static const unsigned int memcg1_events[] = {
 	PGPGIN,
 	PGPGOUT,
-	PSWPIN,
-	PSWPOUT,
 	PGFAULT,
 	PGMAJFAULT,
 };
_

Patches currently in -mm which might be from linuszeng@tencent.com are

mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch
mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch
mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch


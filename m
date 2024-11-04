Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888EA4C6C
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694916; cv=none; b=meYqF2fq0Szf/fZsh1365D7qRFVEb1tjDSjRJZG1A10zjf/BgF40otrLkC2ot435IODopa/ReheSf/iYHkxJwETo3BEXVCyI71rIHn6MZP44hvf3p/7qzgB8ymMwaiy23Qoacmk742fGenxduKQ/w8e4Mzz9rspqU9vBCcb1gYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694916; c=relaxed/simple;
	bh=cEmxhrFXM7d28iWJiECCHBYRL3MgH240iHdXKsNRTYU=;
	h=Date:To:From:Subject:Message-Id; b=dEt9fgt0GKvOU7yGIhxQQA3OaWGC+xYXUy6ChS3aj1XhsNl1T88OQPqmxlhktFGUjTbX6tIIKLW2XVmnE1lam4cQevNXZQCIG+08X59p1OyJ6ivsfCm/GCneZykDaoulCgCQdU4qRk4BkXXO5HcXnx5v/96xjNKNKoO/w4ZbJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jDC5aYLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jDC5aYLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C41C4CECE;
	Mon,  4 Nov 2024 04:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730694916;
	bh=cEmxhrFXM7d28iWJiECCHBYRL3MgH240iHdXKsNRTYU=;
	h=Date:To:From:Subject:From;
	b=jDC5aYLQocBuCBGL1mInUoEVP5ea16iugIOBRa4shl2khPxfL6ADf/ahf6vOu683r
	 FYPPnnJBnocjN3NS3VDKZeIHSfWmSodKEtal4MyXQqzYiYTZKTN34jIYjzxW2xKkmh
	 bfUtS6z1RhZfx1XjG+wHZ9FxJveYKfM0sb0xm4TE=
Date: Sun, 03 Nov 2024 20:35:15 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch removed from -mm tree
Message-Id: <20241104043516.04C41C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch

This patch was dropped because it was folded into mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch

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
@@ -2754,8 +2754,6 @@ static const char *const memcg1_stat_nam
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
mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch


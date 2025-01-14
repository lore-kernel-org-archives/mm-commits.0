Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1546E23A574
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836962; cv=none; b=nS9Q0KzEi/cf8Dop7WSTIVE/5C8JH5+SU4lgA+vMDb8saP+THlp3sNLYXFwK9Pm30DlsHWktY6CQHxxZBLSWuLjECyYJ36gwdsSPlCFF6Rz48gfQfKn4FrRgCfNPRGPTOP1s0hvC/+7O+Am22/Og2Y2/VOUlhvdc/duJWNvSGDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836962; c=relaxed/simple;
	bh=k1GdwX6dihQH8p62e8mlHLhzacfSeTinybx/lK700Hs=;
	h=Date:To:From:Subject:Message-Id; b=DMKlwp8jcZcsu1Ai74iv44OZMwc2xpB637i6G+gCG5Co63M2L+Gk9DoWoYLc3hMg93Am6EmYIGSPAyNGyjwD6DM7LSZsC+Ozrznn2O5L0WsYciMWnXytJ1Z2G/YZ4nnD0RBDBINbXdHQqq9bnIeS9PXxmn62YY+6XGBwMtnl4R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZkUvDMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZkUvDMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82159C4CEDD;
	Tue, 14 Jan 2025 06:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836960;
	bh=k1GdwX6dihQH8p62e8mlHLhzacfSeTinybx/lK700Hs=;
	h=Date:To:From:Subject:From;
	b=AZkUvDMK9p4DjM86yzGNHc7sG5ZV0AFxh2TupipYRFXgdLXIysRtoHRQ87uaEcowU
	 9zz9Z1R90ISf7v+UqC97HI5+6/42pFhQsYDVHp25JKbcvqwHhTAkRhHubako80yR6U
	 WRwkYbaErXuNKfIKn9q+5HvDN3Idv9hWMjLTJ/og=
Date: Mon, 13 Jan 2025 22:42:39 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kerensun@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch removed from -mm tree
Message-Id: <20250114064240.82159C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove the non-useful else after a break in a if statement
has been removed from the -mm tree.  Its filename was
     mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keren Sun <kerensun@google.com>
Subject: mm: remove the non-useful else after a break in a if statement
Date: Fri, 15 Nov 2024 15:57:44 -0800

Remove the else block since there is already a break in the statement of
if (iter->oom_lock), just set iter->oom_lock true after the if block ends.

Link: https://lkml.kernel.org/r/20241115235744.1419580-4-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-remove-the-non-useful-else-after-a-break-in-a-if-statement
+++ a/mm/memcontrol-v1.c
@@ -1134,8 +1134,8 @@ static bool mem_cgroup_oom_trylock(struc
 			failed = iter;
 			mem_cgroup_iter_break(memcg, iter);
 			break;
-		} else
-			iter->oom_lock = true;
+		}
+		iter->oom_lock = true;
 	}
 
 	if (failed) {
_

Patches currently in -mm which might be from kerensun@google.com are



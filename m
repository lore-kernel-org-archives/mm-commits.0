Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E5255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744897; cv=none; b=PFRTmDXKR9KRfP9CAtTOksqbi9qO9BsBA/X3OH4dVxYANpR2X3R/zymOI/VI4vwAVR+wzj2LPQ+BD+Kc07CdjAqV6tZu7lc+ikI8kP6UiZDD2cmSq/lwdcBSh9iPbRmC7yhAzMMhS8kq3D2GXMA7AiTJBzoI38wx5RPUC/2dqBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744897; c=relaxed/simple;
	bh=pucT3nKpc3sAwJjagOPwoepfzAvG6pkddsqmVCaPS6c=;
	h=Date:To:From:Subject:Message-Id; b=iWHkC6EA6yGpUXP8q6AG/8VNPycc3x81bdf8fjJR5D44BMYVi3tH+WpxCpd6cuhdST1bjxTBsdxI2TYXLV641EDq78r7vXLD7Z9c9A0npBWt8IbwgZVQMhLZbv/ADRAe2dbfS/tjHAnNdoNMfrcVuSnXBQ9Jegb0O0laK5BQ+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JZHBnk52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JZHBnk52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F856C4CEF7;
	Sun, 29 Mar 2026 00:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744897;
	bh=pucT3nKpc3sAwJjagOPwoepfzAvG6pkddsqmVCaPS6c=;
	h=Date:To:From:Subject:From;
	b=JZHBnk52b6Cec4n5E7jHwmFqFhcDmXNLomMfFlenZvl9Hh8jxd2BH7cPbbppquq7Y
	 n6pdbPnjNigVJ0sx6iCNTcE+loI0u/9BOKRwAesWznAvE0RLnxzJZ3vVJJdTH4gF9V
	 93bJBhts71SdSV8usDajentA2pMaibykJfq7+z3c=
Date: Sat, 28 Mar 2026 17:41:36 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch removed from -mm tree
Message-Id: <20260329004137.4F856C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix wrong damon_set_regions() argument
has been removed from the -mm tree.  Its filename was
     mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix wrong damon_set_regions() argument
Date: Fri, 13 Mar 2026 16:49:08 -0700

The third argument is the length of the second parameter.  But addr_unit
is wrongly being passed.  Fix it.

Link: https://lkml.kernel.org/r/20260314001854.79623-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix
+++ a/mm/damon/core.c
@@ -3136,7 +3136,7 @@ int damon_set_region_biggest_system_ram_
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch


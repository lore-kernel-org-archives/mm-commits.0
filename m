Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458DB31771E
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 07:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755327852; cv=none; b=FS9d9cuWVvih8fBFwOY/i2Ino9yv/kTcCjP4FOdx44qvpYH45BCaJoIIiOXSZWq4YyHRhT1figVmhiFZzRw9EWWHO/+tMs6QK2+iJv2SjPDNixdnvrsmKIN8fw1SO/VxXhzqt/14wrmoJ84o3qtnJLnvz4kw409oUzXXCj1WJEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755327852; c=relaxed/simple;
	bh=1G9qXk8S8M8AxUrbV1SSnpVt6OiL+gmzrjYdChkgSvY=;
	h=Date:To:From:Subject:Message-Id; b=N7s4W+fqR/sAKpU0pQCgYnVqH1xkgGYddqIpdpx3GWHqghhZ8Hl2nwAZCl8OHqlzJ/upHeBSVJXM/MI/rzep1RuWi2oWmFaVHfM/JnnN+o2OAPy/Ne5fysL4VyhuKn4FUEPik/eRbM/kKUZ16HJL5GvtM2TDTk74MM8S/K+zU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUBTs0wS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUBTs0wS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF425C4CEEF;
	Sat, 16 Aug 2025 07:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755327850;
	bh=1G9qXk8S8M8AxUrbV1SSnpVt6OiL+gmzrjYdChkgSvY=;
	h=Date:To:From:Subject:From;
	b=lUBTs0wSIMLjDrlRvqThPcKfoMCj+q82ilD1lDUBWydsyhv5Aw6WPWN9shCXziR3s
	 OvYF1bbQHeA6cetpkoIA5azrk6OdnvqmDIndrReBAPMVymZhNwVQZBK4HU8oq9baWn
	 tm1Tsuai2IllbnACUssc0xl6Czy0FOedRpXC8CNU=
Date: Sat, 16 Aug 2025 00:04:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-kconfig-make-damon_stat_enabled_default-depend-on-damon_stat.patch added to mm-new branch
Message-Id: <20250816070410.AF425C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-kconfig-make-damon_stat_enabled_default-depend-on-damon_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-kconfig-make-damon_stat_enabled_default-depend-on-damon_stat.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT
Date: Fri, 15 Aug 2025 17:21:10 +0800

The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to DAMON_STAT
option -- enabling it alone is meaningless.  This patch makes
DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT, ensuring functional
consistency.

Link: https://lkml.kernel.org/r/20250815092110.811757-1-lienze@kylinos.cn
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-kconfig-make-damon_stat_enabled_default-depend-on-damon_stat
+++ a/mm/damon/Kconfig
@@ -104,7 +104,7 @@ config DAMON_STAT
 
 config DAMON_STAT_ENABLED_DEFAULT
 	bool "Enable DAMON_STAT by default"
-	depends on DAMON_PADDR
+	depends on DAMON_STAT
 	default DAMON_STAT
 	help
 	  Whether to enable DAMON_STAT by default.  Users can disable it in
_

Patches currently in -mm which might be from lienze@kylinos.cn are

selftests-damon-access_memory_even-remove-unused-header-file.patch
mm-damon-kconfig-make-damon_stat_enabled_default-depend-on-damon_stat.patch


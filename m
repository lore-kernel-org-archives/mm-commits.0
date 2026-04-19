Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E007309EEB;
	Sun, 19 Apr 2026 06:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776579949; cv=none; b=pg0tNnlQZOOk4jDQ7o9XY77axZAuchCBoVcvFi7cq2yYxAsZbjayl30NIQhlUfa+Aa+0eUBZW/FAzQ8QIp9zZC8Kqx0DbQQGyJeXjoIAaRwXWPlYkh148+AOT0qg+JHG65HDMMZ7PgFTH7OwVcPxF7/EcfSs2VdDgcJjYONCSDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776579949; c=relaxed/simple;
	bh=WyWP+iZMeXxYC6vQkXO3ZkU7TGgZD/42Ny6itpdy6rk=;
	h=Date:To:From:Subject:Message-Id; b=d/w2XwFEg72vmhiacDM+re0vI61eLYbRxnW+VvxHKVvUSemYBUfAIw2pkiK/Orv1MWoSJ8H7zwUgdyUGNuJeVyq0N3FYMiWsfTP8NEZAYnuXYIkN2DRkJlArVRiwEbpjGGtOGVeJ4mZ98lpxnbbgHTRNtAe1Zkwv4J+06mWjAJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YAfb/MEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YAfb/MEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68AFC2BCAF;
	Sun, 19 Apr 2026 06:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776579948;
	bh=WyWP+iZMeXxYC6vQkXO3ZkU7TGgZD/42Ny6itpdy6rk=;
	h=Date:To:From:Subject:From;
	b=YAfb/MEJcqlpuSFAFvc2/cwRsnWceTjhx4n/3tAy0CNOh0G1bkFRdAsbye9Hyosrz
	 lJ0+DXfAsmSY9GwNA/e8Pte80TqfscOUr2Sb2GnK4/HRRsPI+AfmC11oZHMFR0U3GJ
	 BsdjHfnp8C6MIYs305cyWLkkQtjpCl0tiJP7zuGk=
Date: Sat, 18 Apr 2026 23:25:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch removed from -mm tree
Message-Id: <20260419062547.C68AFC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: disallow non-power of two min_region_sz on damon_start()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: disallow non-power of two min_region_sz on damon_start()
Date: Sat, 11 Apr 2026 14:36:36 -0700

Commit d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region") introduced
a bug that allows unaligned DAMON region address ranges.  Commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
fixed it, but only for damon_commit_ctx() use case.  Still, DAMON sysfs
interface can emit non-power of two min_region_sz via damon_start().  Fix
the path by adding the is_power_of_2() check on damon_start().

The issue was discovered by sashiko [1].

Link: https://lore.kernel.org/20260411213638.77768-1-sj@kernel.org
Link: https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org [1]
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start
+++ a/mm/damon/core.c
@@ -1368,6 +1368,11 @@ int damon_start(struct damon_ctx **ctxs,
 	int i;
 	int err = 0;
 
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!is_power_of_2(ctxs[i]->min_region_sz))
+			return -EINVAL;
+	}
+
 	mutex_lock(&damon_lock);
 	if ((exclusive && nr_running_ctxs) ||
 			(!exclusive && running_exclusive_ctxs)) {
_

Patches currently in -mm which might be from sj@kernel.org are



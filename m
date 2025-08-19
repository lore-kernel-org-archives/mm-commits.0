Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E49826D4CF;
	Tue, 19 Aug 2025 23:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646611; cv=none; b=QZH1cgr+iMAy1kJipZzwj/S2t+4k1HN6brdQokN/ntcEi+ceoHx9LYoEJSLATKXtxUWa0RFrXA/SCMvZlA9EVugnd5ZdKUJqrhSUqsSZhFtiPDY/bUbgN8zFtms0i/9W7eCcx+dDNc4cJgLp6khUTCqzRnkUA/dlL9q4Vt/TgrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646611; c=relaxed/simple;
	bh=suR2l3suotWkuRdb77e7svdylqda4mWRC5LyR1aePpQ=;
	h=Date:To:From:Subject:Message-Id; b=HGBQRW7+mHcmTtwGMM3BqVJn8PKVp5uCifcITseC4f6Oy2VTy9h38lJKtyw45Og6y3sb7Cc17nh8TRZWp1vo2MIPaiQuB9lRC14RjhCgl5cUuIcSE58qik2QEB0KjsOuzbTbGR0fKn+Uk/yT3MCvXc6hbbcHTPyahbYxxiBy1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BIsjE4Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BIsjE4Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CF2C4CEF1;
	Tue, 19 Aug 2025 23:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646611;
	bh=suR2l3suotWkuRdb77e7svdylqda4mWRC5LyR1aePpQ=;
	h=Date:To:From:Subject:From;
	b=BIsjE4QneOKwkkqo6tWak5DHhXWeWncXlM1SbLVn2Smp3s1tWue9vmRtEcFM/NZqB
	 bWd9csCzNPKMjf5rvyA3Edqat4qIDefn4t0xVeW26WTkoWh8kENNRkKYI5hGuzSrIH
	 b1wX7QJxLQ+j0BGP/DhvstWY1zYuC3pz0NVn+2cw=
Date: Tue, 19 Aug 2025 16:36:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch removed from -mm tree
Message-Id: <20250819233651.35CF2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix damos_commit_filter not changing allow
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/core: fix damos_commit_filter not changing allow
Date: Sat, 16 Aug 2025 10:51:16 +0900

Current damos_commit_filter() does not persist the `allow' value of the
filter.  As a result, changing the `allow' value of a filter and
committing doesn't change the `allow' value.

Add the missing `allow' value update, so committing the filter
persistently changes the `allow' value well.

Link: https://lkml.kernel.org/r/20250816015116.194589-1-ekffu200098@gmail.com
Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-fix-damos_commit_filter-not-changing-allow
+++ a/mm/damon/core.c
@@ -883,6 +883,7 @@ static void damos_commit_filter(
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
+	dst->allow = src->allow;
 	damos_commit_filter_arg(dst, src);
 }
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch


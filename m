Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B59271462;
	Tue, 19 Aug 2025 23:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646595; cv=none; b=M6yLiZ6U2a7ewdTcLIHqzHzCpcoGkFvqmRdDUlpyMu8PDDaWD7aJNDRcdWNTHQZ0ua+47OBdX8nakS0QgEbKUyzYj6XCPDS7Hw1wXfpSjQo3CXAJniWHHbs6SZVjn9P1RNetKsIos5BOYO4vNjaRfydoc25xVejdX1eQL9ldZuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646595; c=relaxed/simple;
	bh=xEPAu2Y00CixaLigxWs6VHFwXfZVT5uxI4LOeFQkA78=;
	h=Date:To:From:Subject:Message-Id; b=fiK9oCMP0zarSVohJ5mBqfPooeZLVdG/LAfKlJ+7ZmJJX7V219QWMGxycfr2HfpcVOjOdUuMEGfniShiSBiC+sfu/PkJqlPZFT+Oia09cIg9/W8xl5Dnm5O0W6DQrjRXFPQA5OSW4wpsQn8F3rx/Z2x6osRXWLC4Ez5+uIkMPDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PpI/yQ2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PpI/yQ2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8B1C4CEF1;
	Tue, 19 Aug 2025 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646595;
	bh=xEPAu2Y00CixaLigxWs6VHFwXfZVT5uxI4LOeFQkA78=;
	h=Date:To:From:Subject:From;
	b=PpI/yQ2ijlgcdtcxy22kgyO9mKsVTM/9OVBdQWpkiMGN7ltEFzaMmfx2567VJvIdQ
	 OwabCeXpg/MlauyvfWyIxsjQmxCKmMXLu8DRMQLsFq9YsaJwQqoAkc+VrQJLyMT1Je
	 cNyU84nL//82nMM9ERwrhtaXAD/kkvoUnm0fdESA=
Date: Tue, 19 Aug 2025 16:36:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch removed from -mm tree
Message-Id: <20250819233635.4B8B1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix commit_ops_filters by using correct nth function
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Sun, 10 Aug 2025 21:42:01 +0900

damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
iterates core_filters.  As a result, performing a commit unintentionally
corrupts ops_filters.

Add damos_nth_ops_filter() which iterates ops_filters.  Use this function
to fix issues caused by wrong iteration.

Link: https://lkml.kernel.org/r/20250810124201.15743-1-ekffu200098@gmail.com
Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function
+++ a/mm/damon/core.c
@@ -845,6 +845,18 @@ static struct damos_filter *damos_nth_fi
 	return NULL;
 }
 
+static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_ops_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
 static void damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -908,7 +920,7 @@ static int damos_commit_ops_filters(stru
 	int i = 0, j = 0;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+		src_filter = damos_nth_ops_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch


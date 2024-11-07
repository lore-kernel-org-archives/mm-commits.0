Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B2218D98;
	Thu,  7 Nov 2024 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017729; cv=none; b=eBUP14zMCj621Xnf3FrsKHzQK5cD8gpbU8bHlt+RyJSkGoy9afsYSwkqLzB+ng6nHfNWEC9rVAEbyXsVLucqz3ZLBXVck5aatR43uVl+X0FlDkGpzPIQ8y8yZ9Io+5qjTe8J7qKskqHNuPO+hofsj6tocIN3FqyYLFunASOY0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017729; c=relaxed/simple;
	bh=lHt7elhCOF0hhOd0rklxnQQVnkjsyssAgNlunnkPMrM=;
	h=Date:To:From:Subject:Message-Id; b=J4SKDemKd2pnRP/TZap9OV2afV0jb2npgHWB4wFgjcdd7dQopC8+0W7hN+aKvYgtO5wyHfb6jP/zbPVNaRLXTAlZPdFmiwTUxgivKHaZ8slHqT4GaXtm3yUhG44VC83oksakXy4O9ZIwYHYqI4A1XBL91DkxR2RchkROpi3FQJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SbRl9WzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SbRl9WzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F35C4CECC;
	Thu,  7 Nov 2024 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017729;
	bh=lHt7elhCOF0hhOd0rklxnQQVnkjsyssAgNlunnkPMrM=;
	h=Date:To:From:Subject:From;
	b=SbRl9WzO6jl/l8VzPT/uCCVIOwi7JsQ2LQLVf3Gdnbn7cgi9oegMZiVIluwtt6XQe
	 8z8bSAL7JIv36DLe1cjaQYr2MuAqN2QGaQPtMRkVvfaEfZN05udczNC7GkNkBgHusz
	 RtnUE2mnJKvDTZ/Wd17Ej7ieNteSCpDeyQUe4wwo=
Date: Thu, 07 Nov 2024 14:15:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-handle-zero-schemes-apply-interval.patch removed from -mm tree
Message-Id: <20241107221529.14F35C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle zero schemes apply interval
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-zero-schemes-apply-interval.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: handle zero schemes apply interval
Date: Thu, 31 Oct 2024 11:37:57 -0700

DAMON's logics to determine if this is the time to apply damos schemes
assumes next_apply_sis is always set larger than current
passed_sample_intervals.  And therefore assume continuously incrementing
passed_sample_intervals will make it reaches to the next_apply_sis in
future.  The logic hence does apply the scheme and update next_apply_sis
only if passed_sample_intervals is same to next_apply_sis.

If Schemes apply interval is set as zero, however, next_apply_sis is set
same to current passed_sample_intervals, respectively.  And
passed_sample_intervals is incremented before doing the next_apply_sis
check.  Hence, next_apply_sis becomes larger than next_apply_sis, and the
logic says it is not the time to apply schemes and update next_apply_sis. 
In other words, DAMON stops applying schemes until passed_sample_intervals
overflows.

Based on the documents and the common sense, a reasonable behavior for
such inputs would be applying the schemes for every sampling interval. 
Handle the case by removing the assumption.

Link: https://lkml.kernel.org/r/20241031183757.49610-3-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-zero-schemes-apply-interval
+++ a/mm/damon/core.c
@@ -1412,7 +1412,7 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 
 		if (!s->wmarks.activated)
@@ -1622,7 +1622,7 @@ static void kdamond_apply_schemes(struct
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 
 		if (!s->wmarks.activated)
@@ -1642,9 +1642,9 @@ static void kdamond_apply_schemes(struct
 	}
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
-		s->next_apply_sis +=
+		s->next_apply_sis = c->passed_sample_intervals +
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch
docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch


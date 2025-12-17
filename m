Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9D192590
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766008300; cv=none; b=pvGl9zIEaRh/rMo6hx4ZHZKqHeryToy4OAoGSQKqtSDQCyfKzx+FWntMuR7uq9/GMFV158nj1+QCNVmtF5o20NBwq4fnBY14GNKzmMY9Rix6u+nChy2XhwDewlKk8HZOTzJXriztCwJImaDs3VMJ4PenO9A9COBAWVNRsFtFzKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766008300; c=relaxed/simple;
	bh=dXJVARMqpmOzPjGiLDPPwEUMjn/nX7tTbDw5H6C8Jlc=;
	h=Date:To:From:Subject:Message-Id; b=LnYviVMNuNn2L6XnNvC4rOfJYxu088uyYLzUGax27AyKhdP5Lvhl/2igr/OtPXhSpgoafY5VlptKjmUeL1t8w/ElzwwWekuurtGSESnkY22USe4++L3L15F/EbXjY/zwJTLnkeOnFc0H+3VzRo9eyYdphAFNbAie+U7OHPR7bPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JemO1wjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JemO1wjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18465C4CEF5;
	Wed, 17 Dec 2025 21:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766008300;
	bh=dXJVARMqpmOzPjGiLDPPwEUMjn/nX7tTbDw5H6C8Jlc=;
	h=Date:To:From:Subject:From;
	b=JemO1wjSBJjuAliz2omTIPU3loYogN/sPX9IR5cbo1NdJ8jzfBP5bY2iDScBfQRbg
	 KKhVfXgAs2qcMQywLDa6kxCMQkDC5lMcni7Nu1Ttxj304l8sy26m1caaavc4bKtPFW
	 PFBE+u1dUzHHS1pZMSR0uH4WvJeb+/MMRZuOHVgQ=
Date: Wed, 17 Dec 2025 13:51:39 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,klourencodev@gmail.com,kevin@desktop-mu90jgd.home,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-typos-in-comments.patch added to mm-new branch
Message-Id: <20251217215140.18465C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix typos in comments
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-fix-typos-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-typos-in-comments.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: kevin <kevin@desktop-mu90jgd.home>
Subject: mm/damon: fix typos in comments
Date: Wed, 17 Dec 2025 19:12:16 +0100

Correct minor spelling mistakes in several files under mm/damon.  No
functional changes.

Link: https://lkml.kernel.org/r/20251217181216.47576-1-klourencodev@gmail.com
Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    6 +++---
 mm/damon/lru_sort.c         |    2 +-
 mm/damon/reclaim.c          |    2 +-
 mm/damon/stat.c             |    2 +-
 mm/damon/tests/core-kunit.h |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-fix-typos-in-comments
+++ a/mm/damon/core.c
@@ -284,7 +284,7 @@ struct damos_filter *damos_new_filter(en
 }
 
 /**
- * damos_filter_for_ops() - Return if the filter is ops-hndled one.
+ * damos_filter_for_ops() - Return if the filter is ops-handled one.
  * @type:	type of the filter.
  *
  * Return: true if the filter of @type needs to be handled by ops layer, false
@@ -1586,7 +1586,7 @@ static unsigned long damon_get_intervals
 	adaptation_bp = damon_feed_loop_next_input(100000000, score_bp) /
 		10000;
 	/*
-	 * adaptaion_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
+	 * adaptation_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
 	 * the intervals by rescaling [1,10,000] to [5000, 10,000].
 	 */
 	if (adaptation_bp <= 10000)
@@ -2756,7 +2756,7 @@ static int kdamond_fn(void *data)
 				 *
 				 * Reset ->next_aggregation_sis to avoid that.
 				 * It will anyway correctly updated after this
-				 * if caluse.
+				 * if clause.
 				 */
 				ctx->next_aggregation_sis =
 					next_aggregation_sis;
--- a/mm/damon/lru_sort.c~mm-damon-fix-typos-in-comments
+++ a/mm/damon/lru_sort.c
@@ -34,7 +34,7 @@ static bool enabled __read_mostly;
  *
  * Input parameters that updated while DAMON_LRU_SORT is running are not
  * applied by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT
- * reads values of parametrs except ``enabled`` again.  Once the re-reading is
+ * reads values of parameters except ``enabled`` again.  Once the re-reading is
  * done, this parameter is set as ``N``.  If invalid parameters are found while
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
--- a/mm/damon/reclaim.c~mm-damon-fix-typos-in-comments
+++ a/mm/damon/reclaim.c
@@ -34,7 +34,7 @@ static bool enabled __read_mostly;
  *
  * Input parameters that updated while DAMON_RECLAIM is running are not applied
  * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
- * of parametrs except ``enabled`` again.  Once the re-reading is done, this
+ * of parameters except ``enabled`` again.  Once the re-reading is done, this
  * parameter is set as ``N``.  If invalid parameters are found while the
  * re-reading, DAMON_RECLAIM will be disabled.
  */
--- a/mm/damon/stat.c~mm-damon-fix-typos-in-comments
+++ a/mm/damon/stat.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Shows data access monitoring resutls in simple metrics.
+ * Shows data access monitoring results in simple metrics.
  */
 
 #define pr_fmt(fmt) "damon-stat: " fmt
--- a/mm/damon/tests/core-kunit.h~mm-damon-fix-typos-in-comments
+++ a/mm/damon/tests/core-kunit.h
@@ -1159,7 +1159,7 @@ static void damon_test_set_filters_defau
 	damos_set_filters_default_reject(&scheme);
 	/*
 	 * A core-handled allow-filter is installed.
-	 * Rejct by default on core layer filtering stage due to the last
+	 * Reject by default on core layer filtering stage due to the last
 	 * core-layer-filter's behavior.
 	 * Allow by default on ops layer filtering stage due to the absence of
 	 * ops layer filters.
_

Patches currently in -mm which might be from kevin@desktop-mu90jgd.home are

mm-damon-fix-typos-in-comments.patch


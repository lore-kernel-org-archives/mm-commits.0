Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E9F1B7F4
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966094; cv=none; b=Uv0lxhZwk0m+8TUSRmW2RKEjSnd/cpFMzQtXrT/p+78ycrzxhJ3KMxtlY3zhya2Mco+5Z6R9jgsY9yBCiNhE7HZzOmwQbzu1CqPJtOoMFBFSBVC6yGeDhkqVlIKBwzm8OsW8o2MB+jvd5wr85YABHAetrysAuhYjeKMYKaUDy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966094; c=relaxed/simple;
	bh=leJrfPsiDPlMAb5zxpPJGYzFwPNFtJg3IHjuiLo3XkQ=;
	h=Date:To:From:Subject:Message-Id; b=J5uG5Twop2SGUNK1AhHabuti3p996rRqkPxOS8/MlpUx57OWiEAPrnYy0VyKN2isJvpzd86t0JAR49gew/ahb7adr+Yg8gqeBQlbHGtkreZ7DU0UgRnmZ5I72DIlBF2L/U3EUAEXW5lNutuim9PESiR1oAaVwM0pYa6ZTZ+iTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S7tpoYdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7tpoYdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2123C16AAE;
	Wed, 21 Jan 2026 03:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966093;
	bh=leJrfPsiDPlMAb5zxpPJGYzFwPNFtJg3IHjuiLo3XkQ=;
	h=Date:To:From:Subject:From;
	b=S7tpoYdD8fDHfA6KAMS2LjpNDXNZuWBQUfYmcUEpA/wmNVEpfe1B22OyXlRQgfaIV
	 yncLAA6mziU8ubet0A1LRo8cSGSpRWEzmRWiFofgSWNgV4ucwicUmX7qLtOk5dfJlK
	 AhCyX1p6nmSQPtRg0XflWsH8kKWgGQpJVX8ZPgPI=
Date: Tue, 20 Jan 2026 19:28:13 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,klourencodev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20260121032813.C2123C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-typos-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Lourenco <klourencodev@gmail.com>
Subject: mm/damon: fix typos in comments
Date: Wed, 17 Dec 2025 19:12:16 +0100

Correct minor spelling mistakes in several files under mm/damon.  No
functional changes.

Link: https://lkml.kernel.org/r/20251217181216.47576-1-klourencodev@gmail.com
Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
@@ -1615,7 +1615,7 @@ static unsigned long damon_get_intervals
 	adaptation_bp = damon_feed_loop_next_input(100000000, score_bp) /
 		10000;
 	/*
-	 * adaptaion_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
+	 * adaptation_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
 	 * the intervals by rescaling [1,10,000] to [5000, 10,000].
 	 */
 	if (adaptation_bp <= 10000)
@@ -2789,7 +2789,7 @@ static int kdamond_fn(void *data)
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

Patches currently in -mm which might be from klourencodev@gmail.com are

mm-fadvise-validate-offset-in-generic_fadvise.patch


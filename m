Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F87D3232
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837146; cv=none; b=dZt6wFC4miRyvFn9BnxNXQ89D5QoazKOsFA08GIwowDcX7ZLcCexNr+XRQKC4E195mZ4B7xzj7hr3TLyNCzQHnn7QHVaexNqe5qEPwe36zez5eg08aYVp3Ja28RS6Y5x31yZ2xtEDBFE9NKZVFuL+7whLZW2Vd95CqhGWpNji1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837146; c=relaxed/simple;
	bh=4QuyUisfqiXLmhGk5Re4+om3j29S8AX0P3d0eBNGZYg=;
	h=Date:To:From:Subject:Message-Id; b=dD4yf/lMaDTIwQ3wTN4LF4RqXf8rqD2i8GpTt98HjJM6ACa2+Q9g8XmkrSC6Lf9hab3pA1btrFlO8c7p7YM4Xd/PcOHHK66GXYKPUR2dGf+eNn23boQPA0Z7XwjEr+IUL3R9yTSO5uC+uY90BigKY9rthIm1DITLEhJiVpatjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CBk4aBlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CBk4aBlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42140C4CEDD;
	Tue, 14 Jan 2025 06:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837146;
	bh=4QuyUisfqiXLmhGk5Re4+om3j29S8AX0P3d0eBNGZYg=;
	h=Date:To:From:Subject:From;
	b=CBk4aBlGqehbh6L5dYpjaijG7xn3tB321l6qj9Ak2/kBBO/ZTQ7PWX5onInUS5HzF
	 dRZ2HIsJOBW2yHSc6r+F0BkIh9uDlGG4E8G3bdvKjEgRHeTb9C+5quUAfXhA0Vu/hz
	 s6FRPqk2gLNf7ho2hwY7aNAONsdCYH+VDESjG7FI=
Date: Mon, 13 Jan 2025 22:45:45 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch removed from -mm tree
Message-Id: <20250114064546.42140C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: remove unnecessary schemes existence check in damon_sysfs_schemes_clear_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: remove unnecessary schemes existence check in damon_sysfs_schemes_clear_regions()
Date: Fri, 3 Jan 2025 09:43:51 -0800

Patch series "mm/damon: replace most damon_callback usages in sysfs with
new core functions".

DAMON provides damon_callback API that notifies monitoring events and
allows safe access to damon_ctx internal data.  The usage is simple. 
Users register and deregister callback functions for different monitoring
events in damon_ctx.  Then the DAMON worker thread (kdamond) of the
damon_ctx calls back the registered functions on the events.

It is designed in such simple way because it was sufficient for usages of
DAMON at the early days.  We also wanted to make it flexible so that API
user code can implement any required additional features on top of
damon_callback on their demands.

As expected, more sophisticated usages have invented.  Online updates of
DAMON parameters and DAMOS auto-tuning inputs, and online retrieval of
DAMOS statistics and tried regions information are such usages.  Because
damon_callback doesn't provide any explicit synchronization mechanism, the
user ABIs for exposing such functionalities are implemented in
asynchronous ways (DAMON_RECLAIM and DAMON_LRU_SORT}), or synchronous ways
(DAMON_SYSFS) with additional synchronization mechanisms that built inside
the ABI implementation, on top of damon_callback.

So damon_callback is working as expected.  However, the additional
mechanisms built inside ABI on top of damon_callback is becoming somewhat
too big and not easy to maintain.  The additional mechanisms can be
smaller and easier to maintain when implemented inside the core logic
layer.

Introduce two new DAMON core API, namely 'damon_call()' and
'damos_walk()'.  The two functions support synchronous access to
- damon_ctx internal data including DAMON parameters and monitoring
  results, and
- DAMOS-specific data such as regions that each DAMOS action is applied,
respectively.

And replace most of damon_callback usages in DAMON sysfs interface with
the new core API functions.  damon_callback usage for online DAMON
parameters tuning is not replaced in this series, since it has specific
callback timing assumptions that require more works.

Patch sequence
==============

First two patches are fixups for simplifying the following changes.  Those
remove a unnecessary condition check and a synchronization, respectively.

Third patch implements one of the new DAMON core APIs, namely
damon_call().  Three patches replacing damon_callback usages in DAMON
sysfs interface using damon_call() follow.

Then, seventh and eighth patches introduces the other new DAMON API,
damos_walk(), and document it on the design doc.  Ninth patch replaces two
damon_callback usages in DAMON sysfs interface using damos_walk().

The tenth patch finally cleans up code that no more being used.


This patch (of 10):

damon_sysfs_schemes_clear_regions() skips removing the scheme tried region
directories only if the matching scheme is still ongoing.  It is
unnecessary check, since what users want is just removing the entire
region directories.  Remove the unnecessary check.

Link: https://lkml.kernel.org/r/20250103174400.54890-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250103174400.54890-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    3 +--
 mm/damon/sysfs-schemes.c |   16 +++++-----------
 mm/damon/sysfs.c         |    2 +-
 3 files changed, 7 insertions(+), 14 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions
+++ a/mm/damon/sysfs.c
@@ -1262,7 +1262,7 @@ static int damon_sysfs_clear_schemes_reg
 	if (!ctx)
 		return -EINVAL;
 	return damon_sysfs_schemes_clear_regions(
-			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+			kdamond->contexts->contexts_arr[0]->schemes);
 }
 
 static inline bool damon_sysfs_kdamond_running(
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions
+++ a/mm/damon/sysfs-common.h
@@ -56,8 +56,7 @@ bool damos_sysfs_regions_upd_done(void);
 int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
 
 int damon_sysfs_schemes_clear_regions(
-		struct damon_sysfs_schemes *sysfs_schemes,
-		struct damon_ctx *ctx);
+		struct damon_sysfs_schemes *sysfs_schemes);
 
 int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions
+++ a/mm/damon/sysfs-schemes.c
@@ -2208,20 +2208,14 @@ void damos_sysfs_mark_finished_regions_u
 
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
 int damon_sysfs_schemes_clear_regions(
-		struct damon_sysfs_schemes *sysfs_schemes,
-		struct damon_ctx *ctx)
+		struct damon_sysfs_schemes *sysfs_schemes)
 {
-	struct damos *scheme;
-	int schemes_idx = 0;
+	int i;
 
-	damon_for_each_scheme(scheme, ctx) {
+	for (i = 0; i < sysfs_schemes->nr; i++) {
 		struct damon_sysfs_scheme *sysfs_scheme;
 
-		/* user could have removed the scheme sysfs dir */
-		if (schemes_idx >= sysfs_schemes->nr)
-			break;
-
-		sysfs_scheme = sysfs_schemes->schemes_arr[schemes_idx++];
+		sysfs_scheme = sysfs_schemes->schemes_arr[i];
 		damon_sysfs_scheme_regions_rm_dirs(
 				sysfs_scheme->tried_regions);
 		sysfs_scheme->tried_regions->total_bytes = 0;
@@ -2271,7 +2265,7 @@ int damon_sysfs_schemes_update_regions_s
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, bool total_bytes_only)
 {
-	damon_sysfs_schemes_clear_regions(sysfs_schemes, ctx);
+	damon_sysfs_schemes_clear_regions(sysfs_schemes);
 	damon_sysfs_schemes_for_damos_callback = sysfs_schemes;
 	damos_tried_regions_init_upd_status(sysfs_schemes, ctx);
 	damos_regions_upd_total_bytes_only = total_bytes_only;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


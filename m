Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D97136351
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958709; cv=none; b=LaYL2UnQLgYUJKLbUtExXM+qJJbY8ACpj2FuKrVR7eL8+keVDZ5n5VSJjhyhoK7UWiKyGuaTK6TgeqGxLJOfkWrx/rndyme2I8ICoDtfMrwagQNnVJ7l2JlCSDViEErUdHgRHlACaedhPIEuLVKNYM3Bsj1wUTnYpElhhFKXD1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958709; c=relaxed/simple;
	bh=nlPdXRfOYxxiNgmXPr1ePtHPI/3vwgjGOuzyLUTTfG8=;
	h=Date:To:From:Subject:Message-Id; b=JKiCRsIo3d7VokZe6LKTP7qYw5qoU0x5v7sSaP6U1U0jBJKoBNAGXoTNxtCLwtnW3bLl5DJmN6cISIASuXaS8c2MUWUtlvcccR/oZP6fDC98+gKCpe8Xjzyj6HknrSaujI7nd5l8+7D+BEPmXO+9KYRlX6smUCbu9CY6VVL1Cxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=txHU4q1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="txHU4q1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DD5C4CED6;
	Sat,  4 Jan 2025 02:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958709;
	bh=nlPdXRfOYxxiNgmXPr1ePtHPI/3vwgjGOuzyLUTTfG8=;
	h=Date:To:From:Subject:From;
	b=txHU4q1ahMfXi5wnSz0uV4wUfgiPvolHU5rhJsJaIkSGpBw7hx+x1yMWVJ0ZGUnPw
	 0sdCnG7Io0NIDLIwAcwAPzTbEGp5iY6ICp00tVk1j1DQsCFi0VFXMsTRY2f9yPav+F
	 b9kn/4gcKisUl4fQMb0R7ISNB0dpkfrfKIz10MD0=
Date: Fri, 03 Jan 2025 18:45:08 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch added to mm-unstable branch
Message-Id: <20250104024509.51DD5C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: remove unnecessary schemes existence check in damon_sysfs_schemes_clear_regions()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch


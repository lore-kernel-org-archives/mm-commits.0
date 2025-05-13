Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B62EEEA6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 01:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747099085; cv=none; b=pMXJNAa4nP6gbQXRGoDhixwgsXHQxk/0GmlhSp/VrfqkM7gsv9HsSPftuBVNXHmWqnnOdKV9cvJVoPfntfCKyvTYqTe56y+nbGdGLxpEqI5u4SxB+zFH+L9yei4lqNjJVZU2RD5Z2TrFcPecdRbSpJlb+rhAUmDhgCveBq69Sh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747099085; c=relaxed/simple;
	bh=Kf0/t3vJViQXC21xsweX07CDK3g+eLWfCEBtoQE9qFQ=;
	h=Date:To:From:Subject:Message-Id; b=kWRa900mpN+w/dZElYYXsg6/o0nh6WmlpvpwcEI58z6N2gbRFLGEHq6vIx8ke3Jiul8w/3pFF/SfCHZLNvxUJCtYa1j1hGJk/5qO+Ct0ExZGL+AJAug5EvzDBUWweX6HHLSwgSI22dkS6PXeBIibzlPELyDosisiVvELhRvOEuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mq1ifJb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mq1ifJb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9564C4CEE7;
	Tue, 13 May 2025 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747099084;
	bh=Kf0/t3vJViQXC21xsweX07CDK3g+eLWfCEBtoQE9qFQ=;
	h=Date:To:From:Subject:From;
	b=mq1ifJb70dAOHa0XpEdEXB+P2ikK/CXODY3lh1X29aO8XwufGegdQ9PP3QzjftHw8
	 MmDlAStxCZfVYGW4cQCVYd4+Sz0yl+xEx0P//7F4IbqppMAniXg20bLCF3BKW72lCo
	 LcLT3hiDt/Axq72mTEmZV2AxeG8Z6XmUbvEy3srY=
Date: Mon, 12 May 2025 18:18:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-warn-and-fix-nr_accesses-corruption.patch added to mm-new branch
Message-Id: <20250513011804.C9564C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: warn and fix nr_accesses[_bp] corruption
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-warn-and-fix-nr_accesses-corruption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-warn-and-fix-nr_accesses-corruption.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: warn and fix nr_accesses[_bp] corruption
Date: Mon, 12 May 2025 17:27:10 -0700

Patch series "mm/damon: minor fixups and improvements for code, tests, and
documents".

Yet another batch of miscellaneous DAMON changes.  Fix and improve minor
problems in code, tests and documents.


This patch (of 6):

For a bug such as double aggregation reset[1], ->nr_accesses and/or
->nr_accesses_bp of damon_region could be corrupted.  Such corruption can
make monitoring results pretty inaccurate, so the root causing bug should
be investigated.  Meanwhile, the corruption itself can easily be fixed but
silently fixing it will hide the bug.

Fix the corruption as soon as found, but WARN_ONCE() so that we can be
aware of the existence of the bug while keeping the system running in a
more sane way.

Link: https://lkml.kernel.org/r/20250513002715.40126-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250513002715.40126-2-sj@kernel.org
Link: https://lore.kernel.org/20250302214145.356806-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-warn-and-fix-nr_accesses-corruption
+++ a/mm/damon/core.c
@@ -1392,6 +1392,19 @@ int damos_walk(struct damon_ctx *ctx, st
 }
 
 /*
+ * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
+ * the problem being propagated.
+ */
+static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
+{
+	if (r->nr_accesses_bp == r->nr_accesses * 10000)
+		return;
+	WARN_ONCE(true, "invalid nr_accesses_bp at reset: %u %u\n",
+			r->nr_accesses_bp, r->nr_accesses);
+	r->nr_accesses_bp = r->nr_accesses * 10000;
+}
+
+/*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
 static void kdamond_reset_aggregated(struct damon_ctx *c)
@@ -1404,6 +1417,7 @@ static void kdamond_reset_aggregated(str
 
 		damon_for_each_region(r, t) {
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch
mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch


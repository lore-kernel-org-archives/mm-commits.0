Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FD5213E89
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303180; cv=none; b=CifPvrtlwpRaEhHwl6HnYe4+SSySR3nicwjlp4kQdksDoXrWCFKzjf1tH2N2y0kL9PrYL3r9TgrYNoPP2Bi+HVXnO5XIzUebZgnd8vNKGtSqeGSTx0mVsfre18ngGPe59520AOd5DNF+H/KcIzutNCggSmGL82/LbERitUqkFx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303180; c=relaxed/simple;
	bh=kDEi7j4SnKgJ0Hc0ccGXVdyxQSrBSWl7mLe+xGBKZQU=;
	h=Date:To:From:Subject:Message-Id; b=Zy5hrOmaffcGU2FSW1jIPOeQs72EK9ixNapdR8WTxAKRZtdrbwQ0o0fjPWZQl+OmUI7rMGzxNPHbEBT9+ETLqcSQAdc2EJvIcQ7yiLaaODdn2gqv6BqXYjvaz6wMWIaGTOy2YOD6mNSbQMfNzPZ2rdqmgf1ULrs3Zcut8icVHY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lDtI+O99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lDtI+O99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CB6C19425;
	Mon, 27 Apr 2026 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777303179;
	bh=kDEi7j4SnKgJ0Hc0ccGXVdyxQSrBSWl7mLe+xGBKZQU=;
	h=Date:To:From:Subject:From;
	b=lDtI+O99tQ8IeLg4avGa5fx7DkQRF0/mlDifV4N15TbbGi6B+u4rN515vQbOntD1U
	 rt19iwbmVKtwez/uKkd2AqjRnUmee/DqNd7eZTdHsbc/ZGvgHOZSlcvGcl8t2hYdni
	 93hlGGMqsLrJlANFsrf7SCCLMLV1h4zN9aZVTWXM=
Date: Mon, 27 Apr 2026 08:19:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_ctx-paused.patch added to mm-new branch
Message-Id: <20260427151939.90CB6C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damon_ctx->paused
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_ctx-paused.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_ctx-paused.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_ctx->paused
Date: Mon, 27 Apr 2026 08:12:20 -0700

Patch series "mm/damon: let DAMON be paused and resumed", v2.

DAMON utilizes a few mechanisms that enhance itself over time.  Adaptive
regions adjustment, goal-based DAMOS quota auto-tuning and monitoring
intervals auto-tuning like self-training mechanisms are such examples.  It
also adds access frequency stability information (age) to the monitoring
results, which makes it enhanced over time.

Sometimes users have to stop DAMON.  In this case, DAMON internal state
that enhanced over the time of the last execution simply goes away. 
Restarted DAMON have to train itself and enhance its output from the
scratch.  This makes DAMON less useful in such cases.  Introducing three
such use cases below.

Investigation of DAMON.  It is best to do the investigation online,
especially when it is a production environment.  DAMON therefore provides
features for such online investigations, including DAMOS stats, monitoring
result snapshot exposure, and multiple tracepoints.  When those are
insufficient, and there are additional clues that could be interfered by
DAMON, users have to temporarily stop DAMON to collect the additional
clues.  It is not very useful since many of DAMON internal clues are gone
when DAMON is stopped.  The loss of the monitoring results that improved
over time is also problematic, especially in production environments.

Monitoring of workloads that have different user-known phases.  For
example, in Android, applications are known to have very different access
patterns and behaviors when they are running on the foreground and the
background.  It can therefore be useful to separate monitoring of apps
based on whether they are running on the foreground and on the background.
Having two DAMON threads per application that paused and resumed for the
apps foreground/background switches can be useful for the purpose.  But
such pause/resume of the execution is not supported.

Tests of DAMON.  A few DAMON selftests are using drgn to dump the internal
DAMON status.  The tests show if the dumped status is the same as what the
test code expected.  Because DAMON keeps running and modifying its
internal status, there are chances of data races that can cause false test
results.  Stopping DAMON can avoid the race.  But, since the internal
state of DAMON is dropped, the test coverage will be limited.

Let DAMON execution be paused and resumed without loss of the internal
state, to overhaul the limitations.  For this, introduce a new DAMON
context parameter, namely 'pause'.  API callers can update it while the
context is running, using the online parameters update functions
(damon_commit_ctx() and damon_call()).  Once it is set, kdamond_fn() main
loop will do only limited works excluding the monitoring and DAMOS works,
while sleeping sampling intervals per the work.  The limited works include
handling of the online parameters update.  Hence users can unset the
'pause' parameter again.  Once it is unset, kdamond_fn() main loop will do
all the work again (resumed).  Under the paused state, it also does stop
condition checks and handling of it, so that paused DAMON can also be
stopped if needed.  Expose the feature to the user space via DAMON sysfs
interface.  Also, update existing drgn-based tests to test and use the
feature.

Tests
=====

I confirmed the feature functionality using real time tracing ('perf
trace' or 'trace-cmd stream') of damon:damon_aggregated DAMON tracepoint. 
By pausing and resuming the DAMON execution, I was able to see the trace
stops and continued as expected.  Note that the pause feature support is
added to DAMON user-space tool (damo) after v3.1.9.  Users can use
'--pause_ctx' command line option of damo for that, and I actually used it
for my test.  The extended drgn-based selftests are also testing a part of
the functionality.

Patches Sequence
================

Patch 1 introduces the new core API for the pause feature.  Patch 2 extend
DAMON sysfs interface for the new parameter.  Patches 3-5 update design,
usage and ABI documents for the new sysfs file, respectively.  The
following five patches are for tests.  Patch 6 implements a new kunit test
for the pause parameter online commitment.  Patches 7 and 8 extend DAMON
selftest helpers to support the new feature.  Patch 9 extends selftest to
test the commitment of the feature.  Finally, patch 10 updates existing
selftest to be safe from the race condition using the pause/resume
feature.


This patch (of 10):

DAMON supports only start and stop of the execution.  When it is stopped,
its internal data that it self-trained goes away.  It will be useful if
the execution can be paused and resumed with the previous self-trained
data.

Introduce per-context API parameter, 'paused', for the purpose.  The
parameter can be set and unset while DAMON is running and paused, using
the online parameters commit helper functions (damon_commit_ctx() and
damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does only
limited works with sampling interval sleep during the works.  The limited
works include the handling of the online parameters update, so that users
can unset the 'pause' and resume the execution when they want.  It also
keep checking DAMON stop conditions and handling of it, so that DAMON can
be stopped while paused if needed.

Link: https://lore.kernel.org/20260427151231.113429-1-sj@kernel.org
Link: https://lore.kernel.org/20260427151231.113429-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    9 +++++++++
 2 files changed, 11 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_ctx-paused
+++ a/include/linux/damon.h
@@ -789,6 +789,7 @@ struct damon_attrs {
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
+ * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -842,6 +843,7 @@ struct damon_ctx {
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
+	bool pause;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_ctx-paused
+++ a/mm/damon/core.c
@@ -1349,6 +1349,7 @@ int damon_commit_ctx(struct damon_ctx *d
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -3014,6 +3015,14 @@ static int kdamond_fn(void *data)
 		kdamond_call(ctx, false);
 		if (ctx->maybe_corrupted)
 			break;
+		while (ctx->pause) {
+			damos_walk_cancel(ctx);
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
+				goto done;
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch


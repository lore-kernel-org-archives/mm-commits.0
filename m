Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36C8446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739441; cv=none; b=UsVponTe/BT7MC7G9k/GzxNH1xSUKoU3hWEW54kv7JPsI5hp303LAO4zwhTYFEl4rE/wt6kOYZ5OV68uexwxHltpLyG6xftM7L+L3iaPXfx7fj49D4TTtLNQqnvowGHK7e6IlBfTVdpQXCYhwxLq5E3q6yBX41Bu+vxmqRRPweA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739441; c=relaxed/simple;
	bh=Kz1kDacPBYtan2opijll8XTEJuhmKPSQQxYgEZnKJ6s=;
	h=Date:To:From:Subject:Message-Id; b=dmi80kV0cLkt+LV3pnfN4GiPtu3Uu1iBMQUSXxrk8e5nQWxBOVrPdneCPBKdUAjjxce/6cuoiqRIqBP/cNkeSgmWQSHB/zqKItk/w6G+kYVypfMmEcX8i1ib9e5WvKrIlM/Ki2nP5gWmGze/2UQIoaf91kk/d8sWxW8zrNxf8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUQ7XAXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUQ7XAXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5658AC4CEC6;
	Thu, 24 Oct 2024 03:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739441;
	bh=Kz1kDacPBYtan2opijll8XTEJuhmKPSQQxYgEZnKJ6s=;
	h=Date:To:From:Subject:From;
	b=nUQ7XAXjgZRdXlcZG7Be8qlMV1kAOeuriS+sgULyyZIvwiusaNtCe7FdUxehRLBP6
	 oMTfQlD86FEn/wFdoJCr3wwAgP1DQkNOcTmSW9HisfhnFkCw5txFqmMZ8HycE048bR
	 yeCXk38UblcKApgKg/p3jUFtIuxCa8ICq/BdWICU=
Date: Wed, 23 Oct 2024 20:10:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031041.5658AC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs: clean up duplicate min_heap_callbacks declarations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcachefs: clean up duplicate min_heap_callbacks declarations
Date: Sun, 20 Oct 2024 12:01:58 +0800

Refactor the bcachefs code to remove multiple redundant declarations of
min_heap_callbacks, ensuring that each unique declaration appears only
once.

Link: https://lore.kernel.org/20241017095520.GV16066@noisy.programming.kicks-ass.net
Link: https://lkml.kernel.org/r/20241020040200.939973-9-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/clock.c |   19 +++++--------------
 fs/bcachefs/ec.c    |   19 +++++--------------
 2 files changed, 10 insertions(+), 28 deletions(-)

--- a/fs/bcachefs/clock.c~bcachefs-clean-up-duplicate-min_heap_callbacks-declarations
+++ a/fs/bcachefs/clock.c
@@ -22,13 +22,13 @@ static inline void io_timer_swp(void *l,
 	swap(*_l, *_r);
 }
 
+static const struct min_heap_callbacks callbacks = {
+	.less = io_timer_cmp,
+	.swp = io_timer_swp,
+};
+
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = io_timer_cmp,
-		.swp = io_timer_swp,
-	};
-
 	spin_lock(&clock->timer_lock);
 
 	if (time_after_eq64((u64) atomic64_read(&clock->now), timer->expire)) {
@@ -48,11 +48,6 @@ out:
 
 void bch2_io_timer_del(struct io_clock *clock, struct io_timer *timer)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = io_timer_cmp,
-		.swp = io_timer_swp,
-	};
-
 	spin_lock(&clock->timer_lock);
 
 	for (size_t i = 0; i < clock->timers.nr; i++)
@@ -142,10 +137,6 @@ void bch2_kthread_io_clock_wait(struct i
 static struct io_timer *get_expired_timer(struct io_clock *clock, u64 now)
 {
 	struct io_timer *ret = NULL;
-	const struct min_heap_callbacks callbacks = {
-		.less = io_timer_cmp,
-		.swp = io_timer_swp,
-	};
 
 	if (clock->timers.nr &&
 	    time_after_eq64(now, clock->timers.data[0]->expire)) {
--- a/fs/bcachefs/ec.c~bcachefs-clean-up-duplicate-min_heap_callbacks-declarations
+++ a/fs/bcachefs/ec.c
@@ -1057,6 +1057,11 @@ static inline void ec_stripes_heap_swap(
 	ec_stripes_heap_set_backpointer(_h, j);
 }
 
+static const struct min_heap_callbacks callbacks = {
+	.less = ec_stripes_heap_cmp,
+	.swp = ec_stripes_heap_swap,
+};
+
 static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 {
 	ec_stripes_heap *h = &c->ec_stripes_heap;
@@ -1069,11 +1074,6 @@ static void heap_verify_backpointer(stru
 void bch2_stripes_heap_del(struct bch_fs *c,
 			   struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
-
 	mutex_lock(&c->ec_stripes_heap_lock);
 	heap_verify_backpointer(c, idx);
 
@@ -1084,11 +1084,6 @@ void bch2_stripes_heap_del(struct bch_fs
 void bch2_stripes_heap_insert(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
-
 	mutex_lock(&c->ec_stripes_heap_lock);
 	BUG_ON(min_heap_full(&c->ec_stripes_heap));
 
@@ -1107,10 +1102,6 @@ void bch2_stripes_heap_insert(struct bch
 void bch2_stripes_heap_update(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	bool do_deletes;
 	size_t i;
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch
lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch
lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch
lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch
lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch
perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch
dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch
bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch
documentation-core-api-add-min-heap-api-introduction.patch


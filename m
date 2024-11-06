Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D38824A3
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855649; cv=none; b=imn1sVyryhkl09ptn28gRI+5LRm+KZthMv66gpkSCDtCLnlzzYxZkXuXh+HxtRsjqo8m5FeASK/HmhwgC8KXCSNqfdsI+XKpGIdhVM7wcl38WokWTs3JvW+CHP7jvgxJmkkr1crfU7V1Xs3bXhWMZLJZRm7pggE6UpATqmxYBvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855649; c=relaxed/simple;
	bh=x8h9mXuUF5f8VOFRE/3DOtOkN1RV/jE/6E9tYtYGdXk=;
	h=Date:To:From:Subject:Message-Id; b=R8DdctZNhYMgbFkYwACJJ8C24f0pfarrwbysIrn+AsC7IKGsR9Ovvr0/gg7zgdDBHhg297gEDCq714kHaSt9grPflaJTtLGrWQSksGr+sz/0LZ2a52TApznkEaotnxxmjTe9xfbEicE+3C15kqEq0sCofYLW6JJKdBYx4efCnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YbcGeOL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YbcGeOL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D78DC4CECF;
	Wed,  6 Nov 2024 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855649;
	bh=x8h9mXuUF5f8VOFRE/3DOtOkN1RV/jE/6E9tYtYGdXk=;
	h=Date:To:From:Subject:From;
	b=YbcGeOL6F8oV2TSyGxNwYvSgp7FdprUk4cB73d59GAE6DzNjPi9kjlNQ/UGWP62bs
	 ya34HF5CqH00i6aqqVtgxqXVSSf29Po4dQ6h7uQuiV8AE89xvLpKk4+AEY1h5lp2zD
	 wBi3YN/U9FQIl/t/+MN8vy3/3KkjkQulduVSVgG0=
Date: Tue, 05 Nov 2024 17:14:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch removed from -mm tree
Message-Id: <20241106011409.6D78DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs: clean up duplicate min_heap_callbacks declarations
has been removed from the -mm tree.  Its filename was
     bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



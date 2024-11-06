Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF3A824A3
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855650; cv=none; b=WfrTGbfM1GBJOaxyHWJTRXorvAXrd44PhpYLGKe7AV9/tDc6nePZACcdrcg0BPFMblMgDa1BwUVXuB2o0F8PSmk72ZFkZcbpjBlw58p8rtxAjWB0e6XTtpG0PL7/qsS6auIefdFaHjuwr2eV+cTAIEhyyG0XQTB/ohwxCpzHYNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855650; c=relaxed/simple;
	bh=YsKp7Kf8t+PjYvXlcLtARG4OWrZz5OJtmxcg4lDUUrY=;
	h=Date:To:From:Subject:Message-Id; b=G6pCXUqTzzC97VYuwkbPzFx0BUts8XiAxMH8frqe4f+GZg61k05mMlXjPMSBqTTVOtPi07p37eEMCvW/I4YXvxw2D0B2pAZ1ZF5kYYJzr3h4gvUjalaJtH/r5vJzTsqEo0szYmKZBT4FckPq+OmHbtcW3qERvIu/PFZkEcZ7DjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jEq8dX4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jEq8dX4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00CDC4CECF;
	Wed,  6 Nov 2024 01:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855650;
	bh=YsKp7Kf8t+PjYvXlcLtARG4OWrZz5OJtmxcg4lDUUrY=;
	h=Date:To:From:Subject:From;
	b=jEq8dX4bEYfNB61EMBENVvSEcqR+GMHQlDT5VY3eI7t3j+liXYDruIKt24WzMVcFx
	 HdIWz9lhqFc8+oZmqA+UGWzTIenpZsixmHE9OSy1ndbvsUispQ9xkVlSJcU8rka79n
	 5J7NKH8qJFtT8p1CGh/8QRnsAT0rW4FxPNvu2KpM=
Date: Tue, 05 Nov 2024 17:14:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch removed from -mm tree
Message-Id: <20241106011410.B00CDC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs: update min_heap_callbacks to use default builtin swap
has been removed from the -mm tree.  Its filename was
     bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcachefs: update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:59 +0800

Replace the swp function pointer in the min_heap_callbacks of bcachefs
with NULL, allowing direct usage of the default builtin swap
implementation.  This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Link: https://lkml.kernel.org/r/20241020040200.939973-10-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/clock.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/fs/bcachefs/clock.c~bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/fs/bcachefs/clock.c
@@ -14,17 +14,9 @@ static inline bool io_timer_cmp(const vo
 	return (*_l)->expire < (*_r)->expire;
 }
 
-static inline void io_timer_swp(void *l, void *r, void __always_unused *args)
-{
-	struct io_timer **_l = (struct io_timer **)l;
-	struct io_timer **_r = (struct io_timer **)r;
-
-	swap(*_l, *_r);
-}
-
 static const struct min_heap_callbacks callbacks = {
 	.less = io_timer_cmp,
-	.swp = io_timer_swp,
+	.swp = NULL,
 };
 
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
_

Patches currently in -mm which might be from visitorckw@gmail.com are



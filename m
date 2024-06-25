Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874BB33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719292771; cv=none; b=CHH3+PUgbagH2mu06beisekL1Firenl+wxQNexpHZSzZWwFMgaPbx0UeyJ/IfjaVXkDdQXhydETtwXa/XthW4wZwzuf1pkt9/FeOl9AsjLDLPC7ERyHCSth+8Q4MlRW4qi5WIjGCrHWCKlu7FHohXcENPPIzqnJe4JjrPiXEanw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719292771; c=relaxed/simple;
	bh=Yx9YBXfJw5d0IZCK6W745oeBkr6TEYov9oFt/Pv1QAw=;
	h=Date:To:From:Subject:Message-Id; b=YL3+o/qHp6bUY6Bx6owfrm9fzGr+2SqXN0Vuf2LbDoinF4dmxGhqjVs/nLYlbo4ch3nRa7VwkjLpTco2mUwI+7bUespLnerzEMJH6mPxgQQxeHyW1pqhqOsj6/7L60Cm81gOrp3Zsp2r4HfA/iT919Fsd3K+LnzEtBbI9XJ7ulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfxHMENJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfxHMENJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06178C32782;
	Tue, 25 Jun 2024 05:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719292771;
	bh=Yx9YBXfJw5d0IZCK6W745oeBkr6TEYov9oFt/Pv1QAw=;
	h=Date:To:From:Subject:From;
	b=nfxHMENJ9Z2m1u3fBFDQu9YRTBVeSaDhpt618XSPF+R0Ue9+YFdPng+3c5NHHwe6Z
	 CxYcjADl3yJw8YS65msGAI+SbOwihx4mb7IclTM8e5sVHDq+vtwRfc2BOI/kk7+omM
	 rr//eZZcndXFy6Z1sy9MasLRTzarB4q+fyFWBw1w=
Date: Mon, 24 Jun 2024 22:19:30 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,kent.overstreet@linux.dev,irogers@google.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix.patch removed from -mm tree
Message-Id: <20240625051931.06178C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs: fix missing assignment of minimum element before min_heap_pop()
has been removed from the -mm tree.  Its filename was
     bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix.patch

This patch was dropped because it was folded into bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcachefs: fix missing assignment of minimum element before min_heap_pop()
Date: Mon, 3 Jun 2024 01:48:28 +0800

When replacing the heap_pop() macro with min_heap_pop(), the original
heap_pop() macro would store the minimum element into 'ret'.  However,
after replacing it with min_heap_pop(), the code incorrectly failed to
store the minimum element into 'ret' before deleting it.

Fix the issue by using min_heap_peek() to assign the minimum element to
'ret' before calling min_heap_pop() to remove the minimum element.

Link: https://lkml.kernel.org/r/20240602174828.1955320-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406030001.jwsq6DZp-lkp@intel.com/
Cc: Ian Rogers <irogers@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/clock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/bcachefs/clock.c~bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix
+++ a/fs/bcachefs/clock.c
@@ -156,8 +156,10 @@ static struct io_timer *get_expired_time
 	spin_lock(&clock->timer_lock);
 
 	if (clock->timers.nr &&
-	    time_after_eq(now, clock->timers.data[0]->expire))
+	    time_after_eq(now, clock->timers.data[0]->expire)) {
+		ret = *min_heap_peek(&clock->timers);
 		min_heap_pop(&clock->timers, &callbacks, NULL);
+	}
 
 	spin_unlock(&clock->timer_lock);
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

perf-core-fix-several-typos.patch
bcache-fix-typo.patch
bcachefs-fix-typo.patch
lib-min_heap-add-type-safe-interface.patch
lib-min_heap-add-min_heap_init.patch
lib-min_heap-add-min_heap_peek.patch
lib-min_heap-add-min_heap_full.patch
lib-min_heap-add-args-for-min_heap_callbacks.patch
lib-min_heap-add-min_heap_sift_up.patch
lib-min_heap-add-min_heap_del.patch
lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch
lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch
lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch
lib-test_min_heap-add-test-for-heap_del.patch
bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
lib-sort-remove-unused-pr_fmt-macro.patch
lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch
lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch
lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch
tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch


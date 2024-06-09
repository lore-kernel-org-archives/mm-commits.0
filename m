Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2402EAF9
	for <mm-commits@vger.kernel.org>; Sun,  9 Jun 2024 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717971881; cv=none; b=dkGSWrgNmqf+I+bJH2ilJ5V+C1Bh5qyoJJ9LtNDsHNZwlz5/d2ZAuQXMu9x1lTogJisq4VKgwvT8eCep8LL1cOhUXc5lQlQJm7aLZK+Lxw1MtmxyqlPM8GBSW6cQoGmZ8qWV3qm/qZIPkZBs/0d7NwpXExFizwHiy/tZVV/DU4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717971881; c=relaxed/simple;
	bh=JYhgokfERrsOymeOA4b1G2VQE1Q4LMB5dXwt9S3V1Ss=;
	h=Date:To:From:Subject:Message-Id; b=A7cIEEEuSVE+ZoifP8pumxqNcfWzdSvv9wi+FiAiCLxlPjvwTLUt4cOWstCC3iIuys3OzNgIVH7frT0x6mmXygd4YslmNTuBt1cVofjKTHDk+UQjg8wLkpd2LbH9i4E23QTlrMH0kRqSk5aOEs7wD1+MhivbfZ3rf6OEV/rzAQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2Klqa3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2Klqa3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4886BC2BD10;
	Sun,  9 Jun 2024 22:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717971880;
	bh=JYhgokfERrsOymeOA4b1G2VQE1Q4LMB5dXwt9S3V1Ss=;
	h=Date:To:From:Subject:From;
	b=Z2Klqa3QLJsp367aYSL4EWvVkYWc4U6PIZlrwkvCr6wQQVhZSTSjqIvxcBnsgtkvR
	 kZkQnyv3CRDgi2L6gNx+F2FHzsBxrRhZT2fC5KiMvJJSRzDE7NCv+W46pXbop6DWWU
	 YeUmivN5WXgoPt/nv8g32nxSqTppZPzPnEcOVJGQ=
Date: Sun, 09 Jun 2024 15:24:39 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,kent.overstreet@linux.dev,irogers@google.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240609222440.4886BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs: fix missing assignment of minimum element before min_heap_pop()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix.patch

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
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap-fix.patch
lib-sort-remove-unused-pr_fmt-macro.patch
lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch
lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch
lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch
tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch


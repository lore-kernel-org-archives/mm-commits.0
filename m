Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F772C1A2
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579020; cv=none; b=nqxyXR4D5hFFnZmzEGdN9rO+GxTKAqAxCvqd0poPpBTTodvmI5TBEorvfHq7RmOT7MFeVtZWOceHTdlIsyI+IEMwiujYgomRmu0eGFr3vEpS5wj/GS3rZxZswWpxgxxpa2mCIXtpnBqle1PHmUMcS/oxKerN7Z6XYKPnfcsMpjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579020; c=relaxed/simple;
	bh=PxI+GzRv7QgilrRhWu4zIhr+cVSKQE/ediojIXL5pSQ=;
	h=Date:To:From:Subject:Message-Id; b=jeJZxdUr7GwIfbcH6V0+Juu+bYKr3Ejb9y16W0IwrZ3lyXF3K768mX2zy5mRyZ8wECvQNzJ7OUBb9sHqYvgqXVeIp9Nfqe5QaORzORUed6iXl/5RzIjhrcTIP86iBIhi5C0wz02TAeGACMBeWUcuy3+BOi0Krk6xZw10QcBeXwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0wNRcC63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0wNRcC63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDEFC2BBFC;
	Fri, 24 May 2024 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716579020;
	bh=PxI+GzRv7QgilrRhWu4zIhr+cVSKQE/ediojIXL5pSQ=;
	h=Date:To:From:Subject:From;
	b=0wNRcC63okVp+ymHOknzUiQjO8JKrLVgVbdVVIyZR7+yqUxM5JoaTwGKFh8XJTrO6
	 9fXWAcLurZWHO9XeGTxvXxS32Ti5GSOugekIwY37zkKGdWvP3ghhr/NydOOq9TWpqK
	 WNh5OJe53kMmUvnviZT7bZTke84NRRxjU2HgF8gg=
Date: Fri, 24 May 2024 12:30:19 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-core-fix-several-typos.patch added to mm-nonmm-unstable branch
Message-Id: <20240524193019.DEDEFC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: perf/core: fix several typos
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     perf-core-fix-several-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-core-fix-several-typos.patch

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
Subject: perf/core: fix several typos
Date: Fri, 24 May 2024 23:29:43 +0800

Patch series "treewide: Refactor heap related implementation", v6.

This patch series focuses on several adjustments related to heap
implementation.  Firstly, a type-safe interface has been added to the
min_heap, along with the introduction of several new functions to enhance
its functionality.  Additionally, the heap implementation for bcache and
bcachefs has been replaced with the generic min_heap implementation from
include/linux.  Furthermore, several typos have been corrected.

Previous discussion with Kent Overstreet:
https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu


This patch (of 16):

Replace 'artifically' with 'artificially'.
Replace 'irrespecive' with 'irrespective'.
Replace 'futher' with 'further'.
Replace 'sufficent' with 'sufficient'.

Link: https://lkml.kernel.org/r/20240524152958.919343-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240524152958.919343-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/events/core.c~perf-core-fix-several-typos
+++ a/kernel/events/core.c
@@ -534,7 +534,7 @@ void perf_sample_event_took(u64 sample_l
 	__this_cpu_write(running_sample_length, running_len);
 
 	/*
-	 * Note: this will be biased artifically low until we have
+	 * Note: this will be biased artificially low until we have
 	 * seen NR_ACCUMULATED_SAMPLES. Doing it this way keeps us
 	 * from having to maintain a count.
 	 */
@@ -596,10 +596,10 @@ static inline u64 perf_event_clock(struc
  *
  * Event groups make things a little more complicated, but not terribly so. The
  * rules for a group are that if the group leader is OFF the entire group is
- * OFF, irrespecive of what the group member states are. This results in
+ * OFF, irrespective of what the group member states are. This results in
  * __perf_effective_state().
  *
- * A futher ramification is that when a group leader flips between OFF and
+ * A further ramification is that when a group leader flips between OFF and
  * !OFF, we need to update all group member times.
  *
  *
@@ -891,7 +891,7 @@ static int perf_cgroup_ensure_storage(st
 	int cpu, heap_size, ret = 0;
 
 	/*
-	 * Allow storage to have sufficent space for an iterator for each
+	 * Allow storage to have sufficient space for an iterator for each
 	 * possibly nested cgroup plus an iterator for events with no cgroup.
 	 */
 	for (heap_size = 1; css; css = css->parent)
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


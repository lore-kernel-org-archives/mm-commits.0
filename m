Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F34446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739434; cv=none; b=Pa10+bvk++GbspGi0OzxH2XRQarTJHCVhP8cDURxSrO6jISGIpweJ3UDUC2f0y5g6AIcPdeuUw7OyPakcAj+N0UWJRtoWfA21RPemMXisbHdM1lalmByvqimQYNonBwYFAwaL2nqLijZiKahaAmLsZF3UZ8nqzryN2uTcziBfYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739434; c=relaxed/simple;
	bh=hIdcpD5VcIDcWEzEOG4Gp8wrj/pQVBwr95yuQtnCv0U=;
	h=Date:To:From:Subject:Message-Id; b=skYnZpOAlPwCKRAsgBVZJR9BM52I0CuWskEVhiN2sP3+8tV8pkNIBCoiCHVdvQ0T/zjj2WpC9+6B+4k44XFy3YbWqbtV+ZfYTRMlJ2vwrw7pe+YK0/+dadDZZ36S60mLcLCpkOGKN5xcQJkfITvaTiMXhaBjpljKpgCQDfZISZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kr+gdu9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kr+gdu9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97B4C4CEC6;
	Thu, 24 Oct 2024 03:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739433;
	bh=hIdcpD5VcIDcWEzEOG4Gp8wrj/pQVBwr95yuQtnCv0U=;
	h=Date:To:From:Subject:From;
	b=Kr+gdu9GG+CKCJiEQqD3xWaL4X9nghmVrIlQC2ZsB67Q/UWvzcrZMkfPASc2qfYQ7
	 ohAX/jna9fBmz+NGX8BZIAkKs2ql9jctB7m6VkpoUkfx1Aw/8+flsSqRIhRbRZ0y6c
	 ccwqjbbXpen1UXbxSDLEvJaucdAVb+7K68W6iDAA=
Date: Wed, 23 Oct 2024 20:10:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031033.C97B4C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: perf/core: update min_heap_callbacks to use default builtin swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch

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
Subject: perf/core: update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:55 +0800

After introducing the default builtin swap implementation, update the
min_heap_callbacks to replace the swp function pointer with NULL.  This
change allows the min heap to directly utilize the builtin swap,
simplifying the code.

Link: https://lkml.kernel.org/r/20241020040200.939973-6-visitorckw@gmail.com
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

 kernel/events/core.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/kernel/events/core.c~perf-core-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/kernel/events/core.c
@@ -3778,18 +3778,11 @@ static bool perf_less_group_idx(const vo
 	return le->group_index < re->group_index;
 }
 
-static void swap_ptr(void *l, void *r, void __always_unused *args)
-{
-	void **lp = l, **rp = r;
-
-	swap(*lp, *rp);
-}
-
 DEFINE_MIN_HEAP(struct perf_event *, perf_event_min_heap);
 
 static const struct min_heap_callbacks perf_min_heap = {
 	.less = perf_less_group_idx,
-	.swp = swap_ptr,
+	.swp = NULL,
 };
 
 static void __heap_add(struct perf_event_min_heap *heap, struct perf_event *event)
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


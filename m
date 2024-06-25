Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE27142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293158; cv=none; b=tl4LiOn5Al+8dFCkzwtuGK9pOY/byflYTsydgys5giynTdLVO6AnkkUkR/jus4oEhEOtrFUC3IXLt3N8dNzUW+giJ5DwXOYRI07g3LTmC74eB8aJrv6IROjwkYeq1NM1R15KLiYXpVamjxhJHJNpUnFN4hNLq4saIMzUSMPlugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293158; c=relaxed/simple;
	bh=BG+Zxo/7oBAnNSsIj+u8xe7BuTGKjrkRE6kOlNl1L9Y=;
	h=Date:To:From:Subject:Message-Id; b=cTFyy5NQwBEFZXyCYY6bw4Rl+GqGTvRp93UXXhc4TtJKORoZ2wjPXd/2HQdfxC6xH+9ad/DcUHNqSdTNd1genzE3V4lb+obtZcYEjC+QF52h9RRLwFKOEFX6Owbw41ltZ9R4vq4Dvk8NltdqRhw56lAvk6CbNqC57BFLJveN2fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xhmDMrUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xhmDMrUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD772C32789;
	Tue, 25 Jun 2024 05:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293157;
	bh=BG+Zxo/7oBAnNSsIj+u8xe7BuTGKjrkRE6kOlNl1L9Y=;
	h=Date:To:From:Subject:From;
	b=xhmDMrUMsn3I+zIOyNpGUtyTz/shUMKsfUXg8CMmWrqGnArlCZDW7HPeFdJhdrVKM
	 vVw5BA/uU/bMyKFb5OrTrqgfDT9snKzNnrMJW1zKeWPrmYmhj3Q0l2+TRH5t1Y5Yq3
	 iEZZqO+it+prRGsAI4Bk0dggGJ9K43YFfIG5Qs54=
Date: Mon, 24 Jun 2024 22:25:57 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] perf-core-fix-several-typos.patch removed from -mm tree
Message-Id: <20240625052557.AD772C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: perf/core: fix several typos
has been removed from the -mm tree.  Its filename was
     perf-core-fix-several-typos.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



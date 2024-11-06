Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5D18892F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855646; cv=none; b=NMo//NcaAlzcD8Ol3+IPgxuEXicxxTBVJW3wZTSd1UUW59S6ZHrP/YPDZYGBsa3eG20//8gwrEFKbi/in8OrUFN8EBqtN56+iVWjo75w21HHt36jYnO2omh61VIwdxPQp3E934nBcgjWk37zAc13P6z/5t4aRL2YrpZmC0Ak8fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855646; c=relaxed/simple;
	bh=mA9JxhdGG11o7oLWjXodxvljWUVf2g6qzC83+6SAaew=;
	h=Date:To:From:Subject:Message-Id; b=pEOOLRPyB08ayCtL7hRnCrSpS5WqdcWOy6MYqkYRxmhTAdDQcAKeqE+QlQt7bZ97o2uwuxnV5x3SY4mpodGIa/VwCTwhD9UGE2oHQOmqL4BKHFJnaOr1MA6faxih/HoUdVoM3G8qpCaRLOCrtg/MdOkJgx7Dv1TeYGl/lCvrRbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2h7UUke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2h7UUke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830EDC4CECF;
	Wed,  6 Nov 2024 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855645;
	bh=mA9JxhdGG11o7oLWjXodxvljWUVf2g6qzC83+6SAaew=;
	h=Date:To:From:Subject:From;
	b=E2h7UUkeN/m2awLY0y1c1U3SeUJY6HMBpSP2n3zw/RuFSwJ7dueFOu9W7ny/Z41/J
	 yWfdSK2B6WRwVJa/7bgUdIFmE/4qM4M6ygtGu6tw/C9vJoTZxyLoyCboZPR2dVYGq5
	 FGTs6SZq25Psw2fRgm5FVkc/vVf+fEZClscrXbi0=
Date: Tue, 05 Nov 2024 17:14:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch removed from -mm tree
Message-Id: <20241106011405.830EDC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: perf/core: update min_heap_callbacks to use default builtin swap
has been removed from the -mm tree.  Its filename was
     perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



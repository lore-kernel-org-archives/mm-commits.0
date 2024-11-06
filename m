Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544618892F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855647; cv=none; b=fi/0jpGe0X08Md6xhzTBIa7fD12HdUQBeTswMRfxk5xEqF/Tx5S5h8P1i0DkSZ4NxsZ6ybYaBgQW2h08k182PhSnqD59aA89N0KI7QeZJuHVyryYqGRBK1kWsJo1/u0tWqKdManpfHatdOFJsQFuM0EgZBzFxNPYz0/L1pUAk5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855647; c=relaxed/simple;
	bh=1DNd1hYuxtNRPoXam1vsUj0Pc+o4a9qxDV1UTkyk20o=;
	h=Date:To:From:Subject:Message-Id; b=SuJzzAyuIhk/I5SdAYtkci7BSEJTlgzULx9gHFdkzpsF60K5aIWeI4oCSmy8JNSHnTZM/xq8YrrweBD5d6gl/smKn6BbWIz75Ptxth28NdDefmh19Jk2L683qvdtDUb8o46GsAn/vQG2wrM81s70SrUHX1ISzpFRbTr2JnXyHy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7c6Yju6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7c6Yju6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEEEC4CECF;
	Wed,  6 Nov 2024 01:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855646;
	bh=1DNd1hYuxtNRPoXam1vsUj0Pc+o4a9qxDV1UTkyk20o=;
	h=Date:To:From:Subject:From;
	b=i7c6Yju6E1lCQQ9C6IPr9zTI3f4HtYgZcyYfmSB7Egy92gSrp3owMRc3FsT4unZK4
	 uA6X0/bDUb9pOqVwN1GRs4434xkqA48d+lPqjBctJkDjUnSY4f+upZVi22AY4iYiEt
	 UnCpAx8PIW/HKV2yynHiYV2kcu+zC69deANL+Lyc=
Date: Tue, 05 Nov 2024 17:14:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch removed from -mm tree
Message-Id: <20241106011406.CDEEEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dm vdo: update min_heap_callbacks to use default builtin swap
has been removed from the -mm tree.  Its filename was
     dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: dm vdo: update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:56 +0800

Replace the swp function pointer in the min_heap_callbacks of dm-vdo with
NULL, allowing direct usage of the default builtin swap implementation. 
This modification simplifies the code and improves performance by removing
unnecessary function indirection.

Link: https://lkml.kernel.org/r/20241020040200.939973-7-visitorckw@gmail.com
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

 drivers/md/dm-vdo/repair.c     |    2 +-
 drivers/md/dm-vdo/slab-depot.c |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-vdo/repair.c~dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/dm-vdo/repair.c
@@ -166,7 +166,7 @@ static void swap_mappings(void *item1, v
 
 static const struct min_heap_callbacks repair_min_heap = {
 	.less = mapping_is_less_than,
-	.swp = swap_mappings,
+	.swp = NULL,
 };
 
 static struct numbered_block_mapping *sort_next_heap_element(struct repair_completion *repair)
--- a/drivers/md/dm-vdo/slab-depot.c~dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/dm-vdo/slab-depot.c
@@ -3301,17 +3301,9 @@ static bool slab_status_is_less_than(con
 	return info1->slab_number < info2->slab_number;
 }
 
-static void swap_slab_statuses(void *item1, void *item2, void __always_unused *args)
-{
-	struct slab_status *info1 = item1;
-	struct slab_status *info2 = item2;
-
-	swap(*info1, *info2);
-}
-
 static const struct min_heap_callbacks slab_status_min_heap = {
 	.less = slab_status_is_less_than,
-	.swp = swap_slab_statuses,
+	.swp = NULL,
 };
 
 /* Inform the slab actor that a action has finished on some slab; used by apply_to_slabs(). */
_

Patches currently in -mm which might be from visitorckw@gmail.com are



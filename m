Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE99446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739436; cv=none; b=fGoC56d6rA6MVcU3D170eYdvklJXUzfMsjz+O/QVE8/9ABsnNtsQUQ/SGiDDAfxEF5eZ9UIIkITDEw3YkD/BUIZ1uuw1qN+FJOOfUYT+l/OrDyS6mxQ1iiSjjvCntM6rcdUeoGy8j681xmp0alLS7Yg2hELV9Xv4HVcAE+470ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739436; c=relaxed/simple;
	bh=aGFWqxDW7NlDVgr6C6q9sVi09dQdqwbbtNpAzf94ylY=;
	h=Date:To:From:Subject:Message-Id; b=o6GWBnToi1lRq1FTPkHB+fZhxO2nKedpRKjkexe9LOF+k0+zrNeL+adDuWb2i6VizdcA5oa5mc2EFBOPlvxNkZYARFTHUn/+8ayYmkbvrkxd8ypGyp2184qDQKLybyzCk3SP4f8MW9F2U0hIKdIUoO6WizgREWlhx7ZmjYa/qns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fIjldrOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fIjldrOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A05C4CEC6;
	Thu, 24 Oct 2024 03:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739435;
	bh=aGFWqxDW7NlDVgr6C6q9sVi09dQdqwbbtNpAzf94ylY=;
	h=Date:To:From:Subject:From;
	b=fIjldrOIZaWsJPD97yM+9P2MwcPM1sP5jjDc/yjp+ehTBBLl5Wq6aY9qi+ULE8Y4r
	 /EgLMU8vzTvuEe2EOiBQ3jMQx5DtihiJUGBXnNkT3iZBpPbExiJxQ7CLKVyYCXJlG/
	 IEgIFSVY/GvnARUBBIZtKhWiu2EqXJTCfh3F3qBM=
Date: Wed, 23 Oct 2024 20:10:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031035.D5A05C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dm vdo: update min_heap_callbacks to use default builtin swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch

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


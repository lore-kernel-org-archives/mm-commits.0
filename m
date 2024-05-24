Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511FB5B5D3
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579050; cv=none; b=iQ4GpAfadimhzqqbdI7P+E3sqZvBvVNT0roHAd61FgqibWkKkkT0MFUTAtz0dAOfDYD2pMM/2NlXxvDLgm40mv4kWWMYF/XM59vCw2NBeUCWacEKk9QYbRzGCh7BCj6Drf5ZPpRvn3ruoBUZNpglqjuwKnuNJIE7pDTRWxgnurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579050; c=relaxed/simple;
	bh=23D523xirkRHYy1TyyFxxJDvPCxu4Brh2e6o5ZZXWvU=;
	h=Date:To:From:Subject:Message-Id; b=VKhTfq4SwI+b8NbRZ3W7CuXeoTWvTZKTQgqtfObGeIq9ImpJo1n7dKxRr5MA86OIn2V73NiKSSzk6F6bnPOTFv0q1/iQY3JaxKCj0r7VNH0wbhsm4F05icgL/C+39jZhi1O/g3flErwe/KBzuy+BzaJkCoVU4S10JfZHHAh9eJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gfMqZVTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gfMqZVTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C868FC2BBFC;
	Fri, 24 May 2024 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716579049;
	bh=23D523xirkRHYy1TyyFxxJDvPCxu4Brh2e6o5ZZXWvU=;
	h=Date:To:From:Subject:From;
	b=gfMqZVTDK3b2aDofTnearvC2B/MweBXeeAPQGpYdBGT5yNn8MpGP6D5lPXxjLbbgN
	 wGyAY7hf1sVF8SteQANVOXv//4bmhgxTno3OKW1JykgB73vf53rfFNBJa9OWZM7nTC
	 0f94HwjK+svFCra9lVQ1dNhwpRjw4vcy4ty2oRUw=
Date: Fri, 24 May 2024 12:30:49 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_min_heap-add-test-for-heap_del.patch added to mm-nonmm-unstable branch
Message-Id: <20240524193049.C868FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_min_heap: add test for heap_del()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_min_heap-add-test-for-heap_del.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_min_heap-add-test-for-heap_del.patch

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
Subject: lib/test_min_heap: add test for heap_del()
Date: Fri, 24 May 2024 23:29:56 +0800

Add test cases for the min_heap_del() to ensure its functionality is
thoroughly tested.

Link: https://lkml.kernel.org/r/20240524152958.919343-15-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
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
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_min_heap.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/lib/test_min_heap.c~lib-test_min_heap-add-test-for-heap_del
+++ a/lib/test_min_heap.c
@@ -165,6 +165,40 @@ static __init int test_heap_pop_push(boo
 	return err;
 }
 
+static __init int test_heap_del(bool min_heap)
+{
+	int values[] = { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
+			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
+	struct min_heap_test heap;
+
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
+	heap.nr = ARRAY_SIZE(values);
+	struct min_heap_callbacks funcs = {
+		.less = min_heap ? less_than : greater_than,
+		.swp = swap_ints,
+	};
+	int i, err;
+
+	/* Test with known set of values. */
+	min_heapify_all(&heap, &funcs, NULL);
+	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
+		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+	err = pop_verify_heap(min_heap, &heap, &funcs);
+
+
+	/* Test with randomly generated values. */
+	heap.nr = ARRAY_SIZE(values);
+	for (i = 0; i < heap.nr; i++)
+		values[i] = get_random_u32();
+	min_heapify_all(&heap, &funcs, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
+		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+	err += pop_verify_heap(min_heap, &heap, &funcs);
+
+	return err;
+}
+
 static int __init test_min_heap_init(void)
 {
 	int err = 0;
@@ -175,6 +209,8 @@ static int __init test_min_heap_init(voi
 	err += test_heap_push(false);
 	err += test_heap_pop_push(true);
 	err += test_heap_pop_push(false);
+	err += test_heap_del(true);
+	err += test_heap_del(false);
 	if (err) {
 		pr_err("test failed with %d errors\n", err);
 		return -EINVAL;
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


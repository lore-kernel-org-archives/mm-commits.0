Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171B144D1C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293173; cv=none; b=Nwonf7+ZSdmg0AfHjxVzBcwTqVRiFZ5TZl2mWr9yn4jXHHxzh0pnjwktSAo2udll0Ata+iOmJXs0af5lD5QCgM9sBsJwsUZbvC3+f4XpYUHATe3xnQydonOAvUpdjDWT+lFz9HvPUb3UoDw4LsJmc/D8oIXrejN8skETeU/FTBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293173; c=relaxed/simple;
	bh=ohvP6QaiMPTflsBvMeMGCVPlR0a+WHa+Z3jpESf61Ms=;
	h=Date:To:From:Subject:Message-Id; b=eGxPdvv2md7cEoMLxR82oJnuvje/TwToC+j+EwdLwHCeHxojPZ0yCpay5lXyW6akroD6CDvli+q4BCUtmzp+3Y2oSfE1IXhNqMeA922t9TRsWh9XPBcpzDrYryKU/c11QQyJGXN0k/KhhGbwj86ZrsSzSvOWtN9JlwBk1YS0ZSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=InwcHaVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="InwcHaVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1652CC32782;
	Tue, 25 Jun 2024 05:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293173;
	bh=ohvP6QaiMPTflsBvMeMGCVPlR0a+WHa+Z3jpESf61Ms=;
	h=Date:To:From:Subject:From;
	b=InwcHaVtEa31Gu+ZIwimwbCZL9Y46ZfjzByzKZPQQEf88EfqqtNY9CjCag2TavXlM
	 5p6YKO9yyaJOXQfmVeG8zL5fSuxH9GnOh6yX6hi2XRRArjlcHXbwTDauVKmnRi5Kwm
	 2MLEuf82xtAvMiPsZ/nLZXzjRMrDAZJGjERZvL9M=
Date: Mon, 24 Jun 2024 22:26:12 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_min_heap-add-test-for-heap_del.patch removed from -mm tree
Message-Id: <20240625052613.1652CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_min_heap: add test for heap_del()
has been removed from the -mm tree.  Its filename was
     lib-test_min_heap-add-test-for-heap_del.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



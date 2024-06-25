Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B96D144D1C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293172; cv=none; b=uDe3+1JFN25fIA9Vuw/4Gq5TgtiPXaqfOCYIGbVXSmfmwGvYonsAHa2yA6bIZm3sqbNGGIUiFhlIbMi3RaGSY3zAOegC7CVqOqKlppnEpP+QAmS2u122BkLZa3C6KV9galV7R8RhsW0dlJpQqu+k57GMkj0nhVPYiSEQU/v/9us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293172; c=relaxed/simple;
	bh=32P5MQgomE6hZodpugru8tjigei0280eqBxj+Xf5zrM=;
	h=Date:To:From:Subject:Message-Id; b=ZDtQ3dzcLkEvqiPc6gPznGyN8b5Tq2cKFzsVtHm7v8Gef30etEyUzvxYd6h56j4fIGTzFKoH+EK1CtkoIvh1Wfhny2m+EpOMYXTtqOPh8WSWEHEj7aCCzZClYBHd+Y+Njnx2GFEzWQLfDNUhyR4OX0SWXPV5aAdJif2TK7UyDOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RbLkKWls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RbLkKWls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA596C32782;
	Tue, 25 Jun 2024 05:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293172;
	bh=32P5MQgomE6hZodpugru8tjigei0280eqBxj+Xf5zrM=;
	h=Date:To:From:Subject:From;
	b=RbLkKWlsPInUPoWjCxNKYHq1H+GvIhpX3hVCR164zoMr0AVKoRxsOsF0h9/AxZp7h
	 YOyfrsR7q8FBXEJA2zzTNklNHAdj7T7h/H/lkZX8toS7/tbIZWWn6YqjyT2iwFwC9c
	 qFFjqPAIDMxQhNF4Qnam6VdZ0tXYvbj1MOZKcSKg=
Date: Mon, 24 Jun 2024 22:26:11 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch removed from -mm tree
Message-Id: <20240625052611.EA596C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: update min_heap_push() to use min_heap_sift_up()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: update min_heap_push() to use min_heap_sift_up()
Date: Fri, 24 May 2024 23:29:55 +0800

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Link: https://lkml.kernel.org/r/20240524152958.919343-14-visitorckw@gmail.com
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

 include/linux/min_heap.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up
+++ a/include/linux/min_heap.h
@@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	void *child, *parent;
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
@@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	for (; pos > 0; pos = (pos - 1) / 2) {
-		child = data + (pos * elem_size);
-		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child, args))
-			break;
-		func->swp(parent, child, args);
-	}
+	__min_heap_sift_up(heap, elem_size, pos, func, args);
 
 	return true;
 }
_

Patches currently in -mm which might be from visitorckw@gmail.com are



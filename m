Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512C62C1A2
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579022; cv=none; b=k+MYxhtyDZF5uSHhHxBbrORC+/dVvrXNGuDuyS/7T2oeC7OZGoS4+lAosPMP5ywGzhuhYY28LanrdJIGHml63vVoxO59gHD4SYsWt/aGfyZrAebmOpaEY2qcg75YSN/RuAv6GBNXg1HXq+eudpppW4c6wf9cooxv6h7KE2QqrjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579022; c=relaxed/simple;
	bh=Por+5cN4EdMyxwFlEkhyYmOekdfaqCLOaatxHVw0nfs=;
	h=Date:To:From:Subject:Message-Id; b=n3flsczI1rPrvoVKBHYmOMgkMsH6tuY1uLiqBKKUavjAYMGlusxu999HFrHIv+KK7AejD5u7tKLQ0Cu3jWV40fuuHPIlIGnk7YPfZ/qrMQsnnNeT6jdugVbLXuN5HnSKjP8h+M0JY0oc0eKtiR+R9JvzPKX4PgPzcxz45dDYDMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIMvfOfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIMvfOfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF09C2BBFC;
	Fri, 24 May 2024 19:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716579021;
	bh=Por+5cN4EdMyxwFlEkhyYmOekdfaqCLOaatxHVw0nfs=;
	h=Date:To:From:Subject:From;
	b=jIMvfOfcW1vFetJ9DCc44uewVHITdgBQ49FNpqapneCA+cHs+6lEZr3aVS6H6CXuo
	 8TOOGx1xvmbjRnSbWaawzYA3VifGeA5cwvgbdbvGlOC96LfuBurs+2Elt9NtgE+Ljh
	 rAwinYQn8eCU4dgGLZ9dTt0al4nlUccfcXFzJE74=
Date: Fri, 24 May 2024 12:30:21 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcache-fix-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20240524193021.CFF09C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcache: fix typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcache-fix-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcache-fix-typo.patch

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
Subject: bcache: fix typo
Date: Fri, 24 May 2024 23:29:44 +0800

Replace 'utiility' with 'utility'.

Link: https://lkml.kernel.org/r/20240524152958.919343-3-visitorckw@gmail.com
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

 drivers/md/bcache/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/util.c~bcache-fix-typo
+++ a/drivers/md/bcache/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
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


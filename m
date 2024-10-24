Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379FA446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739444; cv=none; b=pDjdws7LDd7ac2u3KB823017xcGAc8Nrpow5qLFGNIbACD9VCiA/N1hohX2IKzNpIa3m1CK8AgWQzejXPL7Q1vAKp/WTT8G9K75RXdvfkWfeF5omT5XUQfKuNVjRboGHdK44DEQUn1XZFLlsT0zznLRxD8DMn25RRLkTdD8/hPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739444; c=relaxed/simple;
	bh=G38F5jj0jhrw3YKl1IVXNTbbAU+CC7Qg7qahzHbrLak=;
	h=Date:To:From:Subject:Message-Id; b=tlsiA5DkKth1dWFeartH5Pwo/EFSNh2sTJzgyqZrf6JY/JKkxnq/0t+NfFNLzfkfuZyDr5aU5WIJNwZOKEeJYzEDyG+5FpPJoVbkaBEiajmZNCMGWJcWeByV1KIhFe2cLAxrvazkEntThf4zW8wavVfYsiCZgBrhiYqH67/q1v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sfk31Fgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sfk31Fgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA38CC4CEC6;
	Thu, 24 Oct 2024 03:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739443;
	bh=G38F5jj0jhrw3YKl1IVXNTbbAU+CC7Qg7qahzHbrLak=;
	h=Date:To:From:Subject:From;
	b=Sfk31FglGM9CUFEum4qGLIwM77kASySQZ6yGjwia7BF2qoeVcJ+60hEo1z4Z50kOx
	 hkYeurP41v4JXIJBuf5WVI5U1i8k1vMtwzLiFFOKw6AIBrGbDsqQkcMSTUT165ZlVX
	 xtx6NTCxCSq8Y2oqjAKp00h65p6TPxxg9lObw/I8=
Date: Wed, 23 Oct 2024 20:10:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031043.BA38CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs: update min_heap_callbacks to use default builtin swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch

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
Subject: bcachefs: update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:59 +0800

Replace the swp function pointer in the min_heap_callbacks of bcachefs
with NULL, allowing direct usage of the default builtin swap
implementation.  This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Link: https://lkml.kernel.org/r/20241020040200.939973-10-visitorckw@gmail.com
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

 fs/bcachefs/clock.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/fs/bcachefs/clock.c~bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/fs/bcachefs/clock.c
@@ -14,17 +14,9 @@ static inline bool io_timer_cmp(const vo
 	return (*_l)->expire < (*_r)->expire;
 }
 
-static inline void io_timer_swp(void *l, void *r, void __always_unused *args)
-{
-	struct io_timer **_l = (struct io_timer **)l;
-	struct io_timer **_r = (struct io_timer **)r;
-
-	swap(*_l, *_r);
-}
-
 static const struct min_heap_callbacks callbacks = {
 	.less = io_timer_cmp,
-	.swp = io_timer_swp,
+	.swp = NULL,
 };
 
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
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


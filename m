Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D690B3D1CD4
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029027; cv=none; b=OpAS0wT/DucdesF1/yZ7i0Mi7Jk1xszYLWyr/+a6tjiwZ7UQU1mzTzcO/4jb8HBD85DDFlIsxJA6STl/6AcLT2RLHLcUJf3D/lv0mla0gTfHFcIQ4PV5F0XxfIiaLnysejToak1Sx+kSB3iuf0VcGz9nVYg/ZsygOF6WilAj514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029027; c=relaxed/simple;
	bh=Yo/ULNgyG4/4Y5nhdNiIzlj7yThHIURYD0GE+zfMPpE=;
	h=Date:To:From:Subject:Message-Id; b=A34izks1JptFQNzyHn14JMxyz/qiq3wyWiCVXqAXyYZZbmYuFG5Tfk8NuWpPWmtftv7uQsoMm4dyY2WeYjf1Novwk1nJuEOTC/1KVqF/bmh1U21cPLVi5xGJxcRJ+gYsDnFjDQROuhf7/6ozsdRwmxspEafTGIGhcSCBYSs6QUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vrlSLYua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vrlSLYua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF21C4CEF7;
	Fri, 20 Mar 2026 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774029026;
	bh=Yo/ULNgyG4/4Y5nhdNiIzlj7yThHIURYD0GE+zfMPpE=;
	h=Date:To:From:Subject:From;
	b=vrlSLYuaWif6D81+LU5T7wkPm9S7kOvloDzxMZBnpO4ZVddP0a4kX2brItuo09CQP
	 Ni3CxgaG/kmOgPe0AcQV1TsDdBCrHnwZbvAgppmZuu0dsQy3EsLObmjso0pctxhlZu
	 RtoTJ2Vuqs4cc91YtSJVi7da735h99+QyNFD+YyQ=
Date: Fri, 20 Mar 2026 10:50:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-document-damos_commit_dests-failure-semantics.patch added to mm-new branch
Message-Id: <20260320175026.1FF21C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: document damos_commit_dests() failure semantics
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-document-damos_commit_dests-failure-semantics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-document-damos_commit_dests-failure-semantics.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: mm/damon/core: document damos_commit_dests() failure semantics
Date: Fri, 20 Mar 2026 07:36:45 -0700

Add a kernel-doc-like comment to damos_commit_dests() documenting its
allocation failure contract: on -ENOMEM, the destination structure is left
in a partially torn-down state that is safe to deallocate via
damon_destroy_scheme(), but must not be reused for further commits.

This was unclear from the code alone and led to a separate patch [1]
attempting to reset nr_dests on failure.  Make the intended usage explicit
so future readers do not repeat the confusion.

Link: https://lkml.kernel.org/r/20260320143648.91673-1-sj@kernel.org
Link: https://lore.kernel.org/20260318214939.36100-1-objecting@objecting.org [1]
Signed-off-by: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-document-damos_commit_dests-failure-semantics
+++ a/mm/damon/core.c
@@ -1060,6 +1060,23 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+/*
+ * damos_commit_dests() - Copy migration destinations from @src to @dst.
+ * @dst:	Destination structure to update.
+ * @src:	Source structure to copy from.
+ *
+ * If the number of destinations has changed, the old arrays in @dst are freed
+ * and new ones are allocated.  On success, @dst contains a full copy of
+ * @src's arrays and count.
+ *
+ * On allocation failure, @dst is left in a partially torn-down state: its
+ * arrays may be NULL and @nr_dests may not reflect the actual allocation
+ * sizes.  The structure remains safe to deallocate via damon_destroy_scheme(),
+ * but callers must not reuse @dst for further commits — it should be
+ * discarded.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
 static int damos_commit_dests(struct damos_migrate_dests *dst,
 		struct damos_migrate_dests *src)
 {
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch
lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch


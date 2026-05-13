Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3334B175A64
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778715901; cv=none; b=fQBHTRkCZgHW2sZam52KdGYKK4GEjOO0GpKk37ryvsoxS/hEZaWoD+gA4iCraeL5xW0vBE+NNW/q24M7GTMjQGw/ehPrzX3mD9oKk9lFvSeU7hfPuvwc4KGHOnnn4L5MJ5YZ94oezcP84XpLernhRkjN9+i8oeD4bXWNsvLrW44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778715901; c=relaxed/simple;
	bh=2ZnMlsFp8ViACwSeiGXysdZ1xd37jUJOnSjO5AZ+5Ww=;
	h=Date:To:From:Subject:Message-Id; b=aTrcNsRR3VyIRE26ji5JES7oUfxv4WpgTMwKrtOWyv3+wr5Ss8Uz78L4TYjlHXbiM1xo9TEt5Fzra0lEQ+j+3bEfyle9EOpuHxNXS88gjPplIJV3h4VokLGIAzpfkGf7WE7LM0OJfOEyjwJFU9lja8d8pTBtVZZT+avMar/f0Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iviSG81D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iviSG81D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7814C19425;
	Wed, 13 May 2026 23:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778715900;
	bh=2ZnMlsFp8ViACwSeiGXysdZ1xd37jUJOnSjO5AZ+5Ww=;
	h=Date:To:From:Subject:From;
	b=iviSG81DMBuYy/jyQWE4IiiFe7Fvpo1AhRVZkkkfK++Ce8JTJts33stBqG9fqQTRU
	 onEbGz2OIs/UV4h0v600Jv6z0xePYJ8GzOUBfemFe6SgYCjyUZem/Ni9rX//wX8tMl
	 1NsogOtXzZYGF501qMCruw9lQ+wGOkfCPXxtESkM=
Date: Wed, 13 May 2026 16:45:00 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page-types-fix-typo-in-madvise-error-message.patch added to mm-new branch
Message-Id: <20260513234500.A7814C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page-types: fix typo in madvise() error message
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page-types-fix-typo-in-madvise-error-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page-types-fix-typo-in-madvise-error-message.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page-types: fix typo in madvise() error message
Date: Wed, 13 May 2026 10:21:16 +0800

Patch series "tools/mm/page-types: Fix misc bugs".

This series fixes three issues in tools/mm/page-types.c:

1. Fix two typos in madvise() error messages ("madvice" -> "madvise")
2. Fix operator precedence bug in the sigbus handler where the ternary
   operator binds looser than addition, producing incorrect offset
   calculation when sigbus_addr is non-NULL
3. Fix --kpageflags option declaration in getopt_long: has_arg should
   be 1 (required_argument) since the option requires a file path


This patch (of 3):

Two error messages incorrectly spelled the madvise() function name as
"madvice".  Fix the typo in both occurrences.

Link: https://lore.kernel.org/20260513022120.58033-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260513022120.58033-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-fix-typo-in-madvise-error-message
+++ a/tools/mm/page-types.c
@@ -997,7 +997,7 @@ static void walk_file_range(const char *
 
 		/* turn off readahead */
 		if (madvise(ptr, len, MADV_RANDOM))
-			fatal("madvice failed: %s", name);
+			fatal("madvise failed: %s", name);
 
 		if (sigsetjmp(sigbus_jmp, 1)) {
 			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
@@ -1015,7 +1015,7 @@ got_sigbus:
 
 		/* turn off harvesting reference bits */
 		if (madvise(ptr, len, MADV_SEQUENTIAL))
-			fatal("madvice failed: %s", name);
+			fatal("madvise failed: %s", name);
 
 		if (pagemap_read(buf, (unsigned long)ptr / page_size,
 					nr_pages) != nr_pages)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch
mm-khugepaged-use-align-helpers-for-pmd-alignment.patch
mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch
tools-mm-page-types-fix-typo-in-madvise-error-message.patch
tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch
tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch


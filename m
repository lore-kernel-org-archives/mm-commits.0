Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC24D3B840F
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778715903; cv=none; b=KUZsJyUNKNOscMUTY+M/AzHW5z/YU2kjJ5ygpXrPS+7yaW3NurdWyxL5zqKv4ac4uwJc4q/Z4leHHUPrvhItUQXaSnJnRxcKnFBKkgEXdYH62VIZjCyDHDpD1OAn0qm4b56Ki87CuCB4bnME9/6M0LrMTTLxN8XuIQkFKka2j6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778715903; c=relaxed/simple;
	bh=N1cV3HgfSeOGh92WD3Cz3BaxbQwaykMKejtzUcd5HQw=;
	h=Date:To:From:Subject:Message-Id; b=jlozggDx+iduNo7qmlm2gReCe3+1o+v1V1Kexmvq6Rixaz0pGuNDskgqjrKNg3uSp8gur988Vq1EeYlYVr0fF7PLeCKCf7cOrz7yM6CqujOkwWXt+1i4lV0TBG2Wvg+CuMf1KIwnVUdL6/pzLomKPqKxJSn819HgGmH4DRKXdA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1+ARFMjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1+ARFMjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9960C19425;
	Wed, 13 May 2026 23:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778715902;
	bh=N1cV3HgfSeOGh92WD3Cz3BaxbQwaykMKejtzUcd5HQw=;
	h=Date:To:From:Subject:From;
	b=1+ARFMjCuKYTUtDDWwux7lBHZil1PmH87bW2gmP2nWjRuvKggZ7Qy99bKOSrwVGm8
	 /IwLxnXPJHIrvdBkZn1ZEgB4ZdMJyZJoPx1NugTZSrTlGoXFO+E1vSt4G7QLJNg2Y0
	 SbOOYRElnmhWrHgGQhF/ruZr+hw6hsrPnzaBoRUw=
Date: Wed, 13 May 2026 16:45:02 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch added to mm-new branch
Message-Id: <20260513234502.A9960C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page-types: fix ternary operator precedence in sigbus handler
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch

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
Subject: tools/mm/page-types: fix ternary operator precedence in sigbus handler
Date: Wed, 13 May 2026 10:21:17 +0800

The ternary operator (?:) has lower precedence than addition (+), so the
expression `off + sigbus_addr ?  sigbus_addr - ptr : 0` was parsed as
`(off + sigbus_addr) ?  (sigbus_addr - ptr) : 0` rather than the intended
`off + (sigbus_addr ?  sigbus_addr - ptr : 0)`.  Add explicit parentheses
to ensure the correct evaluation order.

Link: https://lore.kernel.org/20260513022120.58033-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler
+++ a/tools/mm/page-types.c
@@ -1000,7 +1000,7 @@ static void walk_file_range(const char *
 			fatal("madvise failed: %s", name);
 
 		if (sigsetjmp(sigbus_jmp, 1)) {
-			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
+			end = off + (sigbus_addr ? sigbus_addr - ptr : 0);
 			fprintf(stderr, "got sigbus at offset %lld: %s\n",
 					(long long)end, name);
 			goto got_sigbus;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch
mm-khugepaged-use-align-helpers-for-pmd-alignment.patch
mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch
tools-mm-page-types-fix-typo-in-madvise-error-message.patch
tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch
tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22CE317170
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 21:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772315296; cv=none; b=cXZGu+ebkd69tGQ8kUD1BCmOEO3IHqNMbXFBSxLn29HP5Wv4eMkZiZg9PoNtTC4h+/9/4htBjYmdvcwxzWDDcXdRyH/PDM7DtuaZBGjekOWNebs8T2A2+GJ3zyrrzg3tmyTi+Gd2Mtw6aZiozYDJmhumVTVRjQ1LIpxERvxGpQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772315296; c=relaxed/simple;
	bh=ML/W7Kqf6HxUuLHhBwGYXVG5tpbIBMlDyB6Vc2EMHuo=;
	h=Date:To:From:Subject:Message-Id; b=S3Ndz7AYFykLkeqQi8mFFQWl/f+gAUVcbbWm/yiCwKpcv9sd+wqaisS3YCECuY07mB3i3JJsS52CNZ7JwTskv6qtaOUK+PymvK9bM+OhREz2hd3xHh+RV64YRXG++q1C3CfTHYLTFKVcfQY51UaEbOJpwm6ZFMVA+292QpLAGcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OB9o0A2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OB9o0A2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E55BC116D0;
	Sat, 28 Feb 2026 21:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772315296;
	bh=ML/W7Kqf6HxUuLHhBwGYXVG5tpbIBMlDyB6Vc2EMHuo=;
	h=Date:To:From:Subject:From;
	b=OB9o0A2QNY/gXF4au9RLsjkwbt7newMUHAKv3cf9MWQ08QMCaXXpqo73iYjNM2KgH
	 RU7upZrdPKrohoOPnYSExsm76100OI8kCQ6NvNhkrTkP3Qy3M7HKhD62Dgswx3lVJh
	 cbCqGpi6oW83le/j2lxyk8qBzDhjHds6g0Whw9h8=
Date: Sat, 28 Feb 2026 13:48:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,ryan.roberts@arm.com,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch added to mm-new branch
Message-Id: <20260228214816.0E55BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_vm_pgtable: replace WRITE_ONCE() with pxd_clear()
has been added to the -mm mm-new branch.  Its filename is
     mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: replace WRITE_ONCE() with pxd_clear()
Date: Fri, 27 Feb 2026 06:12:04 +0000

Replace WRITE_ONCE() with generic pxd_clear() to clear out the page table
entries as required.  Besides this does not cause any functional change as
well.

Link: https://lkml.kernel.org/r/20260227061204.2215395-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Ackeed-by: SeongJae Park <sj@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-replace-write_once-with-pxd_clear
+++ a/mm/debug_vm_pgtable.c
@@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pmdp, __pmd(0));
+	pmd_clear(args->pmdp);
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
 	pmd = pmdp_get(args->pmdp);
@@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pudp, __pud(0));
+	pud_clear(args->pudp);
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
 	pud = pudp_get(args->pudp);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch


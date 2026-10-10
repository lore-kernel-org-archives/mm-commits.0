Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2D92D838E;
	Sat, 10 Oct 2026 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791665713; cv=none; b=Mmjr7FWpDrdjkScUfxHjdSbba0jJ10X+AWSiTN070z5JlNeVppl3krd1CaUZWVR3do/5ZiIZxZ91S4/zkOVJPt+MSYd1YNil6d4q6gPtzLHzswWky+mqKTVog8wtiE8pWpc7slDyXDYk0ableJSZQPE++AKpb7W4ggZ2JnY9ENk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791665713; c=relaxed/simple;
	bh=l/pA77dSyzLpiANHanuhuNte6TikHazMLn9L1rry280=;
	h=Date:To:From:Subject:Message-Id; b=JoAHO9rUnDg48KE0O3KZLojoi6QG7KgvOpLBVkC0z0PtMonERR27PEpKZgPC6uaBR4JgR26T4KTAwtfbeyqYH1rrPBZNcDYgcp7FnCIK+cYpVNjEf7XTo9i0jfXBzx/SNbCWtUYoeKcGm1agLW+NovEEimLF2IrMwmfSTNBPCUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EaN5dSBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EaN5dSBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BCF1F00893;
	Sat, 10 Oct 2026 20:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791665712;
	bh=TgO0RM7+gueSfcSArB5EZjdYr1QY33Xoodn+Bwkotyg=;
	h=Date:To:From:Subject;
	b=EaN5dSBpeA5jbLLSpL6+h4vAqU+1LZD94mU18LgN28cs5n2vedFUjvYc/oshnrm2x
	 mWJO1JnTIesCCAf288QDZGV0IcmxY83RgLlKdQQLGpSE6VtO2j2t4x+qtzOq8FDMv1
	 0ff9PTbwvKv+c9N6w9Aw7JihsOyNYpDc+iiWcec0=
Date: Sat, 10 Oct 2026 13:55:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kylebot@openai.com,jannh@google.com,harry@kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch added to mm-unstable branch
Message-Id: <20261010205512.32BCF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: don't discard lazyfree THPs at PMD level
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/rmap: don't discard lazyfree THPs at PMD level
Date: Fri, 09 Oct 2026 22:08:18 -0400

__discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it
knows whether the folio can be discarded, and restores it if the folio was
redirtied or has extra references.  A concurrent munmap() or
MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
anon_vma, so the folio stays mapped after the anon_vma is freed and a
later rmap walk uses the freed anon_vma.

Using an invalidated PMD instead of a cleared one requires additional arch
code fixes.  Instead, disable the PMD level discard of lazyfree THPs, as
before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
shrink_folio_list()").

Link: https://lore.kernel.org/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com
Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/rmap.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/rmap.c~mm-rmap-dont-discard-lazyfree-thps-at-pmd-level
+++ a/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rmap-dont-discard-lazyfree-thps-at-pmd-level.patch


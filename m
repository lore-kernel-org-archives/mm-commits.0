Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58D417591
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 05:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733549693; cv=none; b=J7viKCGrxIpMxskTALvK2PvBWJQDXBA5PeybQXqS91moNke9nHtY+z8JJAGMGhUPP3ofLbOzJ/UtvyyoeRTOrW7iJ7J77MPOab3fMLVUOEGWQ7qb+iPQbmCLx4ldAhPvg4dNxjiLb4JNtFO9NhCiuJay/bu+mB5R551CGZg8Ut8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733549693; c=relaxed/simple;
	bh=28Vb34rIkSbABCX2diX3uFWDvEZs+ssFupFc5Qfza8c=;
	h=Date:To:From:Subject:Message-Id; b=FonJNdVatm7uSPT5PNTnuoVl43td7XnW0Wm6hZvsIXCgedSIY9LVT/8iDQUogR3csE7X/xh5/LILGxlYgm4OerUtYrEW5YOVBmffjD78HZ9ql0rNDrxvRYSSP3tQ+FhVtHGEbP3UOswwwwbl7XYXDYFM3VCPCrIeofVlA3moLME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTM9y1ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTM9y1ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E67C4CECD;
	Sat,  7 Dec 2024 05:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733549692;
	bh=28Vb34rIkSbABCX2diX3uFWDvEZs+ssFupFc5Qfza8c=;
	h=Date:To:From:Subject:From;
	b=JTM9y1nyeVqzFZOVhagHrNEA3B4btCGzrdIURMCuQPnOQaT/h2FUZm9Ac+zIIFNIS
	 ZhrCFSZTdl87NsYUr1XsfYbOqKMzFzKsblmBq1d5xf4QqIhsl+NZpQyT1P9dMrEtLJ
	 dx5vw8Ovp1sB9yHxB7IsZEVOMlNYJKPH/+RpY/8c=
Date: Fri, 06 Dec 2024 21:34:51 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-rework-workingset-protection-fix.patch added to mm-unstable branch
Message-Id: <20241207053452.49E67C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mglru-rework-workingset-protection-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-rework-workingset-protection-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-rework-workingset-protection-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-mglru-rework-workingset-protection-fix
Date: Fri, 6 Dec 2024 21:44:15 -0700

Some outlier results from LULESH (Livermore Unstructured Lagrangian
Explicit Shock Hydrodynamics) [1] caught my eye. The following fix
made the benchmark a lot happier (128GB DRAM + Optane swap):
                            Before    After    Change
  Average (z/s)             6894      7574     +10%
  Deviation (10 samples)    12.96%    1.76%    -86%

[1] https://asc.llnl.gov/codes/proxy-apps/lulesh

Link: https://lkml.kernel.org/r/Z1PSn79GPcCxeI_g@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-rework-workingset-protection-fix
+++ a/mm/vmscan.c
@@ -916,8 +916,7 @@ static enum folio_references folio_check
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
-		lru_gen_set_refs(folio);
-		return FOLIOREF_ACTIVATE;
+		return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
 
 	referenced_folio = folio_test_clear_referenced(folio);
@@ -4173,11 +4172,7 @@ bool lru_gen_look_around(struct page_vma
 			old_gen = folio_update_gen(folio, new_gen);
 			if (old_gen >= 0 && old_gen != new_gen)
 				update_batch_size(walk, folio, old_gen, new_gen);
-
-			continue;
-		}
-
-		if (lru_gen_set_refs(folio)) {
+		} else if (lru_gen_set_refs(folio)) {
 			old_gen = folio_lru_gen(folio);
 			if (old_gen >= 0 && old_gen != new_gen)
 				folio_activate(folio);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch
mm-mglru-rework-workingset-protection-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18CB2E62C4
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766260354; cv=none; b=qNIc6uVOY0TXYMNjxfhwZYiZdhf1h9DqcrJiHckYJGplI6CCe61g22W2vB2CXdQslf8YPexqyZIRCoIUcaqPgR55qVuHRo2d2zwPpvXXkZhFiRgvQ1WbLl+QwmI4OSAhf2nSs9CZShaBKoGv65Oai9qDQ8+SNiAMrfKT8XNQwOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766260354; c=relaxed/simple;
	bh=B45KeqO0hJvpsf5+oYzZUHEP8XR5bSFTSRhbESkzWKk=;
	h=Date:To:From:Subject:Message-Id; b=XhsRiJnkj1ASNIBtgT01I1DG2zRLgLl1wM7MHPsoxmPBljIEdUCGVooDvxup2dkI6iI5b6K9H1wAPI46l8uFgwBnvFz3IZVG9tjZ6iEJ+WaikTsWqgVTwGCDEXMeAf8NQeLDAEsXsmGhazG4wkgSply9m3vGQ0S8HpQ18jb3gg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LKWeWTgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LKWeWTgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2424AC4CEF5;
	Sat, 20 Dec 2025 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766260354;
	bh=B45KeqO0hJvpsf5+oYzZUHEP8XR5bSFTSRhbESkzWKk=;
	h=Date:To:From:Subject:From;
	b=LKWeWTgBsL++RLW56Axpl3BcmNI/cKQz0jY1xm8xeGmwQdhOuCVsVi5pIiGiT3Yi6
	 fBukcZfQoNqRi2zA/upEMCDTdEJN3zZN+gvsi6128JrQB7Kar8uVcwx57vwfN6j3eO
	 MKZb4uLWLClRwEmzKAB1U/b4SKl5py9h6q0kKxL0=
Date: Sat, 20 Dec 2025 11:52:33 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,klourencodev@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-minor-spelling-mistakes-in-comments-fix.patch added to mm-new branch
Message-Id: <20251220195234.2424AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-minor-spelling-mistakes-in-comments-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-minor-spelling-mistakes-in-comments-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-minor-spelling-mistakes-in-comments-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-minor-spelling-mistakes-in-comments-fix
Date: Sat Dec 20 11:51:12 AM PST 2025

also fix comment grammar, per SeongJae

Cc: Kevin Lourenco <klourencodev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vma.c~mm-fix-minor-spelling-mistakes-in-comments-fix
+++ a/mm/vma.c
@@ -2907,10 +2907,10 @@ retry:
 		return -ENOMEM;
 
 	/*
-	 * Adjust for the gap first so it doesn't interfere with the
-	 * later alignment. The first step is the minimum needed to
-	 * fulfill the start gap, the next steps is the minimum to align
-	 * that. It is the minimum needed to fulfill both.
+	 * Adjust for the gap first so it doesn't interfere with the later
+	 * alignment. The first step is the minimum needed to fulfill the start
+	 * gap, the next step is the minimum to align that. It is the minimum
+	 * needed to fulfill both.
 	 */
 	gap = vma_iter_addr(&vmi) + info->start_gap;
 	gap += (info->align_offset - gap) & info->align_mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch


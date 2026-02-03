Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FA42BD5BD
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 23:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770161171; cv=none; b=ND2xfdkQNN3ddK42WjdYD8/LqpFTIq1G2pP8iXoRTvTjC86WthmNoc+m4UBUOmNzR6pbQGkpqtYvkRhndf3kufOrI44s/GfXqPzwJLoruql+NQAaFYnOLkZbp3U5Km7Vq7o8K4tD38d6Sa2sehuIqLouOVB73cGXIct0V+yuGB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770161171; c=relaxed/simple;
	bh=wwNrQUgEhlGlWpGFm9wmKkN35VXtHYDM5YgLeWYIrLs=;
	h=Date:To:From:Subject:Message-Id; b=t289dY6u1N1450DJz5I/CJkgB4YSj/2NJDnFCOspUug+Br7r/66GIziV6mea9EDNQUSBWKYQ0t5rRAyRirzQIkofwBskJPD4IWwJQRi9ZfbD5fHhdGQ9AY46mfrkJJ2Y8ayUlKxFnQIgc4pAcGsz7pnKAR8piEK4sc8R92SuUdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eaNtk50r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eaNtk50r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B57C116D0;
	Tue,  3 Feb 2026 23:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770161171;
	bh=wwNrQUgEhlGlWpGFm9wmKkN35VXtHYDM5YgLeWYIrLs=;
	h=Date:To:From:Subject:From;
	b=eaNtk50rmyzdiEba/8UmChab1leRsU9X/x+Rmp4p/Lb5RQWa4YVUV9SP4ObiYvcnl
	 sGc1lYCviexFDsBqafqqJQjng3L6eYYr06txqPffjEP4cH/DAQswBUG5b0SlgxHSX2
	 itruQb23ZgNw/TTu2WHKEEerFzmofAS9xiBxdUwE=
Date: Tue, 03 Feb 2026 15:26:10 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,qin.yuA@h3c.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch added to mm-new branch
Message-Id: <20260203232611.00B57C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove redudnant mmu notifier call in pmdp mkold
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch

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
From: qinyu <qin.yuA@h3c.com>
Subject: mm/damon: remove redudnant mmu notifier call in pmdp mkold
Date: Tue, 3 Feb 2026 17:54:00 +0800

Currently, mmu_notifier_clear_young() is called immediately after
pmdp_clear_young_notify(), which already calls mmu_notifier_clear_young()
internally.  This results in a redundant notifier call.

Replace pmdp_clear_young_notify() with the non-notify variant to avoid the
duplicate call and make the pmdp path consistent with the corresponding
ptep_mkold() code.

Link: https://lkml.kernel.org/r/20260203095400.2465255-1-qin.yuA@h3c.com
Signed-off-by: qinyu <qin.yuA@h3c.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold
+++ a/mm/damon/ops-common.c
@@ -90,7 +90,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 		return;
 
 	if (likely(pmd_present(pmdval)))
-		young |= pmdp_clear_young_notify(vma, addr, pmd);
+		young |= pmdp_test_and_clear_young(vma, addr, pmd);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
 	if (young)
 		folio_set_young(folio);
_

Patches currently in -mm which might be from qin.yuA@h3c.com are

mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch


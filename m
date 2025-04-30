Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7EC1E5B9D
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746050592; cv=none; b=Ap4Vbaq5941Zy3wdttDa8JMuQoOUpCYNVGN9I8JIMA96GTZNLBdOFbEu47L6BCRAB+rdUDcypzHqUcUgDB9/5e/GbQdaMhhibMaB9kLOJM2L7upantOjNSKcMsP+wOHVQeYSp6gpZrJ2USoJvFtlw/TmSNjQQRGGjymGO2Neov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746050592; c=relaxed/simple;
	bh=KhJTHdkalB3ick7+WyGxml1K0P2GoSkXOoejvomosPI=;
	h=Date:To:From:Subject:Message-Id; b=DQvX3k00UgUXjXRjlV9HlGD2l24oyahLXBczCnVbuptMf2TLhhQpV5BYUr8GxMT6Evq/e2HSeNiuvpw9YvUybXZTtR3DpqqLJ+vkWoGjF/Zkwpdq7iXJILc+FtoqU1O7bDBypJCBxgC2l+OyWYHotWvA2Me1ygPe/WpX0vBq9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Px5YpPWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Px5YpPWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6408EC4CEE7;
	Wed, 30 Apr 2025 22:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746050591;
	bh=KhJTHdkalB3ick7+WyGxml1K0P2GoSkXOoejvomosPI=;
	h=Date:To:From:Subject:From;
	b=Px5YpPWBZybtd0/pTpNZ0ylM1TBgpxZDI+We9JAgJwHhn0JZCIIsMeXaylCtkhmWt
	 VuHoPv0u2NssuRzkMuNE3v8fGhzuSLm2mROIydokkHD5GknuWSJTAxPTfvGKFTAnEH
	 ueLa5JoF9c5Z7UC6H+Y+lhEHiEYo2d/6RvKYEDps=
Date: Wed, 30 Apr 2025 15:03:10 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-page_folio-in-memfd_pin_folios.patch added to mm-new branch
Message-Id: <20250430220311.6408EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove page_folio() in memfd_pin_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-page_folio-in-memfd_pin_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-page_folio-in-memfd_pin_folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/gup: remove page_folio() in memfd_pin_folios()
Date: Tue, 29 Apr 2025 18:00:59 -0700

We can get the folio directly from the folio batch, so remove the
unnecessary page_folio() call.

Link: https://lkml.kernel.org/r/20250430010059.892632-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-remove-page_folio-in-memfd_pin_folios
+++ a/mm/gup.c
@@ -3641,7 +3641,7 @@ long memfd_pin_folios(struct file *memfd
 			}
 
 			for (i = 0; i < nr_found; i++) {
-				folio = page_folio(&fbatch.folios[i]->page);
+				folio = fbatch.folios[i];
 
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
 					folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-compaction-use-folio-in-hugetlb-pathway.patch
mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch
mm-gup-remove-page_folio-in-memfd_pin_folios.patch


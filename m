Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638811A38C5
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719531832; cv=none; b=IAP0uCMg9wBMJHwRkSz45SIAd+Y/LqfQ0nbGzqZFrtdUvO1+/V51CRfIT+T5/IsQF+6G5L2AXAR+UWDvtPH1xIamUH1pgBcJ4F7DBSQfO0ddsDnGraEVNum4zQpnsTUN8xPVkaMmT8mc880qC7H62hXwSgKgRYTuHbi6jhK2EJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719531832; c=relaxed/simple;
	bh=ohOdIiWI62qJz5YjoOcit/+Q3YtsuxbAiIzWHk5Bkf0=;
	h=Date:To:From:Subject:Message-Id; b=DO5pIR736kHYBuI4UDplvK9Q+WXanIYnE2VaZr3QQFdcgk4BuaPyMOT9yM4BjgI7PIx40O0cBMMC0C87lCsDbqWmPxVdsXmhcEpPcDeQvSe86+Yj7Icw6A8OxSJqlOfhHwQMLpUWHvb9l3T0XTHPNgvgnlYzQAhEDrydGTOIsQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xb8J6hzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xb8J6hzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11D1C32786;
	Thu, 27 Jun 2024 23:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719531831;
	bh=ohOdIiWI62qJz5YjoOcit/+Q3YtsuxbAiIzWHk5Bkf0=;
	h=Date:To:From:Subject:From;
	b=Xb8J6hzYeZKoZxUvJ02Gk9F+W5KpVdJih0SOMod/hQiTEgUOURIomDxyXhuWLE7BP
	 wA7CEzXILtoHmyVQiOfJjOLAnRO4uYTYE0E2iwPoTIUJFlRXvuVMBVjViKxzR24Dd1
	 B1wlAX6s5mVbuQSRwCe8j69IehzYkJcaRGYXovJQ=
Date: Thu, 27 Jun 2024 16:43:51 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch added to mm-unstable branch
Message-Id: <20240627234351.D11D1C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
Date: Thu Jun 27 04:39:10 PM PDT 2024

apply fixups per "mm: gup: do not call try_grab_folio() in slow path".

Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
+++ a/mm/gup.c
@@ -3856,14 +3856,15 @@ long memfd_pin_folios(struct file *memfd
 				    next_idx != folio_index(fbatch.folios[i]))
 					continue;
 
-				folio = try_grab_folio(&fbatch.folios[i]->page,
-						       1, FOLL_PIN);
-				if (!folio) {
+				if (try_grab_folio(fbatch.folios[i],
+						       1, FOLL_PIN)) {
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
 				}
 
+				folio = fbatch.folios[i];
+
 				if (nr_folios == 0)
 					*offset = offset_in_folio(folio, start);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memoryc-fix-used-uninitialized.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D69113CFAD
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720220162; cv=none; b=fm6UCuVD0hwJFHcsMSWoMx4tTAxpGg0mnRXgkkRbpsUavHD2UZIef8IIWQlb32bWGIk6H8axyK8cLxfcLl7VBqYFVmcwIOJaVZXuDrBChkQCUsTj14Tbxk/LolDmnPOIQLRn+NijQZLCV1uOrdavxtmjTu4ite/uUdgQTw6dvhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720220162; c=relaxed/simple;
	bh=YYrqzvm2OxgnAYpIqLOBVOCuhcX6e/lG5RVqeo3vsYU=;
	h=Date:To:From:Subject:Message-Id; b=h44f7pb5XTloJrvXRl62rAECMmgpr/2sguTiX87gpG/JhwVx8JSpYR7im6vT+wCJJmBo458syGabOQChRrjNol/mkrjDON3TkpgswHmIj2p/vpkBAoGmzTXWfnGqg1e65lVO3Y8/XMw4tHijBFBWJi34yVdx/+Fvm59/LoCdz2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHmN/chK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHmN/chK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11011C116B1;
	Fri,  5 Jul 2024 22:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720220162;
	bh=YYrqzvm2OxgnAYpIqLOBVOCuhcX6e/lG5RVqeo3vsYU=;
	h=Date:To:From:Subject:From;
	b=AHmN/chKa89T3NQdPrsvq5BMf5BBFmIroYu+FHiUb8chLy8siLVd8weuMMl/lXyoE
	 6vi4pC1IQVoP5KyP8csNkFx4ZutMMyW8RVcDROtNPssyXjSU1KBlmVs1njyRWiiJ2D
	 MnOSrkPcPnDxxX3KYnFX71HNAbLbAPLbzaj/JWRg=
Date: Fri, 05 Jul 2024 15:56:01 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,sj@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch added to mm-unstable branch
Message-Id: <20240705225602.11011C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch

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
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
Date: Fri Jul  5 03:12:47 PM PDT 2024

propagate try_grab_folio() retval, including the weird -EREMOTEIO

Cc: SeongJae Park <sj@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
+++ a/mm/gup.c
@@ -3848,6 +3848,8 @@ long memfd_pin_folios(struct file *memfd
 
 			next_idx = 0;
 			for (i = 0; i < nr_found; i++) {
+				int ret2;
+
 				/*
 				 * As there can be multiple entries for a
 				 * given folio in the batch returned by
@@ -3860,10 +3862,10 @@ long memfd_pin_folios(struct file *memfd
 					continue;
 
 				folio = page_folio(&fbatch.folios[i]->page);
-
-				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+				ret2 = try_grab_folio(folio, 1, FOLL_PIN);
+				if (ret2) {
 					folio_batch_release(&fbatch);
-					ret = -EINVAL;
+					ret = ret2;
 					goto err;
 				}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch


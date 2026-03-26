Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F346E384241
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568358; cv=none; b=IP3rrElC58H5VzclqGz3gw62DvTM6hIvqFHWl9YmWBPwjGWdaP+fD+eVZS4eEP09ZK7CrQcB0Ji171sVpsKjafCBAgMDQSQ+PMqABnHT2ajeBy5vtkc2PGmGRT1Clo4oQXUIqW7rt0myHD8sPNsU9kXUfDuynJbDMes9+K4z03s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568358; c=relaxed/simple;
	bh=w1aJ/f16VrieXawYccBOQu52YcWMpmmQoEl/ecZZvjE=;
	h=Date:To:From:Subject:Message-Id; b=IUK2OmjnftbWY5MhgNRQxs7MhbAgblGI2AngCDbYBuKJePiXTTBFSwf+7y8dYX1Da0etabHK2MNvfEi+4b+45kKkld/dsppgmN3Sx6MZnQ9C92DawKZ2j1XJ4JXZ2jCKqF8vsOgOHgrYGZn9aIBw4yatVEcp2LlIqEe8XTm7pJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aLhp2rio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aLhp2rio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB98AC116C6;
	Thu, 26 Mar 2026 23:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568357;
	bh=w1aJ/f16VrieXawYccBOQu52YcWMpmmQoEl/ecZZvjE=;
	h=Date:To:From:Subject:From;
	b=aLhp2riofS/qvnNjpnLGLW1l/xIaHackgvBvTPSwIrYb7uLjCNSpFG30Vzg+prFDe
	 8fXi3GOXf+tANeO1rVz+6Wc9EvRXHc09RHd4UK9hClRjbPIV6gIPXBE7fxegsnQuMP
	 UVZ1ra/hRe1F2/x01xi28Z0I4moB7yoyWr3GnOwU=
Date: Thu, 26 Mar 2026 16:39:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch added to mm-new branch
Message-Id: <20260326233917.AB98AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: fix physical address conversion in put_folios cleanup
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch

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
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: fix physical address conversion in put_folios cleanup
Date: Thu, 26 Mar 2026 16:47:25 +0800

In memfd_luo_retrieve_folios()'s put_folios cleanup path:

1. kho_restore_folio() expects a phys_addr_t (physical address) but
   receives a raw PFN (pfolio->pfn). This causes kho_restore_page() to
   check the wrong physical address (pfn << PAGE_SHIFT instead of the
   actual physical address).

2. This loop lacks the !pfolio->pfn check that exists in the main
   retrieval loop and memfd_luo_discard_folios(), which could
   incorrectly process sparse file holes where pfn=0.

Fix by converting PFN to physical address with PFN_PHYS() and adding
the !pfolio->pfn check, matching the pattern used elsewhere in this file.

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Link: https://lkml.kernel.org/r/20260326084727.118437-6-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup
+++ a/mm/memfd_luo.c
@@ -484,8 +484,13 @@ put_folios:
 	 */
 	for (long j = i + 1; j < nr_folios; j++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+		phys_addr_t phys;
 
-		folio = kho_restore_folio(pfolio->pfn);
+		if (!pfolio->pfn)
+			continue;
+
+		phys = PFN_PHYS(pfolio->pfn);
+		folio = kho_restore_folio(phys);
 		if (folio)
 			folio_put(folio);
 	}
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch


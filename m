Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C61C1799F
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 00:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763167967; cv=none; b=jPofwsxku7KbODuXb/4DgyCEma336U5fFzCPpHL4U2gpD5kVNwM45Vy60FlZOiPWR3EcdvW9iIh/wlEZaINS1NJFLEH5iT3vg/7B19tgqrq2jTUBKsMihD+/EPNiwOhlgPXf61kXNl91r8yusXgPemznOo9BNlEg35JsRgcObYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763167967; c=relaxed/simple;
	bh=yXIgxqVBOZ/De4NL7EutyvELQc1fxobGF1gzAmTkJdU=;
	h=Date:To:From:Subject:Message-Id; b=mVVGyNwy5EBzvW+Q3GQXThlLfr78SSgRiSPOGGD5CWzSlJ1BHxj95Ndp+FiMte3gyyAvrcPcvKlTvkji/D75D8vsg6eEYa25AQlGoUS67MSFkSCdrlmDGDSZ3sYIby0vLMqB1YhG9BJUV6hpSTt1g5CziZ0C4kb9DfiNcQBUMtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFX0IMSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFX0IMSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E172C19421;
	Sat, 15 Nov 2025 00:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763167967;
	bh=yXIgxqVBOZ/De4NL7EutyvELQc1fxobGF1gzAmTkJdU=;
	h=Date:To:From:Subject:From;
	b=lFX0IMSU2ScpqIGyHIn5hMPMSmL/Je4Non5xzuegJT9oU9J/OEdq7muvbH662Tm6b
	 aY+EYW+jZs8uf2/BLDY16wJeaSxQNWgjZhm6hcxCC5JURE6oMSrU1W+gFHnCx+AVzP
	 WM8cwFKr5iBtjJuhwGsOv4C2YL4kt2q/RRA+S3w0=
Date: Fri, 14 Nov 2025 16:52:46 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch added to mm-unstable branch
Message-Id: <20251115005247.0E172C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: gpu/drm/nouveau: enable THP support for GPU memory migration
has been added to the -mm mm-unstable branch.  Its filename is
     gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch

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
From: Balbir Singh <balbirs@nvidia.com>
Subject: fixup: gpu/drm/nouveau: enable THP support for GPU memory migration
Date: Sat, 15 Nov 2025 11:33:33 +1100

Kernel test robot, reported a sparse error with the patch

The sparse report states:

>> drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got int @@
   drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse:     got int

ret of type vm_fault_t is reused to capture the return value of
nouveau_dmem_copy_folio(), which returns an int. Use a new variable
err (of type int) to get the return value from the function to fix
the reported issue.

The reported issue is not new, prior to this, the function called
nouveau_dmem_copy_folio() was called nouveau_dmem_copy_one() and
ret was used to capture it's return value.

The reported issue also does not cause any runtime errors. The
return value from the function is used as a boolean value, to check if
nouveau_dmem_copy_folio() succeeded or failed.

Link: https://lkml.kernel.org/r/20251115003333.3516870-1-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_dmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -188,6 +188,7 @@ static vm_fault_t nouveau_dmem_migrate_t
 	struct nouveau_svmm *svmm;
 	struct page *dpage;
 	vm_fault_t ret = 0;
+	int err;
 	struct migrate_vma args = {
 		.vma		= vmf->vma,
 		.pgmap_owner	= drm->dev,
@@ -256,9 +257,9 @@ static vm_fault_t nouveau_dmem_migrate_t
 	svmm = folio_zone_device_data(sfolio);
 	mutex_lock(&svmm->mutex);
 	nouveau_svmm_invalidate(svmm, args.start, args.end);
-	ret = nouveau_dmem_copy_folio(drm, sfolio, dfolio, &dma_info);
+	err = nouveau_dmem_copy_folio(drm, sfolio, dfolio, &dma_info);
 	mutex_unlock(&svmm->mutex);
-	if (ret) {
+	if (err) {
 		ret = VM_FAULT_SIGBUS;
 		goto done;
 	}
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-zone_device-rename-page_free-callback-to-folio_free.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2.patch
mm-huge_memory-implement-device-private-thp-splitting.patch
mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-implement-thp-migration-of-zone-device-pages.patch
mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch
lib-test_hmm-add-zone-device-private-thp-test-infrastructure.patch
mm-memremap-add-driver-callback-support-for-folio-splitting.patch
mm-migrate_device-add-thp-splitting-during-migration.patch
lib-test_hmm-add-large-page-allocation-failure-testing.patch
selftests-mm-hmm-tests-new-tests-for-zone-device-thp-migration.patch
selftests-mm-hmm-tests-new-throughput-tests-including-thp.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped.patch


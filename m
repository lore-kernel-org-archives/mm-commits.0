Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332033EB19
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023495; cv=none; b=Up4mCiysb6zmUM8aVH1ofUvV6ihpcYBO4DBw4mrk98X5JvuZb4Cymfoaz3FbUKg7cnb1GNSiVsu/BL+Ry0hPq6rpTAaKjz2EI8D2hLUogSolqomtAcflja/R/yJwZX9kS+sns3GKOpog2oR6kBDTECB1NY0kxArjr0E+oAGge98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023495; c=relaxed/simple;
	bh=Mx4s9Quw7ApndriXtmpQYkNqxKf+Vavkq4IwA1pGM7M=;
	h=Date:To:From:Subject:Message-Id; b=em/bq46tBZrzvhbBZjNFl9XVqRfN9CtPLsNw1UMY9FnA/Ac51czjO52omeX9hZ9QJoauMOWbn5iq4juCotpK0iKkWtpDApknO2SjwcVwSYaGLRsTXaoGx3ehxuVUlAfcjRpji1eQc1y1e/eV5BUpjp4+3rNXh8votwx8+8FpCTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OsQHj0lV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OsQHj0lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB944C4CEFB;
	Mon, 24 Nov 2025 22:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023495;
	bh=Mx4s9Quw7ApndriXtmpQYkNqxKf+Vavkq4IwA1pGM7M=;
	h=Date:To:From:Subject:From;
	b=OsQHj0lV8MNhHp3oG9WYYO7LrsBZaf7PeI6KwvJGv+2TRQbD3uPc2VXF7WTrZtXUg
	 LrQFgVUy/ddLOm1viyfzgxiKXul5cNN2h+lkxWYVwfZ0Q4kJdd9pTOt5+ctiyie8ed
	 S1y9PUDIOKGnley6s5tPrDNDMesqHMG+qVHJ/EIY=
Date: Mon, 24 Nov 2025 14:31:34 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,david@kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch removed from -mm tree
Message-Id: <20251124223134.DB944C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: gpu/drm/nouveau: enable THP support for GPU memory migration
has been removed from the -mm tree.  Its filename was
     gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch

This patch was dropped because it was folded into gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch

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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
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
mm-huge_memoryc-introduce-folio_split_unmapped.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix.patch


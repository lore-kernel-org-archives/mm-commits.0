Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2714E299A94
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746493668; cv=none; b=jnIK/xuFho7qUzmlUtVp3+z+q3KQ6V2XC5OKTlCtrOHQTzV1wAledWMiZ9IX3gNgBm4X4PDH4Sq/j8IvgAcJFcIYiYKLZMwFHIugI4MZjjv+4f42eKnEZPqF9j8vLvhE7o3wxa5dTQ98E5eqTkw3pWSGcoLo2enAoySETBNFkSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746493668; c=relaxed/simple;
	bh=R+pIa85hSO4Hn4LtZehxFlxuQvGhsUBIAvNm7Hxanf8=;
	h=Date:To:From:Subject:Message-Id; b=B86kQ669769857FcrpziKr3evq+wVSxWJp0fifvRsG/osy5l3iBoBPrTVtgDFCu2jXrdxcmCWjtDica5V/yxNA6ogrvi+1Gz2laRgNv7113V5AH3FPN34rMqdfmSwGKB0je6jpsSQhZW8MrWf4M2lLNSuXfPHJkJjrPY4SDvInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMFHoynC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMFHoynC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77453C4CEE4;
	Tue,  6 May 2025 01:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746493667;
	bh=R+pIa85hSO4Hn4LtZehxFlxuQvGhsUBIAvNm7Hxanf8=;
	h=Date:To:From:Subject:From;
	b=kMFHoynCl9nfp++J/1Tgc6+RtCxIUQuAyp+irvLJzP2ZwRP5gDUYBeeNuB19E5ZhT
	 K/9uDSeRXSX2lNzheOCfmc/k8PXQFTAfmof1xOACWhNNXnyH8f6Gz0pskmteZggYHF
	 V3PkTTFfmHqragG6uzz97XVhdl6QlVm9xoPXRSas=
Date: Mon, 05 May 2025 18:07:46 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,lkp@intel.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zblock-allocator-fix-3.patch added to mm-new branch
Message-Id: <20250506010747.77453C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-zblock-allocator-fix-3
has been added to the -mm mm-new branch.  Its filename is
     mm-add-zblock-allocator-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-zblock-allocator-fix-3.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix-3
Date: Mon May  5 06:06:27 PM PDT 2025

fix kerneldoc for zblock_create_pool()

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505060720.ClN2d7w7-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zblock.c~mm-add-zblock-allocator-fix-3
+++ a/mm/zblock.c
@@ -117,7 +117,6 @@ static struct zblock_block *alloc_block(
 /**
  * zblock_create_pool() - create a new zblock pool
  * @gfp:	gfp flags when allocating the zblock pool structure
- * @ops:	user-defined operations for the zblock pool
  *
  * Return: pointer to the new zblock pool or NULL if the metadata allocation
  * failed.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch


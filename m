Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5671F0984
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695695; cv=none; b=fqbym7aGPUMFiknZnqWl0DNWuaH3vlOZU3KJ1MrLRTBKPHmsL3AJ473SZOUNQX4TPk+ZBuGJelQvyaA78geV7juZHufYLldv6pFa/IMzO+XqJ99ugiLNvBX+sVvX5+i5HHWzG1xltpZ5Uo6muCiMFPYJFVEdOWOUcc06uSXzlGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695695; c=relaxed/simple;
	bh=c6a7JbO5ANHpeHxyI6HmxaU3YAduKmFz6YQwIR6b6Ik=;
	h=Date:To:From:Subject:Message-Id; b=jxC1GUV/4tbbbjC/Ya6Y2BPHvTi/qmfDmichRGypA3w/JwjbsXKhfwWcMfAQtpD8GaT+HaFcmYb4dcn0I1ZUGtc5SsGbpVw0JPoKoekYRYvih2MHo0uIrcxMNnY+JjJmeIHLs0qUDcGr/yS7qgFrSzHoI3PBUIGSLLM19qfEk8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YuD+ctCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YuD+ctCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DC1C4CEE4;
	Mon, 19 May 2025 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695695;
	bh=c6a7JbO5ANHpeHxyI6HmxaU3YAduKmFz6YQwIR6b6Ik=;
	h=Date:To:From:Subject:From;
	b=YuD+ctCXmwu/OBy4zBoSQ/LFAlUIVf74HMOd9BggqFsLH77Z/ezxtUSJOfVmiPljz
	 V2f4YuKPc4kpV7L0lFFM1ATpjpqFoJINID/159G4lFEtC4tBlhc3UBgIFfICWHHgdT
	 RSLE1y/ZpjjtzBvYDzwncccfZwjCHdUIgwNL40rY=
Date: Mon, 19 May 2025 16:01:34 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch added to mm-new branch
Message-Id: <20250519230135.44DC1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: remove unneeded xa_is_value() check in shmem_unuse_swap_entries()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/shmem: remove unneeded xa_is_value() check in shmem_unuse_swap_entries()
Date: Sat, 17 May 2025 01:09:39 +0800

As only value entry will be added to fbatch in shmem_find_swap_entries(),
there is no need to do xa_is_value() check in shmem_unuse_swap_entries().

Link: https://lkml.kernel.org/r/20250516170939.965736-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries
+++ a/mm/shmem.c
@@ -1446,8 +1446,6 @@ static int shmem_unuse_swap_entries(stru
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		if (!xa_is_value(folio))
-			continue;
 		error = shmem_swapin_folio(inode, indices[i], &folio, SGP_CACHE,
 					mapping_gfp_mask(mapping), NULL, NULL);
 		if (error == 0) {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch


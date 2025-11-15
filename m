Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D483303C8A;
	Sat, 15 Nov 2025 18:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763232764; cv=none; b=PDnTyWZe0HSEiCVhbrZ4Fpa6sFj5J1ydPOPkrZDYvN0h0AGW4iWGd3qMvNwGZK2PBDwhUCLIIZfaiJy6/9sOkI9WNsPNV+xN9Ls8udn6ao6sgdbr9+f11eTaDSCAO7/XRKFNYhPaLgMFLl/FhAWo9qFZkawoVGPxJk500quZdB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763232764; c=relaxed/simple;
	bh=Er9hdcgNskam3PzMLjiTmHAsFZiJOnk4VhRxn8n5UoU=;
	h=Date:To:From:Subject:Message-Id; b=LuXqB/4MYQDUCcC5Jm/OpO+jdEiOVz9Yqm4BW3aqwsBIpphqHXXaOHr8dSh81DCThWP2FCEoVe6zGAlEzZ1h7hSK6N49RH4hCk69xPBvXq216C5dEVHerL0516XY7LbuoLVGlHiJMvUBdM9L7btVnviPIdNo1cgamcmIkVnBbCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mY7+MWQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mY7+MWQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3709C4CEF8;
	Sat, 15 Nov 2025 18:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763232763;
	bh=Er9hdcgNskam3PzMLjiTmHAsFZiJOnk4VhRxn8n5UoU=;
	h=Date:To:From:Subject:From;
	b=mY7+MWQOu+dlwmENXS8A90ErTlXH0untaQHuIq3/ok3v+TG77L83YRqHCkGf2PRd+
	 kRP+U8E7gZeeTi8JEyxfxxRyEbQZakf5kdlUmr11r75nbITA4sd+2hlDM2oEKwXx5z
	 CmgM0Fs03k+bU5siQhBwo5zV/D6Hx+YTNpsdG0uM=
Date: Sat, 15 Nov 2025 10:52:43 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-fix-potential-uaf-issue-for-vma-readahead.patch removed from -mm tree
Message-Id: <20251115185243.A3709C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix potential UAF issue for VMA readahead
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-potential-uaf-issue-for-vma-readahead.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix potential UAF issue for VMA readahead
Date: Tue, 11 Nov 2025 21:36:08 +0800

Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
pinning"), the common helper for allocating and preparing a folio in the
swap cache layer no longer tries to get a swap device reference
internally, because all callers of __read_swap_cache_async are already
holding a swap entry reference.  The repeated swap device pinning isn't
needed on the same swap device.

Caller of VMA readahead is also holding a reference to the target entry's
swap device, but VMA readahead walks the page table, so it might encounter
swap entries from other devices, and call __read_swap_cache_async on
another device without holding a reference to it.

So it is possible to cause a UAF when swapoff of device A raced with
swapin on device B, and VMA readahead tries to read swap entries from
device A.  It's not easy to trigger, but in theory, it could cause real
issues.

Make VMA readahead try to get the device reference first if the swap
device is a different one from the target entry.

Link: https://lkml.kernel.org/r/20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com
Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/swap_state.c~mm-swap-fix-potential-uaf-issue-for-vma-readahead
+++ a/mm/swap_state.c
@@ -748,6 +748,8 @@ static struct folio *swap_vma_readahead(
 
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
+		struct swap_info_struct *si = NULL;
+
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
 			if (!pte)
@@ -761,8 +763,19 @@ static struct folio *swap_vma_readahead(
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
+		/*
+		 * Readahead entry may come from a device that we are not
+		 * holding a reference to, try to grab a reference, or skip.
+		 */
+		if (swp_type(entry) != swp_type(targ_entry)) {
+			si = get_swap_device(entry);
+			if (!si)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
+		if (si)
+			put_swap_device(si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch


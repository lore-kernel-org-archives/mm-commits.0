Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE1A1E1DF0
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547816; cv=none; b=XYhqeNH9VN57Bw8JMtcCb0iuR7V1HFHEhDVXY9YEGsvfWo6ihLEmbCEJGBjqy757nHLvmEs3x4xA5ObETBlf4qG5wMpiJ7mog1w6P+DVG/uGt1xuhVA6+yMp8Jk9pR5buSdXcp6kRzSm5AjgL0cWmjiCYCvx15FmdPUY7VHNK6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547816; c=relaxed/simple;
	bh=3sYfgPaPqQxYV6Q8q2D4Wc2hFxmsXHhhKzkO00jp680=;
	h=Date:To:From:Subject:Message-Id; b=HW9V+hl49yszMTkSGv68H7rMABK9cj6phqc1+Dx99JD8xhL6bonrGlTdi0zEnzmnbub8d0cx1zFPDOqkhEtI9qBvcL6j1IYLNkTxrOISff5lMxi9K6oDevLZZSCCNh7thc8lANdOp9x6YJEfEx21T6VGdYCZhEXnpuzopzJW8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NCoK0Mqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NCoK0Mqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5ADC4CEF7;
	Fri, 20 Feb 2026 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547815;
	bh=3sYfgPaPqQxYV6Q8q2D4Wc2hFxmsXHhhKzkO00jp680=;
	h=Date:To:From:Subject:From;
	b=NCoK0MqsR9AB6LuYYb9f+FGdi8MC4mJJ5lbCoVLdChkCJ83aNaft0rhC1eu1iEOu4
	 eP/tF4kh8mOxBWXujQ+dwNM6f4DtLsRVLklQiTnjXEclPG1lAuDudT9gZBNcAlnWCw
	 UDsV+4GAfzN1inj9jr070Q3BM2oBV8XDMS64xnLs=
Date: Thu, 19 Feb 2026 16:36:55 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-no-need-to-truncate-the-scan-border.patch added to mm-new branch
Message-Id: <20260220003655.CC5ADC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: no need to truncate the scan border
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-no-need-to-truncate-the-scan-border.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-no-need-to-truncate-the-scan-border.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: no need to truncate the scan border
Date: Wed, 18 Feb 2026 04:06:35 +0800

swap_map had a static flexible size, so the last cluster won't be fully
covered, hence the allocator needs to check the scan border to avoid OOB. 
But the swap table has a fixed-sized swap table for each cluster, and the
slots beyond the device size are marked as bad slots.  The allocator can
simply scan all slots as usual, and any bad slots will be skipped.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-10-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    2 +-
 mm/swapfile.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swap-no-need-to-truncate-the-scan-border
+++ a/mm/swapfile.c
@@ -945,8 +945,8 @@ static unsigned int alloc_swap_scan_clus
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
+	unsigned long end = start + SWAPFILE_CLUSTER;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 
--- a/mm/swap.h~mm-swap-no-need-to-truncate-the-scan-border
+++ a/mm/swap.h
@@ -85,7 +85,7 @@ static inline struct swap_cluster_info *
 		struct swap_info_struct *si, pgoff_t offset)
 {
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	VM_WARN_ON_ONCE(offset >= si->max);
+	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
 	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-speed-up-hibernation-allocation-and-writeout.patch
mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch
mm-swap-clean-up-swapon-process-and-locking.patch
mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch
mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch
mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch
mm-swap-implement-helpers-for-reserving-data-in-the-swap-table.patch
mm-swap-mark-bad-slots-in-swap-table-directly.patch
mm-swap-simplify-swap-table-sanity-range-check.patch
mm-swap-use-the-swap-table-to-track-the-swap-count.patch
mm-swap-no-need-to-truncate-the-scan-border.patch
mm-swap-simplify-checking-if-a-folio-is-swapped.patch
mm-swap-no-need-to-clear-the-shadow-explicitly.patch


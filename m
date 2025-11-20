Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1412874F5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657669; cv=none; b=rjsGH3O1Hkqc76o2gHUVkrIZWHCbE0/35hSHG9nurppVK9fYtRR4HOqRV8sxyky9FERiscVbkbWrYVSYZP9bD/KRZR/tcnylMCRsrCK/vmm6CWH9SqFSbbKwDi79sNO+k6Iaa+t0+U0ZoFKJA/bCwmfIKkXmnMp5fLvVIRMDv7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657669; c=relaxed/simple;
	bh=Mm0onnVXCza0/xXPsk1acUDsP/74wRez84k11o9IePY=;
	h=Date:To:From:Subject:Message-Id; b=skncunYrifUYUI2vmYDoWOxejX+K3c0UZYnLT8zJpX/6g+1bS2ZYGH8ogJi/aSWbuMc/ggBCHEhE4AMS72bNIEti8s5gs6kQ8zIwvbCEnNM2DzxLrH9rupuSXTJH5s1mzOepz2eJoYsTEkTZccRUTPhjOMWtaCzRtb+WwhboaVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m6zrsfb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m6zrsfb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5068C4CEF1;
	Thu, 20 Nov 2025 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763657668;
	bh=Mm0onnVXCza0/xXPsk1acUDsP/74wRez84k11o9IePY=;
	h=Date:To:From:Subject:From;
	b=m6zrsfb68WnHvN98HNLTndsLAAEc8slb1GsAA7cuh3LPqYV0ok2xcLB06CjQNg0DT
	 S/2SvJY+TR4m2/tC+fC7TTzCAL5zhRS2zcvG1QX76I62cL69UW4Wu6XhtJVMz7ph+Z
	 Y6tnq4VRNlwPirqR7THMlrrZpOyP5lHiCGBPditM=
Date: Thu, 20 Nov 2025 08:54:28 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch added to mm-new branch
Message-Id: <20251120165428.D5068C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: use SWP_SOLIDSTATE to determine if swap is rotational
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: use SWP_SOLIDSTATE to determine if swap is rotational
Date: Fri, 31 Oct 2025 15:50:08 +0900

The current non rotational check is unreliable as the device's rotational
status can be changed by a user via sysfs.

Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time, to
ensure the nr_rotate_swap count remains consistent.  Plus, it is easy to
read and simple.

Link: https://lkml.kernel.org/r/20251031065011.40863-3-youngjun.park@lge.com
Fixes: 81a0298bdfab ("mm, swap: don't use VMA based swap readahead if HDD is used as swap")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational
+++ a/mm/swapfile.c
@@ -2910,7 +2910,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	if (!p->bdev || !bdev_nonrot(p->bdev))
+	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch
mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch
mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch


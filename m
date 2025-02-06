Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4E225415
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828651; cv=none; b=I0ri9N4qSuAPSWxVOQgavb7OdWIFB4pKodYBukZZg5DDxaG26ECPeVo6fFQddf7bGVIZ2CdJC+CXOuxa5SN/mrLSM/YyiGiUWQvhtllVc7jcypiy6PzuIw9+u6Txw0LGj0QBhhV/22dbIWr/DSQJyEkBmj4Vcr0IHnToJ0ESRIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828651; c=relaxed/simple;
	bh=PvtsbNfDWjstMItOLJtgb+fEe0ipnbKg3PXQxzSamuk=;
	h=Date:To:From:Subject:Message-Id; b=OCUrTsKWHgrxx89QTB7gFdsbIG9lKt8GepPzg0RgMoEWHJZRQpQ/uBOXwl9pwBkCixtZk/WVBYO2Ors99IhjzrGiIceGDnESGqkVujFRB4gfeGoRCPPRC6d5qFI3zI4ekDPaza1P586qI5vs5KAIcehX+rACAfM3H/kvdL/Nv7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eigUj2pW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eigUj2pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8083CC4CEE0;
	Thu,  6 Feb 2025 07:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828650;
	bh=PvtsbNfDWjstMItOLJtgb+fEe0ipnbKg3PXQxzSamuk=;
	h=Date:To:From:Subject:From;
	b=eigUj2pWGWqY718gwix6qjAAq10GoWRJDg53caNX9mfyQCZr7EfWd9nVPZYCvKXoj
	 hv5/cih6EhyjzCxQdGqEKWFBpuMMQnWeo+ehlz8O0sN0r2MNT9mgez9awPt3NGc/+7
	 RAQtUCHkhYp18Xai0aETyfgEkJUTC/VTDUYYYEC4=
Date: Wed, 05 Feb 2025 23:57:29 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-swap_flag_prio_shift.patch added to mm-unstable branch
Message-Id: <20250206075730.8083CC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove SWAP_FLAG_PRIO_SHIFT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-swap_flag_prio_shift.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-swap_flag_prio_shift.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: remove SWAP_FLAG_PRIO_SHIFT
Date: Wed, 5 Feb 2025 17:27:12 +0800

It doesn't make sense to have a zero value of shift.  Remove it to avoid
confusion.

Link: https://lkml.kernel.org/r/20250205092721.9395-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/swapfile.c        |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/swap.h~mm-swap-remove-swap_flag_prio_shift
+++ a/include/linux/swap.h
@@ -24,7 +24,6 @@ struct pagevec;
 
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
-#define SWAP_FLAG_PRIO_SHIFT	0
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
 #define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
 #define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
--- a/mm/swapfile.c~mm-swap-remove-swap_flag_prio_shift
+++ a/mm/swapfile.c
@@ -3449,8 +3449,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mutex_lock(&swapon_mutex);
 	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
-		prio =
-		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
+		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch


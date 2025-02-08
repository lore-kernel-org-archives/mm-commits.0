Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA8FA23
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738984574; cv=none; b=URzRNR+DJN0xtHv9O65Ji/RHzTzAun3ERKq1uK9Iyqs/WXYd3zyUfP2kSo0LRWpMJOb6HESvMjOvWIxOhXT29vI7BGYaXx6hQN6J1mLthJjE/l9ttyFHNDe7IMoM+5mPkV5JLLPE4GpGdnEwz1txO4CNcHUgwfsuhmLPjX2n7Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738984574; c=relaxed/simple;
	bh=cafgEsy2+cVYeEwErdJia8th35w3l01C9H+fNxZTHEw=;
	h=Date:To:From:Subject:Message-Id; b=ct8YlB7f+/E8d0ByYcsFxeN0O0M8V/akhuUZ3rzPq3a52fGlvQ6CLs00Z9rHMwfxB4E9iLBsNmm01LwPwL4Hu2O3IDv1Nh07g+dobDBd7nbvxXbZZuDXwcjYyI3hyOcmXp4UF70onYjXZ2D681q+hFfabRAj757NxUi2jXuipH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h0bO/dvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h0bO/dvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FDEC4CED6;
	Sat,  8 Feb 2025 03:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738984573;
	bh=cafgEsy2+cVYeEwErdJia8th35w3l01C9H+fNxZTHEw=;
	h=Date:To:From:Subject:From;
	b=h0bO/dvr96BKaLlLogbF/+shnuVEz27g/zG5CkD2Ctl+AAYzHfhQBsWFscRxkGp8j
	 hB0eVS9Fyz59TOLxfFMllqnP6RuHECQuYATS+az89PGcfabxKsiZuZT1Vq+y4jCPVD
	 txIvRAASRCqoVziQs1fESJh2Gvwf65QQPBfd0GjI=
Date: Fri, 07 Feb 2025 19:16:12 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch added to mm-unstable branch
Message-Id: <20250208031613.54FDEC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile.c: update the code comment above swap_count_continued()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch

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
Subject: mm/swapfile.c: update the code comment above swap_count_continued()
Date: Fri, 7 Feb 2025 10:50:37 +0800

Now, swap_count_continued() has two callers, __swap_duplicate() and
__swap_entry_free_locked(), the relevant code comment is stale.  Update it
to reflect the current situation.

Link: https://lkml.kernel.org/r/Z6V0/UvG1fvkQ4t/@fedora
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2
+++ a/mm/swapfile.c
@@ -3790,7 +3790,7 @@ outer:
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
  * Called while __swap_duplicate() or caller of __swap_entry_free_locked()
- * holds swap or cluster lock.
+ * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,
 				 pgoff_t offset, unsigned char count)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch


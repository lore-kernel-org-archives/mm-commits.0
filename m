Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B641C946A
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771626875; cv=none; b=Fm8y8HQ8dko5+ZAHwxHobhX9w0GcXbKWVKsmsoWJukvCZIIFjNI0JLufEC5H8mhf8OjjpXGu6Pc4zebangq5f5ebqi2e5/f3JKURZbmQpDj1LsRxIQY8it2pWvb3CETjj3ZjTh+TX6faC+gJiax3LQlr7UeG0cKB+rUcRgYEPwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771626875; c=relaxed/simple;
	bh=UU7Ocau5h5ldkLdK1ylAZVfgIh/Kna0c9j62/K2oECY=;
	h=Date:To:From:Subject:Message-Id; b=cENzqjDDPMNXGHm+ZMyjnJgK3EjZc+KV1g/Dck+XtJuEfiN0ddf5FdV2yLraikj1lfkgRAvoWHFRfGthC9q6gI7EvSyvh1d86ooEKIu1WGeAV0cul0bjLu0mIM+9OYegjiYekJ4XVHj1+6/SpL1eKlJ8ppzY3kSmwzQ0xQEP+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDeJ3irg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDeJ3irg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41973C116C6;
	Fri, 20 Feb 2026 22:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771626875;
	bh=UU7Ocau5h5ldkLdK1ylAZVfgIh/Kna0c9j62/K2oECY=;
	h=Date:To:From:Subject:From;
	b=LDeJ3irgSNI4R4dD9IukQEB5QS2HWc2mUQPj/EuvivNFQJm9rX123fpSYBzcwo6OX
	 KLMx54AEPvf0+3ou6Qfs5D+7kldYitkxeHRjMieOKBtKYfVRk7IQBRM8dkalFA4D1b
	 pj+xrbGEEg5oedK5eSXR6bNvpJFio03SxUVNCwnI=
Date: Fri, 20 Feb 2026 14:34:34 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch added to mm-new branch
Message-Id: <20260220223435.41973C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: remove unnecessary restrain unmask of swap gfp flags
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch

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
Subject: mm/shmem: remove unnecessary restrain unmask of swap gfp flags
Date: Wed, 11 Feb 2026 22:33:23 +0800

The comment makes it look like copy-paste leftovers from
shmem_replace_folio.  The first try of the swap doesn't always have a
limited zone.

So don't drop the restraint, which should make the GFP more accurate.

Link: https://lkml.kernel.org/r/20260211-shmem-swap-gfp-v1-1-e9781099a861@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags
+++ a/mm/shmem.c
@@ -2044,14 +2044,8 @@ static struct folio *shmem_swap_alloc_fo
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	gfp_t alloc_gfp;
+	gfp_t alloc_gfp = gfp;
 
-	/*
-	 * We have arrived here because our zones are constrained, so don't
-	 * limit chance of success with further cpuset and node constraints.
-	 */
-	gfp &= ~GFP_CONSTRAINT_MASK;
-	alloc_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);
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
memcg-consolidate-private-id-refcount-get-put-helpers.patch
mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch


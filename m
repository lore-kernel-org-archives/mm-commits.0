Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40F74915B9
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789688507; cv=none; b=ospj7iPufeiwYlzBXlHSg4I6jYuIQAW2hquIh533N8PmTXDsr386cXKRrDfsgQ5kOwdGhY43QgCgkTgcoUsaHm06WINaf6xjZo0T/hny1aoG4Rc6NYMbdjh2eJ8nBWztjSMfkrKrLkgrfOqDGVcBWtqbltlrCor4f3qZYJr6tYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789688507; c=relaxed/simple;
	bh=Wf9znMXDepkeWXsOPdXWrFBseaTr6Zd3fNrRQLvcjH0=;
	h=Date:To:From:Subject:Message-Id; b=TJ8flgzE4Xfwzo6dQDx5YzMGFjgwMz3g6XTaXxRnr2fY8lJLunRTB8iwJvVf5GjanSo7RLahgYVbE09qbsYutH7EUBDFER44jpiOMgmeW041Upk3TirXGiJwbwRjJbIBYEyNCAevZQUAGKIIPqhU1AbMLojhKewEn+kS9eOXlWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jz9To90B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jz9To90B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BF11F000FF;
	Thu, 17 Sep 2026 23:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789688505;
	bh=TUcVnBEDBB9QgswJFwiSkV15/YI8ioKCgWGsuNQuGoo=;
	h=Date:To:From:Subject;
	b=jz9To90B3k4w3NMtagHbI6nkj6ol7BHoArheYnR4J0+FcsDp1y4+CvtcKFB7Jdx+u
	 TYKGkSdZdmjh76gGnATuIpunarNDBQG0Y6dnNg0P0m3K6ok+7WHblEc4/mIULkm1J8
	 gKTwiIJwjTenTQnWIOn5h3TW8cjL8Xm015xNltAE=
Date: Thu, 17 Sep 2026 16:41:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch added to mm-new branch
Message-Id: <20260917234145.49BF11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix
Date: Thu Sep 17 04:39:24 PM PDT 2026

fix comment, per Zi Yan.

Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix
+++ a/mm/ksm.c
@@ -1617,7 +1617,7 @@ static int try_to_merge_with_ksm_page(st
 
 	/*
 	 * We can consider the VMA only while still holding the mmap lock,
-	 * so lock, so reference the anon rmap and calculate the linear
+	 * so reference the anon rmap and calculate the linear
 	 * page index early, before stable_tree_append(). If anything goes
 	 * wrong that prevents the rmap_item from being added to the
 	 * stable_tree, break_cow() will clean it up.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


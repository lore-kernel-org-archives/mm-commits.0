Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178912C499
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 22:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738277460; cv=none; b=el+FI8/UrRvq3ulVc34ynRkA0cTkZd8h9R1S9dcqJiGhgoz7BdBorUCSBQQ6Y/396xEOGgkzqIlGzH4S2bnXaWCRfwZjbc3/gbt4YcbG/lEUPwVH/lurSZ4X7C4OyGomqy0yXsvxLWb4Y7ptqlPXa2/XiQa4pmb7cAKKz9fHxV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738277460; c=relaxed/simple;
	bh=gYwOuT2EhNLGbM19pxiyYxSYfEBgsc4S/S7MLIITKAE=;
	h=Date:To:From:Subject:Message-Id; b=Jn7ebjPdH2H0ZD1Z9FdBY6jVtkBmkmojCSSMtuElieJKLpapGjCDOMwPFhJYSD46D9PmIzJX8bru8oYUbgJC+TQi6hkKDjOF4nlKTW3rUR/6KRfVFFRbaJRGKv1KJPPiYHvM6u43acXNRp6jvoWuGT+ecG3ROxS/RfiYi6Pxl6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzK8t6uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzK8t6uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739DCC4CED2;
	Thu, 30 Jan 2025 22:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738277459;
	bh=gYwOuT2EhNLGbM19pxiyYxSYfEBgsc4S/S7MLIITKAE=;
	h=Date:To:From:Subject:From;
	b=RzK8t6uciemM8F2XsjRk4cWnrDmm24W0Otnj6OpcczmSbvB9RnToF9o0KWN3dOyVD
	 PGnGkj3NuhGzzvrvWrYC54INOFWqLxPquTfVZ0lKPSYYycJvyMm3sx8e7rxnsJwiL1
	 Uy6sjSxfyKw1X8ZZKZp5BODlYxtISQyZuhig98dE=
Date: Thu, 30 Jan 2025 14:50:58 -0800
To: mm-commits@vger.kernel.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-reclaim-offset-calculation-error-during-allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250130225059.739DCC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix reclaim offset calculation error during allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-reclaim-offset-calculation-error-during-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-reclaim-offset-calculation-error-during-allocation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix reclaim offset calculation error during allocation
Date: Thu, 30 Jan 2025 19:51:31 +0800

There is a code error that will cause the swap entry allocator to reclaim
and check the whole cluster with an unexpected tail offset instead of the
part that needs to be reclaimed.  This may cause corruption of the swap
map, so fix it.

Link: https://lkml.kernel.org/r/20250130115131.37777-1-ryncsn@gmail.com
Fixes: 3b644773eefd ("mm, swap: reduce contention on device lock")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chis Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-fix-reclaim-offset-calculation-error-during-allocation
+++ a/mm/swapfile.c
@@ -794,7 +794,7 @@ static unsigned int alloc_swap_scan_clus
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, start, end);
+			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
 			/*
 			 * Reclaim drops ci->lock and cluster could be used
 			 * by another order. Not checking flag as off-list
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-fix-reclaim-offset-calculation-error-during-allocation.patch


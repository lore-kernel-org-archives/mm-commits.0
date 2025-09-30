Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB78136658;
	Tue, 30 Sep 2025 21:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759269594; cv=none; b=q5fnkycMnimL0lYFBy1wPJbfGC3Ar9rMyGQvK/S4D+ym0tLzqDFg7fElQHyVUN4ExJKBITwmC33dzRs09dBLgiTdXx1+1YmJ+LZOqNwI9AGqym9b5+EkTgkECkqk53Y0uce7T9dK6KHbkUgvNLxsogZMKbT6tNxBZnSL3PbHeqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759269594; c=relaxed/simple;
	bh=kgDYbTQOzHkBO7O974DWE+h+U0Jm/XMCx7/0Ma2DD9s=;
	h=Date:To:From:Subject:Message-Id; b=tn7Y0WBBXJ+tSe2/77Vv+vb8bQI/CY9JKHK8a2CXZ4A4ozYvgwl5J6x2N66LC2d6SFXABDNxVRrHhqJLc9DLwruMkAOlshS8G/uw1WT4L7+Fu9kCeL0MQ/RwnPyStz11EBCfIMf7tR52OjcOFpwazcenSC5j3BZSMrXYbIukP/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HYtPxRyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HYtPxRyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEF2C4CEF0;
	Tue, 30 Sep 2025 21:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759269593;
	bh=kgDYbTQOzHkBO7O974DWE+h+U0Jm/XMCx7/0Ma2DD9s=;
	h=Date:To:From:Subject:From;
	b=HYtPxRyQvBMLuBDwemZIszz8FSS/jfIN4SNOFLsFu+FuTXQzk0VuvaBa+HUMynrWl
	 +QpJpG9bfhY2BkFDMn6PDy1x0krHXs+hV1lPAxz6L2ig5INTfqnkfajdrORJO86F9Y
	 YbV5sntC/0uHbFBBJiKxp0yVHPx9XSdne9dK23Vw=
Date: Tue, 30 Sep 2025 14:59:52 -0700
To: mm-commits@vger.kernel.org,zhengxinyu6@huawei.com,stable@vger.kernel.org,hughd@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success.patch added to mm-hotfixes-unstable branch
Message-Id: <20250930215953.0CEF2C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: do not repeat pte_offset_map_lock() until success
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: do not repeat pte_offset_map_lock() until success
Date: Mon, 29 Sep 2025 17:44:09 -0700

DAMON's virtual address space operation set implementation (vaddr) calls
pte_offset_map_lock() inside the page table walk callback function.  This
is for reading and writing page table accessed bits.  If
pte_offset_map_lock() fails, it retries by returning the page table walk
callback function with ACTION_AGAIN.

pte_offset_map_lock() can continuously fail if the target is a pmd
migration entry, though.  Hence it could cause an infinite page table walk
if the migration cannot be done until the page table walk is finished. 
This indeed caused a soft lockup when CPU hotplugging and DAMON were
running in parallel.

Avoid the infinite loop by simply not retrying the page table walk.  DAMON
is promising only a best-effort accuracy, so missing access to such pages
is no problem.

Link: https://lkml.kernel.org/r/20250930004410.55228-1-sj@kernel.org
Fixes: 7780d04046a2 ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Xinyu Zheng <zhengxinyu6@huawei.com>
Closes: https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success
+++ a/mm/damon/vaddr.c
@@ -328,10 +328,8 @@ static int damon_mkold_pmd_entry(pmd_t *
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	if (!pte_present(ptep_get(pte)))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -481,10 +479,8 @@ regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success.patch


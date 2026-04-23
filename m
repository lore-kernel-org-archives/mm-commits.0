Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B53DFC63
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 12:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776946947; cv=none; b=gjw9hp9Tfg2R5qu5yBSRqDa7EfPDIeoZMHHYMycChLxHuv0e1lx2e4nwGFB/ciYiL1iXYFeb4kxGjItUinK7mfr66eyJmKzAz6CXAongzXJ6DULiP6qvCh45RcFZ9WRioDC3JehiMgTOzhvFnndF3FRYjh+nsuPAB1MCZb1TVcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776946947; c=relaxed/simple;
	bh=ZO4ftbrq0XThIZxCKAo8/++QXiE4KIKwR4ZYVQIR5jI=;
	h=Date:To:From:Subject:Message-Id; b=iJEszhjY0G1eO4rJqBQ7Zd0t/Zd4uCEoAskQmz1ST8zlLW53CyUO64w/o5hD09qgcGSpTwcVb7JUP6DedO+uILxJJjs+XAz+bWfr3iEHGBt6qOLlZ9Oy6YD7+FLSi+Fc/CiXO4WZA5HF8raEfvG3BjvBnLqqLp+l9yD+rW0U1ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ztZs8LlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ztZs8LlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86930C2BCAF;
	Thu, 23 Apr 2026 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776946947;
	bh=ZO4ftbrq0XThIZxCKAo8/++QXiE4KIKwR4ZYVQIR5jI=;
	h=Date:To:From:Subject:From;
	b=ztZs8LlWWWsJ8ZSBITumtXTNkZCpEZAY054iPvP9Fmx2cFh+SmyXiL8Db82Eb8dI0
	 kOUvekHYB4bbOA6A6NlryhMxMvY3d9hb++mZTem1KGfkNhrVMLWY6zoophPXmhxhwB
	 oEjdYGuIKMmyIIM3fcfRlwwg70jiVrU/8zBToKW4=
Date: Thu, 23 Apr 2026 05:22:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch added to mm-new branch
Message-Id: <20260423122227.86930C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: Fix outdated comment about freeing subpages in __folio_split
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/huge_memory: Fix outdated comment about freeing subpages in __folio_split
Date: Thu, 23 Apr 2026 11:49:17 +0800

The comment appears to be outdated.  First, add_to_swap() no longer exists
after Kairui's commit b487a2da3575 ("mm, swap: simplify folio swap
allocation").  Second, partially zapped folios are now always split before
folio_alloc_swap() to avoid extra I/O, following Ryan's commit
5ed890ce5147 ("mm: vmscan: avoid split during shrink_folio_list()").  Fix
this by making the description more generic.

Link: https://lore.kernel.org/20260423034917.8234-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split
+++ a/mm/huge_memory.c
@@ -4190,11 +4190,10 @@ fail:
 
 		folio_unlock(new_folio);
 		/*
-		 * Subpages may be freed if there wasn't any mapping
-		 * like if add_to_swap() is running on a lru page that
-		 * had its mapping zapped. And freeing these pages
-		 * requires taking the lru_lock so we do the put_page
-		 * of the tail pages after the split is complete.
+		 * Subpages whose mapping has been zapped may be freed
+		 * earlier, but freeing them requires taking the
+		 * lru_lock, so we defer put_page() on tail pages until
+		 * after the split completes.
 		 */
 		free_folio_and_swap_cache(new_folio);
 	}
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch


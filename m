Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276EA42883A;
	Wed,  4 Feb 2026 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770234262; cv=none; b=igfwf9Q7FOwfKUdLbrRhkV8cncdJeOKkymkyhoCvlBfSsAZaA4ebkznUSBSqH57bEVgGp2sxedgSxvcUqkrPW4tE3adw5eHyQHy5G1WW8GJIJsztABZbyoNqHFbs+shE0nvj7mea+p46n6ZMnCkpRfXbDmq1Sxkjv06bP0J3Z30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770234262; c=relaxed/simple;
	bh=LZTc3xq3e58wt6zj6jFatblAyz9oaqu6MffeleKA4zU=;
	h=Date:To:From:Subject:Message-Id; b=RUFhw0i2fVIUC2W1GYzRitzY4Aq0tRe7+llWtQBddYvwLH3DsqNQzv2tzPI4SQPx7e8nUB2R7tmJ8BYe/Uy+YDXOXcQ2+E7xdh3RHXTY0EU/WmVUoIN6jUnjjmnbJzJbD0yYBLOkjTC2lkvZ2Dm29v3K26IaJsywf1LP8kG9Mas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDUuu9jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDUuu9jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F6FC19423;
	Wed,  4 Feb 2026 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770234261;
	bh=LZTc3xq3e58wt6zj6jFatblAyz9oaqu6MffeleKA4zU=;
	h=Date:To:From:Subject:From;
	b=LDUuu9jt7uew/8i/FxfufTKq1U9sCmc7bMFCQeCQjKTK1xFKCzGmVbEtP657WgJOq
	 JfxZ0Uyg7NowgDnnmG0TuGIJjV6bzZKhGYrsozNAknwrjuqYCz8yg7zEp5DrHEDgz5
	 PxZJE347+pKoI7arU6/Xzjlh9knIUGzCzcay3AOQ=
Date: Wed, 04 Feb 2026 11:44:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,harry.yoo@oracle.com,gavinguo@igalia.com,david@kernel.org,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp.patch added to mm-new branch
Message-Id: <20260204194421.D7F6FC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
Date: Wed, 4 Feb 2026 00:42:19 +0000

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked() which may fail early during try_to_migrate() for
shared thp.  This will lead to unexpected folio split failure.

One way to reproduce:

    Create an anonymous thp range and fork 512 children, so we have a
    thp shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
    order 0.

Without the above commit, we can successfully split to order 0.  With the
above commit, the folio is still a large folio.

The reason is the above commit return false after split pmd
unconditionally in the first process and break try_to_migrate().

The tricky thing in above reproduce method is current debugfs interface
leverage function split_huge_pages_pid(), which will iterate the whole pmd
range and do folio split on each base page address.  This means it will
try 512 times, and each time split one pmd from pmd mapped to pte mapped
thp.  If there are less than 512 shared mapped process, the folio is still
split successfully at last.  But in real world, we usually try it for
once.

This patch fixes this by restart page_vma_mapped_walk() after
split_huge_pmd_locked().  Because split_huge_pmd_locked() may fall back to
(freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
just split instead of split to migration entry.  Restart
page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE again
and fail try_to_migrate() early if it fails.

Link: https://lkml.kernel.org/r/20260204004219.6524-1-richard.weiyang@gmail.com
Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Gavin Guo <gavinguo@igalia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp
+++ a/mm/rmap.c
@@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct fo
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * After split_huge_pmd_locked(), restart the
+				 * walk to detect PageAnonExclusive handling
+				 * failure in __split_huge_pmd_locked().
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-fix-early-failure-try_to_migrate-when-split-huge-pmd-for-shared-thp.patch


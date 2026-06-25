Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561EC8CE
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782355181; cv=none; b=ELD3B9PwVA/yCvmZGWSMKhcuahABUZ71ecq7f51DfkJmKh8xJHApPwa3umhYu7CVq+yYu5bIU5n/YzhJnyZTOuz3glR/nBW9/WRQvh9D3GH2wLZstlB0evRblAAbI6/tzCjvWUnI65upPTkrwynANul+MdnHl2RsHztk3+qysFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782355181; c=relaxed/simple;
	bh=mLSl27pciISlm1jlCa0JBpoIhZHR2TXdNFJwKrwGggw=;
	h=Date:To:From:Subject:Message-Id; b=BySqH3SzTDwSschSYqeQmVGeblPtANYQeTwpwq3UIPhRUyZ1gkzcZoPXSuYl57297bhjwSVSor0IRfNrFbV6T1rkfGYdGXanKz4phBANC7iFVqCgAMVBHClxk5WjFGf9WPjSiwtcm5xYJLsH07Lz30J1c+V4skMTgvceR3p1c5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UUOu08AL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UUOu08AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E01F000E9;
	Thu, 25 Jun 2026 02:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782355179;
	bh=zhv6ufpZur3OISTH8XUQwW7yuu3W8wI6YeA6ixLf4/s=;
	h=Date:To:From:Subject;
	b=UUOu08AL7CTY+JgIUGTQJAFol2HopwJfkM0Azuy0xdFuztcgfTWj003L5gMPOrIk5
	 MV1YLnNnUza3LjUgl//OwAdC8ZFcFNApiBRZ2vDNgrU7d3hLqqsSrpB63udenoDbXl
	 4c3TtOB6eDbtbIE9p7iaTesMK/EZhd1ga/c/Wujo=
Date: Wed, 24 Jun 2026 19:39:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-use-walk_page_range_vma-in-do_mincore.patch added to mm-new branch
Message-Id: <20260625023939.BB4E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: use walk_page_range_vma() in do_mincore()
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-use-walk_page_range_vma-in-do_mincore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-use-walk_page_range_vma-in-do_mincore.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: use walk_page_range_vma() in do_mincore()
Date: Thu, 18 Jun 2026 17:28:42 +0800

Patch series "mm: convert to walk_page_range_vma() to eliminate
find_vma()", v2.

walk_page_range() performs a find_vma() lookup on each page table walk. 
For callers that already hold a valid VMA and operate on a known
single-VMA range, this lookup is redundant.  Replace walk_page_range()
with walk_page_range_vma() where the caller guarantees single-VMA
semantics.


This patch (of 4):

do_mincore() uses walk_page_range() to walk the page table.  Fortunately,
the caller always passes start/end that falls within a single VMA, so it's
safe to use the walk_page_range_vma() in do_mincore() to eliminate an
unnecessary find_vma() lookup.

Unlike walk_page_range(), walk_page_range_vma() does not call
walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole() to skip
the page table walk.  Without this check, PFNMAP PTEs would be treated as
present by mincore_pte_range(), changing the returned residency status. 
Handle VM_PFNMAP explicitly in do_mincore() to preserve the original
behavior.

Link: https://lore.kernel.org/20260618092845.3905740-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260618092845.3905740-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore
+++ a/mm/mincore.c
@@ -259,7 +259,21 @@ static long do_mincore(unsigned long add
 		memset(vec, 1, pages);
 		return pages;
 	}
-	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
+
+	/*
+	 * walk_page_range_vma() does not call walk_page_test(), which
+	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
+	 * page table walk. Without this check, PFNMAP PTEs would be
+	 * treated as present by mincore_pte_range(), changing the returned
+	 * residency status from the historical "not resident" to "resident".
+	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
+	 */
+	if (vma->vm_flags & VM_PFNMAP) {
+		__mincore_unmapped_range(addr, end, vma, vec);
+		return (end - addr) >> PAGE_SHIFT;
+	}
+
+	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
 	if (err < 0)
 		return err;
 	return (end - addr) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch


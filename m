Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5151D8C08;
	Wed, 24 Jan 2024 10:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091443; cv=none; b=DK7kfCRyG+2Lm6F6gxvvXgakuE3VvTdJLF/kI0d9CRnYcBkUFuAvK8hUeJd8LobWpyvH+aJokSVe9khUGtAnQbsMwiCItVprsNRvpHz+B3SPn/ZXIZouj2R5CEf5c5t1XSJYsHvw4194rc3GrSbe+qzn+4fhetXFpGiu6d2oCVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091443; c=relaxed/simple;
	bh=MkRZL+onapfWfiA85X8Y+/SuY23Gz1+sEamhiSi5eiY=;
	h=Date:To:From:Subject:Message-Id; b=idEKSiVbFWi7huUWZWPnYdGGTHTIQ0O7Cek5tOAYLKDiWQaQiKKVZcIKXOal5CugHdygw9NZbGLz+18yEIjTEOT99pTSeTrzcHZNWXuxVxGRxUl/uzZfwz5/z/yz7SZzlxutR7xwZ6WDln3VzNodwgZxf+ucdbJbGzE3A/y01Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y2/3nBZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y2/3nBZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C243C433F1;
	Wed, 24 Jan 2024 10:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091443;
	bh=MkRZL+onapfWfiA85X8Y+/SuY23Gz1+sEamhiSi5eiY=;
	h=Date:To:From:Subject:From;
	b=y2/3nBZNlw9Nk1Q3jZ57nmrKnfGFAhbtp0//SKDZhcdps2g2+i9pVISl7T1Dp4fuE
	 507IUz9ZQR80ZKOUKswyU7sfPfdDQ7KZACfzEtsgyvRSVxBi/SiPBeGRYpU5+LgsVq
	 IIVr9pFlIZbRkLWjUs+aJLGdIV8LbwwB6YmPB3n8=
Date: Wed, 24 Jan 2024 02:17:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,shy828301@gmail.com,riel@surriel.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp_get_unmapped_area-must-honour-topdown-preference.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101722.8C243C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp_get_unmapped_area must honour topdown preference
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-thp_get_unmapped_area-must-honour-topdown-preference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp_get_unmapped_area-must-honour-topdown-preference.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp_get_unmapped_area must honour topdown preference
Date: Tue, 23 Jan 2024 17:14:20 +0000

The addition of commit efa7df3e3bb5 ("mm: align larger anonymous mappings
on THP boundaries") caused the "virtual_address_range" mm selftest to
start failing on arm64.  Let's fix that regression.

There were 2 visible problems when running the test; 1) it takes much
longer to execute, and 2) the test fails.  Both are related:

The (first part of the) test allocates as many 1GB anonymous blocks as it
can in the low 256TB of address space, passing NULL as the addr hint to
mmap.  Before the faulty patch, all allocations were abutted and contained
in a single, merged VMA.  However, after this patch, each allocation is in
its own VMA, and there is a 2M gap between each VMA.  This causes the 2
problems in the test: 1) mmap becomes MUCH slower because there are so
many VMAs to check to find a new 1G gap.  2) mmap fails once it hits the
VMA limit (/proc/sys/vm/max_map_count).  Hitting this limit then causes a
subsequent calloc() to fail, which causes the test to fail.

The problem is that arm64 (unlike x86) selects
ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT.  But __thp_get_unmapped_area()
allocates len+2M then always aligns to the bottom of the discovered gap. 
That causes the 2M hole.

Fix this by detecting cases where we can still achive the alignment goal
when moved to the top of the allocated area, if configured to prefer
top-down allocation.

While we are at it, fix thp_get_unmapped_area's use of pgoff, which should
always be zero for anonymous mappings.  Prior to the faulty change, while
it was possible for user space to pass in pgoff!=0, the old
mm->get_unmapped_area() handler would not use it.  thp_get_unmapped_area()
does use it, so let's explicitly zero it before calling the handler.  This
should also be the correct behavior for arches that define their own
get_unmapped_area() handler.

Link: https://lkml.kernel.org/r/20240123171420.3970220-1-ryan.roberts@arm.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Closes: https://lore.kernel.org/linux-mm/1e8f5ac7-54ce-433a-ae53-81522b2320e1@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++++++--
 mm/mmap.c        |    6 ++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-thp_get_unmapped_area-must-honour-topdown-preference
+++ a/mm/huge_memory.c
@@ -810,7 +810,7 @@ static unsigned long __thp_get_unmapped_
 {
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
-	unsigned long len_pad, ret;
+	unsigned long len_pad, ret, off_sub;
 
 	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
 		return 0;
@@ -839,7 +839,13 @@ static unsigned long __thp_get_unmapped_
 	if (ret == addr)
 		return addr;
 
-	ret += (off - ret) & (size - 1);
+	off_sub = (off - ret) & (size - 1);
+
+	if (current->mm->get_unmapped_area == arch_get_unmapped_area_topdown &&
+	    !off_sub)
+		return ret + size;
+
+	ret += off_sub;
 	return ret;
 }
 
--- a/mm/mmap.c~mm-thp_get_unmapped_area-must-honour-topdown-preference
+++ a/mm/mmap.c
@@ -1825,15 +1825,17 @@ get_unmapped_area(struct file *file, uns
 		/*
 		 * mmap_region() will call shmem_zero_setup() to create a file,
 		 * so use shmem's get_unmapped_area in case it can be huge.
-		 * do_mmap() will clear pgoff, so match alignment.
 		 */
-		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		get_area = thp_get_unmapped_area;
 	}
 
+	/* Always treat pgoff as zero for anonymous memory. */
+	if (!file)
+		pgoff = 0;
+
 	addr = get_area(file, addr, len, pgoff, flags);
 	if (IS_ERR_VALUE(addr))
 		return addr;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch
mm-thp_get_unmapped_area-must-honour-topdown-preference.patch
tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch


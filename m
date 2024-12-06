Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EEC193075;
	Fri,  6 Dec 2024 03:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457333; cv=none; b=b2ESY0dFQXnMk72VgAfsisFE7g7+w5HbQXKqf7RyYOV8boSPp80bXFV2HOXZhxE5NaAyRylI49dU200UhZfm8CsVQsLGussyPrnDhmP4Q8PUN/eBiSTQnjATxzF3tEbVGCKZb1dF3I48id5TH3yxq9sX7i1WVquo7KFs8OWCaDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457333; c=relaxed/simple;
	bh=vIhRtk4t41Gm9JfqDgVqcg0CQQe1pkjQgemXL9y3yrE=;
	h=Date:To:From:Subject:Message-Id; b=hnEnBdNJQhNXJZnH9+KOTTSBVAVks7hbvbWczTlm9NaYejVn+jh8E8+MUwU+6SUe8XVNpeL6dJyKH6ddJpkf38veFaORDyX1limsgMD3ReCn0I7itow65qpGJassuNdnnxpJmLviICyA3JZ6c8VVDtIGQMA/O1NT2W2cTCkqWVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJEYGpoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJEYGpoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A853AC4CED1;
	Fri,  6 Dec 2024 03:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457332;
	bh=vIhRtk4t41Gm9JfqDgVqcg0CQQe1pkjQgemXL9y3yrE=;
	h=Date:To:From:Subject:From;
	b=wJEYGpoATMkfaPcR3LY9j1bQdU1yZ0T4w7HdUHjI+ma+SK9OzCYwqpeAWXqrIb3um
	 fNDEcFORSnSyMigufwAWAGWojPiE1JT6vXCKF9gTRJLZaZLiB7fuRoInby7rriUopD
	 7ObaHv5bv+I2dQ65it8IP+wqJfpO0CrOUpEz439k=
Date: Thu, 05 Dec 2024 19:55:32 -0800
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,minchan@kernel.org,lokeshgidra@google.com,hboehm@google.com,david@redhat.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-respect-mmap-hint-address-when-aligning-for-thp.patch removed from -mm tree
Message-Id: <20241206035532.A853AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: respect mmap hint address when aligning for THP
has been removed from the -mm tree.  Its filename was
     mm-respect-mmap-hint-address-when-aligning-for-thp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: respect mmap hint address when aligning for THP
Date: Mon, 18 Nov 2024 13:46:48 -0800

Commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") updated __get_unmapped_area() to align the start address for
the VMA to a PMD boundary if CONFIG_TRANSPARENT_HUGEPAGE=y.

It does this by effectively looking up a region that is of size,
request_size + PMD_SIZE, and aligning up the start to a PMD boundary.

Commit 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on
32 bit") opted out of this for 32bit due to regressions in mmap base
randomization.

Commit d4148aeab412 ("mm, mmap: limit THP alignment of anonymous mappings
to PMD-aligned sizes") restricted this to only mmap sizes that are
multiples of the PMD_SIZE due to reported regressions in some performance
benchmarks -- which seemed mostly due to the reduced spatial locality of
related mappings due to the forced PMD-alignment.

Another unintended side effect has emerged: When a user specifies an mmap
hint address, the THP alignment logic modifies the behavior, potentially
ignoring the hint even if a sufficiently large gap exists at the requested
hint location.

Example Scenario:

Consider the following simplified virtual address (VA) space:

    ...

    0x200000-0x400000 --- VMA A
    0x400000-0x600000 --- Hole
    0x600000-0x800000 --- VMA B

    ...

A call to mmap() with hint=0x400000 and len=0x200000 behaves differently:

  - Before THP alignment: The requested region (size 0x200000) fits into
    the gap at 0x400000, so the hint is respected.

  - After alignment: The logic searches for a region of size
    0x400000 (len + PMD_SIZE) starting at 0x400000.
    This search fails due to the mapping at 0x600000 (VMA B), and the hint
    is ignored, falling back to arch_get_unmapped_area[_topdown]().

In general the hint is effectively ignored, if there is any existing
mapping in the below range:

     [mmap_hint + mmap_size, mmap_hint + mmap_size + PMD_SIZE)

This changes the semantics of mmap hint; from ""Respect the hint if a
sufficiently large gap exists at the requested location" to "Respect the
hint only if an additional PMD-sized gap exists beyond the requested
size".

This has performance implications for allocators that allocate their heap
using mmap but try to keep it "as contiguous as possible" by using the end
of the exisiting heap as the address hint.  With the new behavior it's
more likely to get a much less contiguous heap, adding extra fragmentation
and performance overhead.

To restore the expected behavior; don't use
thp_get_unmapped_area_vmflags() when the user provided a hint address, for
anonymous mappings.

Note: As Yang Shi pointed out: the issue still remains for filesystems
which are using thp_get_unmapped_area() for their get_unmapped_area() op. 
It is unclear what worklaods will regress for if we ignore THP alignment
when the hint address is provided for such file backed mappings -- so this
fix will be handled separately.

Link: https://lkml.kernel.org/r/20241118214650.3667577-1-kaleshsingh@google.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hans Boehm <hboehm@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-respect-mmap-hint-address-when-aligning-for-thp
+++ a/mm/mmap.c
@@ -889,6 +889,7 @@ __get_unmapped_area(struct file *file, u
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
+		   && !addr /* no hint */
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
_

Patches currently in -mm which might be from kaleshsingh@google.com are



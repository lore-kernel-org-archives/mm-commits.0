Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1766922577C
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2025 22:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755211703; cv=none; b=BR8JMeAo86UDMi8bkFFBkGYwL1T80REjQDFvHff/AYlKGOE1baugzEAqpGG2JdwmydEkHU2kpuVHn0aFtTTZCvaTAJeSSEubHtST0szMqhYRGPkUL+9CWcnPyd67ROXypw9Vtdvk8i4GiTztuq/Brc+0mWwmM1rwDSE90DWlm6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755211703; c=relaxed/simple;
	bh=ExmhIIRM3pGx5IYYTYBddquEhxhDZBbQE7MhSiJGeaM=;
	h=Date:To:From:Subject:Message-Id; b=J/XqgSDaaH4bKvnp4HzfNO/+PHXOA9pLIvtNzExE1xyyDkEQ5D6qH8JO1L8Est+LgY3k+zs6grA0F5a4OuS40uXAmntlkPTVQBO/AZ4/E6v5UHZ5nDiyrbGEHoqMvlg4s0rBoeK/k5LW8fdaJC650b7DBZgs3NvBUJMazvl7e5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KmxkpVGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KmxkpVGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C14DC4CEED;
	Thu, 14 Aug 2025 22:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755211702;
	bh=ExmhIIRM3pGx5IYYTYBddquEhxhDZBbQE7MhSiJGeaM=;
	h=Date:To:From:Subject:From;
	b=KmxkpVGLV6LTX8L4AOIT7beXbXwRCg7Dly7bbqaWFpTXdRkKPh+6B4vyTwwY6UTJM
	 yoFHcSSpPdKiVqOIyWGOyjHWpLXhLhvP6vFJR8TTR4lihTCdb6p6Rd+tz/YEFhU5WA
	 MX9ZQOhKxR9i4SvJW9j9LZtSohOEzNcG1dhUdDyE=
Date: Thu, 14 Aug 2025 15:48:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,thierry.reding@gmail.com,surenb@google.com,neilb@suse.de,mhocko@suse.com,mgorman@techsingularity.net,koike@igalia.com,jackmanb@google.com,hannes@cmpxchg.org,cascardo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations.patch added to mm-new branch
Message-Id: <20250814224822.7C14DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations
Date: Thu, 14 Aug 2025 14:22:45 -0300

Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
which implies ALLOC_MIN_RESERVE, is going to be used instead of
__GFP_ATOMIC for high atomic reserves.

Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
allocations of order higher than 0.  It still used __GFP_ATOMIC, though.

Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how
__GFP_HIGH non-blocking allocations accesses reserves") just turned that
check for !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were
expected to test for __GFP_HIGH.

This leads to high atomic reserves being added for high-order GFP_NOWAIT
allocations and others that clear __GFP_DIRECT_RECLAIM, which is
unexpected.  Later, those reserves lead to 0-order allocations going to
the slow path and starting reclaim.

From /proc/pagetypeinfo, without the patch:

Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone    DMA32, type   HighAtomic      1      8     10      9      7      3      0      0      0      0      0
Node    0, zone   Normal, type   HighAtomic     64     20     12      5      0      0      0      0      0      0      0

With the patch:

Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone    DMA32, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0

Link: https://lkml.kernel.org/r/20250814172245.1259625-1-cascardo@igalia.com
Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Tested-by: Helen Koike <koike@igalia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations
+++ a/mm/page_alloc.c
@@ -4408,7 +4408,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			alloc_flags |= ALLOC_NON_BLOCK;
 
-			if (order > 0)
+			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
 				alloc_flags |= ALLOC_HIGHATOMIC;
 		}
 
_

Patches currently in -mm which might be from cascardo@igalia.com are

mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations.patch


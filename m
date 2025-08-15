Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A15DBA3F
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755218959; cv=none; b=XJoiwiw34sr/OYWHe1cpqCAPWsWKRHC/jNure8tnIta6ry4YFBl9iC1dMfix30B6LAOFfIVcXpS0m8hSYzWq7ETHImaZNS9AcQ6QhW5NjeRpUKnUOS3MDUhUzEvnLafu/5cAZj9dtgx5qeOoZSAEsKWGMs3IhMFFiaHLjnR8XkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755218959; c=relaxed/simple;
	bh=6Z0tCQ5I8rKJtB8IdiUMHSv7vqOGo2rzXjQJ+16zkN8=;
	h=Date:To:From:Subject:Message-Id; b=G7IIYlB28liCqZF5sOVxi8nYbZE4g56w9tFPQVaWKkX6BoJqaON+BYbgkTsFsHk+PlEJoJOZzsXGmRolE/73+8DtSs4bYL+CV9GQ+kdDW//viy64X2ADs/GPeWLhsPcw3Lq8aBvKZLfF/Ls/7tF09p1KpylSDWR1LddTKEOEPE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0YulZV/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0YulZV/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FD7C4CEED;
	Fri, 15 Aug 2025 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755218957;
	bh=6Z0tCQ5I8rKJtB8IdiUMHSv7vqOGo2rzXjQJ+16zkN8=;
	h=Date:To:From:Subject:From;
	b=0YulZV/Zkzxluc0u9NXcorcr4T0+QKRXIbA0Ymhh+cSHU5gY+jlrCNEejU83HgRm0
	 r6kz+NMMalGPx1GtKmAMoOuXzhW/oz3S1/xIy3+m9A7yuhQUC95EOalks2KMS4mdwT
	 8nAd6mHbGetnddwIddIo2GR6hCi8faHEQU1CgyCs=
Date: Thu, 14 Aug 2025 17:49:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch added to mm-new branch
Message-Id: <20250815004917.03FD7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: simplify lowmem_reserve max calculation
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_alloc: simplify lowmem_reserve max calculation
Date: Thu, 14 Aug 2025 17:00:52 +0800

Use max() macro to simplify the calculation of maximum lowmem_reserve
value in calculate_totalreserve_pages(), instead of open-coding the
comparison.  The functionality remains identical.

Link: https://lkml.kernel.org/r/20250814090053.22241-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-lowmem_reserve-max-calculation
+++ a/mm/page_alloc.c
@@ -6237,8 +6237,7 @@ static void calculate_totalreserve_pages
 
 			/* Find valid and maximum lowmem_reserve in the zone */
 			for (j = i; j < MAX_NR_ZONES; j++) {
-				if (zone->lowmem_reserve[j] > max)
-					max = zone->lowmem_reserve[j];
+				max = max(max, zone->lowmem_reserve[j]);
 			}
 
 			/* we treat the high watermark as reserved pages. */
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch
mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch


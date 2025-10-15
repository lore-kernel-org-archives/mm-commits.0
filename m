Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63E2C187
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760562283; cv=none; b=AmSVhexLJfLrYSOKo4ZlUW/zFPk0gZQKW0aYpd/kXGuKg3zoC1h+s1RUpktr/qojA007hlWI4V9gb4gq8l9pdeaqCTUjkkHVU8w8eAIFuDbk8fEIvo5UU8xDkdAWNE/DOtERs5Wu7hnYxfEvMOwt/pYZSRpDPCwnr8umoH37ZMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760562283; c=relaxed/simple;
	bh=EenETr63XkU8Vil5y5BaLM0VM6gtzn3eS1OOlOOyPjE=;
	h=Date:To:From:Subject:Message-Id; b=HcNpSMrh1jvbVWrq8gXfL/m9wxkU2CpL5z06gxcHDfPM45cmsBCBYhMpOW37sXq5rbpsOImJ8xl8DBK/xcGViqwxosSKFE7cH6IY6bdn4ddRnfUtIY7kUkRPf0RQSIT3joMR6JWTV9kWHqPjmsmNhez0mlYfbeS+zjzjkr2ilrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlhsDqD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlhsDqD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1A9C4CEF8;
	Wed, 15 Oct 2025 21:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760562282;
	bh=EenETr63XkU8Vil5y5BaLM0VM6gtzn3eS1OOlOOyPjE=;
	h=Date:To:From:Subject:From;
	b=LlhsDqD/R5CJ6wgvCfW0pF+e+ArG+wNTEjDqpjNnGiKFGJlrV7zFyiY2mftnqAyrG
	 /4dRAbpc7UeRg0p38sjR0Go9Gbs3AZoXp9eh94xQsFNGBsT7ATV9oty9dArAJUGess
	 NdkpfaPt6A67WMOH5Eq/tRYDZQ40B3i2c0boJQ9A=
Date: Wed, 15 Oct 2025 14:04:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug.patch added to mm-new branch
Message-Id: <20251015210442.8A1A9C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: clarify FIXME around shrink_slab() in memory hotplug
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug.patch

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
From: Manish Kumar <manish1588@gmail.com>
Subject: mm/page_isolation: clarify FIXME around shrink_slab() in memory hotplug
Date: Wed, 15 Oct 2025 23:20:41 +0530

The existing FIXME comment notes that memory hotplug doesn't invoke
shrink_slab() directly.  This patch adds context explaining that this is
an intentional design choice to avoid recursion or deadlocks in the memory
reclaim path, as slab shrinking is handled by vmscan.

Link: https://lkml.kernel.org/r/20251015175041.40408-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug
+++ a/mm/page_isolation.c
@@ -176,10 +176,16 @@ static int set_migratetype_isolate(struc
 
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
+	 *
+	 * This is an intentional limitation: invoking shrink_slab() from a
+	 * hotplug path can cause reclaim recursion or deadlock if the normal
+	 * memory reclaim (vmscan) path is already active. Slab shrinking is
+	 * handled by the vmscan reclaim code under normal operation, so hotplug
+	 * avoids direct calls into shrink_slab() to prevent reentrancy issues.
+	 *
+	 * We therefore only check MOVABLE pages here.
 	 *
 	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
 	 */
 	check_unmovable_start = max(page_to_pfn(page), start_pfn);
 	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
_

Patches currently in -mm which might be from manish1588@gmail.com are

mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug.patch


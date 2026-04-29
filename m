Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DE93803DD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477080; cv=none; b=gSlzhmztiIINen4PRPqWLVQVYGh2wskCso285Iwd+335r7O9AF5ipJLu4c8LDt8CMhS04QjWDxTi3UJOjeCQt3czKsBBr9MMb68HKK/vHWeNVzERPqzE4I3W8Td3eGaweZC422/o5VjwifjHKc4o+winlbap/AMPqMqubSFkJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477080; c=relaxed/simple;
	bh=oRrC4CtbPimv6VL86Uu7Cl2PKQmRagXhR5Dbot91Acc=;
	h=Date:To:From:Subject:Message-Id; b=Opv45qNQdZI5zohTgy901vkYT3eOrmZbCaynIblQs9WFlXfpEt05RAaINSVmx6EGwbX0Ds6d84/hjCCrhZ5ZGOHR2CARKZfRsO5aEEgf7bg/eLN5/6Bb246knbIl7rUo94dUMBiH5jr59VmnFTLrSfmNLwS1OnEvg0gKml37LFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TTSWsX7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TTSWsX7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE99C19425;
	Wed, 29 Apr 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477080;
	bh=oRrC4CtbPimv6VL86Uu7Cl2PKQmRagXhR5Dbot91Acc=;
	h=Date:To:From:Subject:From;
	b=TTSWsX7jNFlsWkfQ+oLPxiH+vViBfw9LoMeJaNOnQD2vD0GEP5TdPJSXjjcLuvp1Y
	 qb70KJFMvuoRoiK+SnKb0ysPlWOceEN/1j2IdPbKzpL3nDLs+WAobOzV7SDkG+oWe/
	 xXN9lK+F1IYXwzhA9prt1/erG4PMxCkd3Ezf5Eik=
Date: Wed, 29 Apr 2026 08:37:59 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-__offline_isolated_pages.patch added to mm-new branch
Message-Id: <20260429153800.4DE99C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in __offline_isolated_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-__offline_isolated_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-__offline_isolated_pages.patch

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in __offline_isolated_pages()
Date: Wed, 29 Apr 2026 12:02:13 +0000

Use spinlock_irqsave zone lock guard in __offline_isolated_pages() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Link: https://lore.kernel.org/13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-__offline_isolated_pages
+++ a/mm/page_alloc.c
@@ -7521,7 +7521,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7529,7 +7529,7 @@ unsigned long __offline_isolated_pages(u
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7559,7 +7559,6 @@ unsigned long __offline_isolated_pages(u
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch
mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-set_migratetype_isolate.patch
mm-use-zone-lock-guard-in-take_page_off_buddy.patch
mm-use-zone-lock-guard-in-put_page_back_buddy.patch
mm-use-zone-lock-guard-in-free_pcppages_bulk.patch
mm-use-zone-lock-guard-in-__offline_isolated_pages.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B3543B3E0
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622482; cv=none; b=abq4EaGDETRhLCRnB9FK93guFzhCo/xkBOtXzXjFP0jDDqEh6STgD97v3YjbInhrVzY90THbp2sGXQILP478ebZ7gcj6U7L4ulBtNBJMOLb8AOtd3tDsIcdj+DtptCN7Ly8yaKoCP+YeH6FFFTG/6YiCydB0D32X5M/lKN+F4LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622482; c=relaxed/simple;
	bh=JYPIhZ3Rr4bx3pSh9s/ADV90OE8+7VmE6F0d80QWRHM=;
	h=Date:To:From:Subject:Message-Id; b=JnoOCOlgQSSgHa79AOzL1kQwmakhmT/UvgCyAqTVQDVGgVAsWEcsNCBS8sgZVuRA4rYosgHJNxtyLzxqjRSywPtvU7wD8Im7RX0LhAGmpJcJpzXzStJCyHTdFROyC4ZE8BMpybr0BU0Yj5Og6BfUfPhKEFC9FRUo1FxehIJbMBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LCtqgnxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LCtqgnxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422B1F00A3A;
	Thu,  9 Jul 2026 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783622480;
	bh=rKEWKfsX8HDOzhWCURCxKYLwO1CJV8OEPBjEK3fHFNE=;
	h=Date:To:From:Subject;
	b=LCtqgnxEQEr4/+MfUeVaxU1YA9kAkhzQc8TTkFDbg0bsJbtW8xVsgn0tvCN+7TeY0
	 9mO7btFF0m3SZPTRQb3wtzGBMopafGHD/ub9RASNVhcnLfrrE5AF01kNMbMQfhcG0E
	 SCLLVxd1yzCypPNYiHgiv7KDqUOxnRrKVWrrYxQo=
Date: Thu, 09 Jul 2026 11:41:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch added to mm-unstable branch
Message-Id: <20260709184120.B422B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
Date: Thu, 09 Jul 2026 14:06:03 -0400

page->private should not be set in tail pages.  Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed a
DEBUG_VM check without a proper reason[1].  Add it back.

Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-3-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order
+++ a/mm/huge_memory.c
@@ -3591,6 +3591,13 @@ static void __split_folio_to_order(struc
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
+		/*
+		 * page->private should not be set in tail pages. Warn once
+		 * if private is unexpectedly set. Do it before swap.val assignment
+		 * since private overlaps with swap.val.
+		 */
+		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
+
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch


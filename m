Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2786D306B37
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411786; cv=none; b=f+KGv6u8Fpp8AJM7aahT6ixtOWuhpYRR1Wqaa/OhtVuJzZP9Dxnm5VnV4cnQPOUb5lZ432nYHNaUN0xeHcL0JljFinFaeUfBegzA+KJhwig2B9iMuaJ4u25KrOu2NO9D9aVQHbN/XXYH7xHlsEUk0mb8fvEr9VnDW9mU4PxH7nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411786; c=relaxed/simple;
	bh=amQBq9PjUmKjA3Guskeqt29hQFWefseMpr9kUS9ElDY=;
	h=Date:To:From:Subject:Message-Id; b=nsnWqJQFdV1rAtr+4QJt+6D6by0/n8pKGlVug2MoDzLt+ye5GIXCUHl6ACYvJJy1FGT/U9/DIOA+6g2TRVBeyB68TP7BDCyNidFWpbSTO3enobGidQTGYkf9w4lWmvFin8nrGsTeWsGe7Kf1ujUumJ/g1ECSwkK09JBX3kNboYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loJ9ggBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loJ9ggBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D21A1F000E9;
	Thu, 25 Jun 2026 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782411784;
	bh=nIp+GNBiAyeYplDNdYT5Sj3Si5SGzDk8XTgXsibvHjo=;
	h=Date:To:From:Subject;
	b=loJ9ggBr8QoxB8b6WT28Dxnt//4f6jVzQGOzKqmgqkmQoc/U/S1adi8puAYjFYDOe
	 pSFnXwjafEb5stgnWO3Xb8IoA/OKXYSTGmr5MyxXgqTxVObMAIhMWtTL1DRpz1uSbm
	 lJOZONXZp8Or0cic1hV9AY9fmphZD34BVoyWHAVk=
Date: Thu, 25 Jun 2026 11:23:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-pagemap-fix-flags-location-member-name-and-sample-code.patch added to mm-new branch
Message-Id: <20260625182304.8D21A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: pagemap: fix flags location, member name and sample code
has been added to the -mm mm-new branch.  Its filename is
     docs-pagemap-fix-flags-location-member-name-and-sample-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-pagemap-fix-flags-location-member-name-and-sample-code.patch

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
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: docs: pagemap: fix flags location, member name and sample code
Date: Fri, 26 Jun 2026 01:44:47 +0800

The userland visible page flags (KPF_*) were initially moved to
include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
stable page flags"), and later moved to
include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
(Scripted) Disintegrate include/linux").  Update the doc to reflect the
current location of these flags.

The member @walk_end of struct pm_scan_arg {} was wrongly written as
"end_walk".

The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
The second one missed PAGE_IS_FILE in the required mask.

Fix them all together.

Link: https://lore.kernel.org/20260625174447.24292-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~docs-pagemap-fix-flags-location-member-name-and-sample-code
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -67,7 +67,7 @@ number of times a page is mapped.
  * ``/proc/kpageflags``.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
-   The flags are (from ``fs/proc/page.c``, above kpageflags_read):
+   The flags are (from ``include/uapi/linux/kernel-page-flags.h``):
 
     0. LOCKED
     1. ERROR
@@ -264,7 +264,7 @@ The ``struct pm_scan_arg`` is used as th
     provided or not.
  3. The range is specified through ``start`` and ``end``.
  4. The walk can abort before visiting the complete range such as the user buffer
-    can get full etc. The walk ending address is specified in``end_walk``.
+    can get full etc. The walk ending address is specified in ``walk_end``.
  5. The output buffer of ``struct page_region`` array and size is specified in
     ``vec`` and ``vec_len``.
  6. The optional maximum requested pages are specified in the ``max_pages``.
@@ -275,7 +275,7 @@ Find pages which have been written and W
 
    struct pm_scan_arg arg = {
    .size = sizeof(arg),
-   .flags = PM_SCAN_CHECK_WPASYNC | PM_SCAN_CHECK_WPASYNC,
+   .flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
    ..
    .category_mask = PAGE_IS_WRITTEN,
    .return_mask = PAGE_IS_WRITTEN,
@@ -288,7 +288,7 @@ present or huge::
    .size = sizeof(arg),
    .flags = 0,
    ..
-   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED,
+   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE | PAGE_IS_SWAPPED,
    .category_inverted = PAGE_IS_SWAPPED,
    .category_anyof_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
    .return_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED |
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch
docs-pagemap-fix-flags-location-member-name-and-sample-code.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160492500C8
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 01:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733274186; cv=none; b=jHwMhE0ZV1uHgN77FVcZ6wI4eS70tbIT6kcWIzR2NDmxV1rIw1SlHdw4T9jTpQDij1MhZBWkqsUGsbdsdid3Oz6tE0JHm9DlI7zMxP7DHm1uzIVFEQ9CIXYQNSEVP9okCsUPAc1EFh2SS+nUdngGp8JWjwoiwJ9vWVijcLyL9zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733274186; c=relaxed/simple;
	bh=9lNzjMMW2WmUph8pAlCNGRZv9jWutn2UhYuOZyPJFkY=;
	h=Date:To:From:Subject:Message-Id; b=QwhTS8Ilb/GV6tvkv31b8+T3WiGHCt+14fcslshBTdh/P5Ez7yBfbBEAq5NmpF9ZMns8av905nWJQQB1QQ+0Cq/q/d73vq23dahzYOWnilj7DSqTJL4MkPLwabop9kEn3aXc5BRmKdKWOJqIcjOwapD6tIxv7qb+CoKoHk+e0NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+xlNay6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+xlNay6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EBFC4CEDC;
	Wed,  4 Dec 2024 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733274184;
	bh=9lNzjMMW2WmUph8pAlCNGRZv9jWutn2UhYuOZyPJFkY=;
	h=Date:To:From:Subject:From;
	b=G+xlNay6vFsdesskcmoCJ6K4npXCWzniY4nI3dgZ9EcJoDgQ1xBpBoQ8+E0r38mZu
	 kxR/TAniMq1vJlZi44nnTIu2RTA5ne1qWCpXArY05eo56bnKX9syhDcc7LrP24cR9J
	 Rb1Z+9N0YncnMTnMXWUNeL7jwQrSWRf6N1YtzGQ8=
Date: Tue, 03 Dec 2024 17:03:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-__alloc_contig_migrate_range-static.patch added to mm-unstable branch
Message-Id: <20241204010304.77EBFC4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: make __alloc_contig_migrate_range() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-__alloc_contig_migrate_range-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-__alloc_contig_migrate_range-static.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: make __alloc_contig_migrate_range() static
Date: Tue, 3 Dec 2024 10:47:29 +0100

The single user is in page_alloc.c.

Link: https://lkml.kernel.org/r/20241203094732.200195-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ----
 mm/page_alloc.c |    5 ++---
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-page_alloc-make-__alloc_contig_migrate_range-static
+++ a/mm/internal.h
@@ -839,10 +839,6 @@ int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
 
-int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end,
-					int migratetype);
-
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void init_cma_reserved_pageblock(struct page *page);
 
--- a/mm/page_alloc.c~mm-page_alloc-make-__alloc_contig_migrate_range-static
+++ a/mm/page_alloc.c
@@ -6278,9 +6278,8 @@ static void alloc_contig_dump_pages(stru
  * @migratetype: using migratetype to filter the type of migration in
  *		trace_mm_alloc_contig_migrate_range_info.
  */
-int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end,
-					int migratetype)
+static int __alloc_contig_migrate_range(struct compact_control *cc,
+		unsigned long start, unsigned long end, int migratetype)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 	unsigned int nr_reclaimed;
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5EA23A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836988; cv=none; b=Ou3xf4+v9NAgq/KmkxpoCGLR9ZAS/Aw12hd7hHQ5u5AfX2UL3fS1C2XRx9iUcYfsAZWNMbN0cdRueKGi1yDKYZcsAc/O/7WthDRZuGBAZawcb9zzXLEQ3vwhzIoLKJau0tjZpoZ0kpPH0KdXDCT1S4peZ78daasv11XP+tUxdFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836988; c=relaxed/simple;
	bh=wQEpPN/oA8JlLk/JhVn9Q4I900FQFRZIuf/A8jaJkko=;
	h=Date:To:From:Subject:Message-Id; b=MehxlP03xnnntLhVVzvqVGXcbeduq9waCuaZyLB/Hi1VewUdrMfNRpgAgj58xH55Iqw3gezBd7X+DFLFD8phWwyAF+0ckCnsHPONhma9zj2NPUARZYA9w+yvXB7NLh4n/8XGbZwTe4Jmg9B3rHIInDZutXGt4bMJCyqupZIRMBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=be345wUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="be345wUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE61C4CEDD;
	Tue, 14 Jan 2025 06:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836988;
	bh=wQEpPN/oA8JlLk/JhVn9Q4I900FQFRZIuf/A8jaJkko=;
	h=Date:To:From:Subject:From;
	b=be345wUT0LSZZ2uFnEQXXnr7mBoTLK09yu34TrLnzch2zeFdUvCfH3urLrySg1bci
	 YfQVadVW84ZbdiW4Tt4pIKs1hHqbYUS3rOCn5wyo21x+d1Pv2Rlb5sE7QdY3QcW4GJ
	 HMfoCbR71tbPyf6w9eSpY6/r9X5P3ZZOUsZw1+8Y=
Date: Mon, 13 Jan 2025 22:43:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch removed from -mm tree
Message-Id: <20250114064308.5EE61C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: forward the gfp flags from alloc_contig_range() to post_alloc_hook()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: forward the gfp flags from alloc_contig_range() to post_alloc_hook()
Date: Tue, 3 Dec 2024 10:47:31 +0100

In the __GFP_COMP case, we already pass the gfp_flags to
prep_new_page()->post_alloc_hook().  However, in the !__GFP_COMP case, we
essentially pass only hardcoded __GFP_MOVABLE to post_alloc_hook(),
preventing some action modifiers from being effective..

Let's pass our now properly adjusted gfp flags there as well.

This way, we can now support __GFP_ZERO for alloc_contig_*().

As a side effect, we now also support __GFP_SKIP_ZERO and__GFP_ZEROTAGS;
but we'll keep the more special stuff (KASAN, NOLOCKDEP) disabled for now.

It's worth noting that with __GFP_ZERO, we might unnecessarily zero pages
when we have to release part of our range using free_contig_range() again.
This can be optimized in the future, if ever required; the caller we'll
be converting (powernv/memtrace) next won't trigger this.

Link: https://lkml.kernel.org/r/20241203094732.200195-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -6360,7 +6360,7 @@ static int __alloc_contig_migrate_range(
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list)
+static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6371,7 +6371,7 @@ static void split_free_pages(struct list
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, __GFP_MOVABLE);
+			post_alloc_hook(page, order, gfp_mask);
 			set_page_refcounted(page);
 			if (!order)
 				continue;
@@ -6389,7 +6389,8 @@ static void split_free_pages(struct list
 static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 {
 	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
+	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
+				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO;
 	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
 	/*
@@ -6537,7 +6538,7 @@ int alloc_contig_range_noprof(unsigned l
 	}
 
 	if (!(gfp_mask & __GFP_COMP)) {
-		split_free_pages(cc.freepages);
+		split_free_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
 		if (start != outer_start)
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch


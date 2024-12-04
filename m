Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3BC33D1
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733274189; cv=none; b=WMLw1jwUowabpKx2xUhXmfK+IfM4aduK67ehbPWOXO1uqJc7FjVHmqd6sPuqmH8RqWIcIanSMfVRu7C+PN+elsOt78DOYYyX6f55hoB1MHmTBwg9o6KvA/wgZ2YwW63gtRVfQTGtC8brdYgGGQML25yQpc1jQ4ELP26jDrJNdB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733274189; c=relaxed/simple;
	bh=PezwhrxSqvztWvMiLFnPS5x3mtuADzJDX68snXuR8ww=;
	h=Date:To:From:Subject:Message-Id; b=KmaTUBo+dnQhsOhKcLB5TCBdbglnJ67zBzuyA35J9ttpG7aOtWv1IltacK0baojrjhF0fdPTyNkfxvXsPWoVf9m4e81/KKOjO7VAR2M4eZ6IE8ExVCPEyDJ0ryild+cp57YKiA5PkaYZQxLWZamcuT5puMvkb/9ax/hPnFP7yXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mAu9DCjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mAu9DCjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6ADC4CEDC;
	Wed,  4 Dec 2024 01:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733274189;
	bh=PezwhrxSqvztWvMiLFnPS5x3mtuADzJDX68snXuR8ww=;
	h=Date:To:From:Subject:From;
	b=mAu9DCjxWNtt3o4VmKzrvapQyvLcCs4eYz7l/c6k5F9O9Cv+GCauiI/xc8C6z7WQr
	 uy8Gm5BAdV05nfD51D5dcFtChV9sBDFnEGBwP4N2/L1nkxQ3SNhqkDHF3UwKCfusyO
	 YBUsVq5Gnhsz1eY/5V0/63d0foRN5jPjEey0YNGs=
Date: Tue, 03 Dec 2024 17:03:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch added to mm-unstable branch
Message-Id: <20241204010308.EC6ADC4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: forward the gfp flags from alloc_contig_range() to post_alloc_hook()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch

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
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -6358,7 +6358,7 @@ static int __alloc_contig_migrate_range(
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list)
+static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6369,7 +6369,7 @@ static void split_free_pages(struct list
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, __GFP_MOVABLE);
+			post_alloc_hook(page, order, gfp_mask);
 			set_page_refcounted(page);
 			if (!order)
 				continue;
@@ -6387,7 +6387,8 @@ static void split_free_pages(struct list
 static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 {
 	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
+	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
+				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO;
 	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
 	/*
@@ -6535,7 +6536,7 @@ int alloc_contig_range_noprof(unsigned l
 	}
 
 	if (!(gfp_mask & __GFP_COMP)) {
-		split_free_pages(cc.freepages);
+		split_free_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
 		if (start != outer_start)
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


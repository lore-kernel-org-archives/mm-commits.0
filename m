Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93244142E6F
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270757; cv=none; b=GSU4KrbP4KfLX0GJ/G4pJGv1OXetEg8xkhQjAw0MMHEXmDtIujdw5yujIVsOVvj6N9svtaDI7VsYH6DJGokOQZ4YITuVMgl0XwCyVfvR3ABdTmURKg0cNX9lCspzdfQVBpGBGz+aoAxkmaYNpva/lbuO4/UeMbnzRMH6m/SgxL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270757; c=relaxed/simple;
	bh=vMT6GYqF3tRLVlFr+qs/trU5pcOBBNyjqrZDeork+BI=;
	h=Date:To:From:Subject:Message-Id; b=KZuHaCdqXh6OgrB1RF03A+xq4KMzT6fenHmmgnnVYHIwl0cpxiQvyl0T8WsVhWLDPcMKYxFmA8WE+CTwUTYWr7glml6IMA1Wz0ZrPWQjN4rYD8V3axlF0Kr2+PWHQwCk87xqik75LkZvzsV7Lsh636zBRoHNyDFPdvw0JZr3vIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qN4F/ccW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qN4F/ccW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E4CC32781;
	Sat, 10 Aug 2024 06:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270756;
	bh=vMT6GYqF3tRLVlFr+qs/trU5pcOBBNyjqrZDeork+BI=;
	h=Date:To:From:Subject:From;
	b=qN4F/ccWp39yBB8/snkBLf0jD8JqGzSDU1foeftU7xtdjGoYJFSv1O192NdFn8pFn
	 yLBUuiHO8F7Q0udVrCyIMIgIkQIerRykwuz+933Tuo2ckqxrB834rbQqYolnSMLbvS
	 0ooR3C2fTVqqniUUEn42nHpAEZqswfLLoYiLOl60=
Date: Fri, 09 Aug 2024 23:19:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-deferred-struct-page-init-ifdeffery.patch added to mm-unstable branch
Message-Id: <20240810061916.C1E4CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: reduce deferred struct page init ifdeffery
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-deferred-struct-page-init-ifdeffery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-deferred-struct-page-init-ifdeffery.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: reduce deferred struct page init ifdeffery
Date: Fri, 9 Aug 2024 14:48:48 +0300

Patch series "mm: Fix several issues with unaccepted memory", v2.

The patchset addresses several issues related to unaccepted memory.

Pacth 1/7 preparatory cleanup.

Patch 2/7 ensures that __alloc_pages_bulk() will not exhaust all
accepted memory without accepting more.

Patches 3/7-5/7 are preparations for patch 6/7, which fixes
alloc_config_page() on machines with unaccepted memory.  This allows, for
example, the allocation of gigantic pages at runtime.

Patch 7/7 enables the kernel to accept memory up to the promo watermark.


This patch (of 7):

Add dummy _deferred_grow_zone() for !DEFERRED_STRUCT_PAGE_INIT and remove
#ifdefs in two places.

No functional changes.

Link: https://lkml.kernel.org/r/20240809114854.3745464-1-kirill.shutemov@linux.intel.com
Link: https://lkml.kernel.org/r/20240809114854.3745464-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-reduce-deferred-struct-page-init-ifdeffery
+++ a/mm/page_alloc.c
@@ -322,6 +322,11 @@ static inline bool deferred_pages_enable
 {
 	return false;
 }
+
+static inline bool _deferred_grow_zone(struct zone *zone, unsigned int order)
+{
+	return false;
+}
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /* Return a pointer to the bitmap storing bits affecting a block of pages */
@@ -3395,7 +3400,6 @@ check_alloc_wmark:
 			if (cond_accept_memory(zone, order))
 				goto try_this_zone;
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/*
 			 * Watermark failed for this zone, but see if we can
 			 * grow this zone if it contains deferred pages.
@@ -3404,7 +3408,6 @@ check_alloc_wmark:
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
-#endif
 			/* Checked here to keep the fast path fast */
 			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 			if (alloc_flags & ALLOC_NO_WATERMARKS)
@@ -3450,13 +3453,11 @@ try_this_zone:
 			if (cond_accept_memory(zone, order))
 				goto try_this_zone;
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/* Try again if zone has deferred pages */
 			if (deferred_pages_enabled()) {
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
-#endif
 		}
 	}
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch
mm-reduce-deferred-struct-page-init-ifdeffery.patch
mm-accept-memory-in-__alloc_pages_bulk.patch
mm-introduce-pageunaccepted-page-type.patch
mm-rework-accept-memory-helpers.patch
mm-add-a-helper-to-accept-page.patch
mm-page_isolation-handle-unaccepted-memory-isolation.patch
mm-accept-to-promo-watermark.patch


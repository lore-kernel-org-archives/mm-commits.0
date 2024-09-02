Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0EC5381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247779; cv=none; b=n48f98qgefu2UY9PlE35ltCjoptx1Fnba9QGeYbzu/tNUUV2Re1KBVZlbPPraXkleOqk6ierbBRpSh0dYYuWAJZCbGAx6JdfkdY43aVvUq4lAmSM/wYd59ODLg9v+C7rek8iKGMpmf69HiSbn8ndd/fgbeaJRFSH3q139cOrq/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247779; c=relaxed/simple;
	bh=WORUcCFaEfctFybOE9e0/jOio/NPnVQBDXqcM8t6o/U=;
	h=Date:To:From:Subject:Message-Id; b=CEOxEz0oDtmp/h1g+gR024NrJ0/eWXZrfJAMRFMWqIdZIs2vIK3H/zeiMozG/bBPHUY28HfRn6z2BrsOI8sooFSBXTCUVIgvjb653KeSCAo4jwwvaCkEjri4AtdU0cmlfIAh7zoUW+B8f+duoQh7sfExOli5elaRk4UJr1fIIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrhHmniy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrhHmniy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44214C4CEC2;
	Mon,  2 Sep 2024 03:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247779;
	bh=WORUcCFaEfctFybOE9e0/jOio/NPnVQBDXqcM8t6o/U=;
	h=Date:To:From:Subject:From;
	b=LrhHmniyLPlw1WRuN1Q93YoiJ6NuH0GmWsVrk2TSr/5Ot5rBCru0TOjdViLBCczL3
	 Vpo4ECpnwcTRXioC5fIh9zdsU3qlgY/5TRiuAwyeN88yc2PMOZPxKmuKk2Wy9thzRz
	 iKN9FnYBHinXCUM9NZQtdTRlf17nN98wUth995nc=
Date: Sun, 01 Sep 2024 20:29:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reduce-deferred-struct-page-init-ifdeffery.patch removed from -mm tree
Message-Id: <20240902032939.44214C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: reduce deferred struct page init ifdeffery
has been removed from the -mm tree.  Its filename was
     mm-reduce-deferred-struct-page-init-ifdeffery.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



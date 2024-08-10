Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557BE142E6F
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270759; cv=none; b=BXIThppQSvQj1C01mZnvqaO8hKgD+1pbiIPVnIJP0w5GqHNYT2MyOgjHsXhta+gLJIG1UpLljhRAivi0ctSk7Bhmcysyy3sHoVXNHAxSKu9L/9N4JEoUD7zfO7gEKK6/yT+WGIJRW+qCypqjhhJb28bGSKU4tiP7lVu+Gv+HCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270759; c=relaxed/simple;
	bh=TQgzZSbKEjPau4xRvsTbjocTHr8cbfg+3j9vBhog5Eo=;
	h=Date:To:From:Subject:Message-Id; b=SDhFxt3bXw1RIMUdBfogJBqYjYCtJg3qEEgfB/VJDR0lcBN9eiXfVNxgJkURf/sfnnBsWPn2D1/iccs0oVJGSFfH/3XOd51zb/Zo4NQuacr1fZMMwG1MadWu1BToqSdXoL5HG/v3EzdOBzTabsDqbwf8IHFqIPUd6oN3GENkq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m8e8gxRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m8e8gxRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD780C32781;
	Sat, 10 Aug 2024 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270758;
	bh=TQgzZSbKEjPau4xRvsTbjocTHr8cbfg+3j9vBhog5Eo=;
	h=Date:To:From:Subject:From;
	b=m8e8gxRtQZ7nk7yi38Ro/LbjQAVbl2F/R8jdsHPUh1roG+EF/wm0p7/B/46VhpC19
	 91JuGKTneeHV0Hf6uqAURQDRHs/p8MDBQMiuN1ZR7u5iUx9w+ROYA/c8eL1klSQRyO
	 9aiWexD7PUMK3eYxqchsKrC33pT75bLmNL3lQWGU=
Date: Fri, 09 Aug 2024 23:19:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-accept-memory-in-__alloc_pages_bulk.patch added to mm-unstable branch
Message-Id: <20240810061918.BD780C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: accept memory in __alloc_pages_bulk()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-accept-memory-in-__alloc_pages_bulk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-accept-memory-in-__alloc_pages_bulk.patch

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
Subject: mm: accept memory in __alloc_pages_bulk()
Date: Fri, 9 Aug 2024 14:48:49 +0300

Currently, the kernel only accepts memory in get_page_from_freelist(), but
there is another path that directly takes pages from free lists -
__alloc_page_bulk().  This function can consume all accepted memory and
will resort to __alloc_pages_noprof() if necessary.

Conditionally accepted in __alloc_pages_bulk().

The same issue may arise due to deferred page initialization.  Kick the
deferred initialization machinery before abandoning the zone, as the
kernel does in get_page_from_freelist().

Link: https://lkml.kernel.org/r/20240809114854.3745464-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/page_alloc.c~mm-accept-memory-in-__alloc_pages_bulk
+++ a/mm/page_alloc.c
@@ -4577,12 +4577,23 @@ unsigned long alloc_pages_bulk_noprof(gf
 			goto failed;
 		}
 
+		cond_accept_memory(zone, 0);
+retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
 				alloc_flags, gfp)) {
 			break;
 		}
+
+		if (cond_accept_memory(zone, 0))
+			goto retry_this_zone;
+
+		/* Try again if zone has deferred pages */
+		if (deferred_pages_enabled()) {
+			if (_deferred_grow_zone(zone, 0))
+				goto retry_this_zone;
+		}
 	}
 
 	/*
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


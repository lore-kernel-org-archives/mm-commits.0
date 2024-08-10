Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316A123746
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270773; cv=none; b=sYqmlcPzff9+UeYtI3PgHgJppW7lLH8Yy6DHqev6nj55E8GiQS8+q27bfVlePLRHSPCaT+KY/2sxzZOTktauMM3Oxxdb6X6YVTEjwvejRLh0pgo4M6E6HaQfXANd4TVGFlzSC7YrssHFt1vl2qH4mmbp+f4pYFd29khSl/6dAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270773; c=relaxed/simple;
	bh=h1OH99Bt8Y2OP0ZDJqTtpFK9hVM7dLxWHz8YdRyl1qw=;
	h=Date:To:From:Subject:Message-Id; b=nh4PUDpCFpxsFwB2gRdP4gmUXUJosEkNvv96/eJhwEaEODTFBTV6LSR7217cLqOnJKWn93o4wjHWjY6pT8A0YaAkEebRHdAeKADa2CcANfidqgIbOL/FKFacNE8Nmu5RHb6BjTYhnIBjh/VewMl5WQ95FrzIlMKhMaguMlA5bjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJnSmngf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJnSmngf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB253C32781;
	Sat, 10 Aug 2024 06:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270773;
	bh=h1OH99Bt8Y2OP0ZDJqTtpFK9hVM7dLxWHz8YdRyl1qw=;
	h=Date:To:From:Subject:From;
	b=nJnSmngfnPLQz6n0rdFXti7vu1ISstqEK7yvOM0WH2hwj8bID5/YT0nVbx4WJpUin
	 LjOrs+lvHDHWWqyWTsdvu3YwMGZ22OcP1PyyIo5yL4lWj/y5f0s24dT804iXFKMwLW
	 d+jrmWEV9YHHCJiC+avaRaQbHESQXliY1CGMHRdE=
Date: Fri, 09 Aug 2024 23:19:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-accept-to-promo-watermark.patch added to mm-unstable branch
Message-Id: <20240810061932.EB253C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: accept to promo watermark
has been added to the -mm mm-unstable branch.  Its filename is
     mm-accept-to-promo-watermark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-accept-to-promo-watermark.patch

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
Subject: mm: accept to promo watermark
Date: Fri, 9 Aug 2024 14:48:54 +0300

Commit c574bbe91703 ("NUMA balancing: optimize page placement for memory
tiering system") introduced a new watermark above "high" -- "promo".

Accept memory memory to the highest watermark which is WMARK_PROMO now.

Link: https://lkml.kernel.org/r/20240809114854.3745464-9-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-accept-to-promo-watermark
+++ a/mm/page_alloc.c
@@ -7010,8 +7010,8 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
-	/* How much to accept to get to high watermark? */
-	to_accept = high_wmark_pages(zone) -
+	/* How much to accept to get to promo watermark? */
+	to_accept = promo_wmark_pages(zone) -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));
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


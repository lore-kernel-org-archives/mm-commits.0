Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1DD7346F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247788; cv=none; b=u5i23BOAUCVj7ZI/9eCm5PdhFLHNR1S1FVEL/NU+TE+nCvtfCjP4SPGpr8TrFf8pc3Wh1LowMX2b1F96palhY/IZ2jqv9G0CJZEBp78EGAZHyJugx/bbtomZNZFhB5JkEG8c+SruDizU812tFtbPrqptIOmcCVwgFg7fp2w/Edo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247788; c=relaxed/simple;
	bh=/l2lmttV7QO7CxY4xstMBK7+2OxY1ijY3DRl2nDZo8U=;
	h=Date:To:From:Subject:Message-Id; b=ViB0deFkf/BBNeUIXmessBhFDy6uUebullk9JGpb/BVYeZmjFVJt4CgU/U0IdjOj4iQRiiToo8cycXFz43hM+J/nsUnGmH6NLOua3fAbhGZ/vXm0ZUqxeKkSFV2PKg6yCqNIbxpfRUADRAB7smF/rWc4VExAYLWbWuhD0dE1umQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t/Ou9/1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t/Ou9/1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855EFC4CEC2;
	Mon,  2 Sep 2024 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247788;
	bh=/l2lmttV7QO7CxY4xstMBK7+2OxY1ijY3DRl2nDZo8U=;
	h=Date:To:From:Subject:From;
	b=t/Ou9/1ZNsng1Xs4NcyypMl8T+EX76O7jUdod4ee1NJfOSfxoXliu0XPJjg//6v7J
	 RFsDchERMKhTkeXihULYfZIYR9DgGGQ2Z96zuhBXpq/djIiTswzYb88awYaNEWupMU
	 sempA05O/I6SYKtIdFD16EzQPU8WSTzsdtAX47zA=
Date: Sun, 01 Sep 2024 20:29:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-accept-to-promo-watermark.patch removed from -mm tree
Message-Id: <20240902032948.855EFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: accept to promo watermark
has been removed from the -mm tree.  Its filename was
     mm-accept-to-promo-watermark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -7001,8 +7001,8 @@ static bool cond_accept_memory(struct zo
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



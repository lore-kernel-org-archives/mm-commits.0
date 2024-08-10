Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C2223746
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270771; cv=none; b=Mal+lzKp8V/Drbx5/Q6WPpParrf13itl8Ilj1HkZ5U7UPI534fMEXRSasrmYO7U4gnYG3gF8FMWn57pOVwfBrA0UaVYwDKPZO9G8WfrMRW2lJvgjBGH8Sma3pIPGez/5XR1+Phh8EjwAAnSeLLiZ731zmPA/Os+YjlNXQSOYKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270771; c=relaxed/simple;
	bh=xRktVrDXQ+9eZjxmhrtugebHM+Zpwj8h+o8y2ne0QUU=;
	h=Date:To:From:Subject:Message-Id; b=U2kavVFNMnCo7wRsr9GK03NF7cycEEFKU9r874tOvGYQ0zXgU3IWqQQ7QbE8Hc8jtfWa1Dff5f/p4LBp1UNkPQ25dHK+JlnQJJJLyKDUmOgTRm5OyWgbECc+HYM42Qs3bp6Evlz+tA3VnnFqVQCOoL3U17ox3p4T5HL6qiDk+hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHKp2xRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHKp2xRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFEDC32781;
	Sat, 10 Aug 2024 06:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270771;
	bh=xRktVrDXQ+9eZjxmhrtugebHM+Zpwj8h+o8y2ne0QUU=;
	h=Date:To:From:Subject:From;
	b=sHKp2xRsahgKuDVrDT0Fx6Z5L/g0ey5FW534gEKFxV0PFuEJldwX5KbinLwKA19/X
	 bysYGzG6PyhUX2Kr1usVs9MDkyMeG/swRmXQrwOJPGbT0Qja+idXLFWmyP9dJ8vaUC
	 GZ9F261Fqv6jc2p/fmzR0xn1iPyEI8zymfS8jBKw=
Date: Fri, 09 Aug 2024 23:19:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-handle-unaccepted-memory-isolation.patch added to mm-unstable branch
Message-Id: <20240810061931.0CFEDC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_isolation: handle unaccepted memory isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_isolation-handle-unaccepted-memory-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-handle-unaccepted-memory-isolation.patch

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
Subject: mm: page_isolation: handle unaccepted memory isolation
Date: Fri, 9 Aug 2024 14:48:53 +0300

Page isolation machinery doesn't know anything about unaccepted memory and
considers it non-free.  It leads to alloc_contig_pages() failure.

Treat unaccepted memory as free and accept memory on pageblock isolation. 
Once memory is accepted it becomes PageBuddy() and page isolation knows
how to deal with them.

Link: https://lkml.kernel.org/r/20240809114854.3745464-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A.  Shutemov <kirill.shutemov@linux.intel.com>
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

 mm/page_isolation.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_isolation.c~mm-page_isolation-handle-unaccepted-memory-isolation
+++ a/mm/page_isolation.c
@@ -152,6 +152,9 @@ static int set_migratetype_isolate(struc
 	unsigned long flags;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
+	if (PageUnaccepted(page))
+		accept_page(page);
+
 	spin_lock_irqsave(&zone->lock, flags);
 
 	/*
@@ -367,6 +370,11 @@ static int isolate_single_pageblock(unsi
 		VM_BUG_ON(!page);
 		pfn = page_to_pfn(page);
 
+		if (PageUnaccepted(page)) {
+			pfn += MAX_ORDER_NR_PAGES;
+			continue;
+		}
+
 		if (PageBuddy(page)) {
 			int order = buddy_order(page);
 
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


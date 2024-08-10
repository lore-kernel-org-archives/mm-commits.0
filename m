Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F5D146592;
	Sat, 10 Aug 2024 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270515; cv=none; b=REVcR18fI5yabLNPNVVmShCCqi2cuDBqQUv88ee3tB/NMCPnBvAOAUE6rErO4etFIusW7r3uZrqRSj9R6LuOgfHDfsVWRab3I0I7kOG3e28FGmPi0QYvIXWdgYsx8OMeaI9BNkf0Lm0fPtWv1nkWjxM4cP1zia8AJ2RUUD7YFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270515; c=relaxed/simple;
	bh=lyRkV0LJu+bodWWI+MR456a6dcbWeUgFgT2HFCrRfGI=;
	h=Date:To:From:Subject:Message-Id; b=SYHQ5wow33q6QuxZJvReN7keriMO7K6Q6TkaJt1wUlAeD/zENZ45kWzNkWVKBnqwGQtH6WS9SImFJG2zWlEZrnGoRIUaYQD/ur1zdkbtvrtrSgodt+bGDDUelKwQjPbVC369+xBZ+xrH8pb+6eRScU9eZStREbpMtHv9FYO+UQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KdCsZFAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KdCsZFAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F927C32781;
	Sat, 10 Aug 2024 06:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270514;
	bh=lyRkV0LJu+bodWWI+MR456a6dcbWeUgFgT2HFCrRfGI=;
	h=Date:To:From:Subject:From;
	b=KdCsZFACKBTGwJQ8yogh0Pg4CVnxCcLckIskv7io02whxO2fUWB+s0VBcKe1XTSjP
	 APBJ9Jjm4MDVUwnnAd4c3M1yWBlvpd3QKHv+ogsxVvWl9wS9t9M63HDTRO9r0yBb+Q
	 J5bwCVtphR3ExjwQ/fE65lsQdcd8H6vWUyNoNI6c=
Date: Fri, 09 Aug 2024 23:15:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,stable@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,jxgao@google.com,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20240810061514.5F927C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix endless reclaim on machines with unaccepted memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: fix endless reclaim on machines with unaccepted memory
Date: Fri, 9 Aug 2024 14:48:47 +0300

Unaccepted memory is considered unusable free memory, which is not counted
as free on the zone watermark check.  This causes get_page_from_freelist()
to accept more memory to hit the high watermark, but it creates problems
in the reclaim path.

The reclaim path encounters a failed zone watermark check and attempts to
reclaim memory.  This is usually successful, but if there is little or no
reclaimable memory, it can result in endless reclaim with little to no
progress.  This can occur early in the boot process, just after start of
the init process when the only reclaimable memory is the page cache of the
init executable and its libraries.

Make unaccepted memory free from watermark check point of view.  This way
unaccepted memory will never be the trigger of memory reclaim.  Accept
more memory in the get_page_from_freelist() if needed.

Link: https://lkml.kernel.org/r/20240809114854.3745464-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Jianxiong Gao <jxgao@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/mm/page_alloc.c~mm-fix-endless-reclaim-on-machines-with-unaccepted-memory
+++ a/mm/page_alloc.c
@@ -287,7 +287,7 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static void accept_page(struct page *page, unsigned int order);
-static bool try_to_accept_memory(struct zone *zone, unsigned int order);
+static bool cond_accept_memory(struct zone *zone, unsigned int order);
 static inline bool has_unaccepted_memory(void);
 static bool __free_unaccepted(struct page *page);
 
@@ -3072,9 +3072,6 @@ static inline long __zone_watermark_unus
 	if (!(alloc_flags & ALLOC_CMA))
 		unusable_free += zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
-#ifdef CONFIG_UNACCEPTED_MEMORY
-	unusable_free += zone_page_state(z, NR_UNACCEPTED);
-#endif
 
 	return unusable_free;
 }
@@ -3368,6 +3365,8 @@ retry:
 			}
 		}
 
+		cond_accept_memory(zone, order);
+
 		/*
 		 * Detect whether the number of free pages is below high
 		 * watermark.  If so, we will decrease pcp->high and free
@@ -3393,10 +3392,8 @@ check_alloc_wmark:
 				       gfp_mask)) {
 			int ret;
 
-			if (has_unaccepted_memory()) {
-				if (try_to_accept_memory(zone, order))
-					goto try_this_zone;
-			}
+			if (cond_accept_memory(zone, order))
+				goto try_this_zone;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/*
@@ -3450,10 +3447,8 @@ try_this_zone:
 
 			return page;
 		} else {
-			if (has_unaccepted_memory()) {
-				if (try_to_accept_memory(zone, order))
-					goto try_this_zone;
-			}
+			if (cond_accept_memory(zone, order))
+				goto try_this_zone;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/* Try again if zone has deferred pages */
@@ -6950,9 +6945,6 @@ static bool try_to_accept_memory_one(str
 	struct page *page;
 	bool last;
 
-	if (list_empty(&zone->unaccepted_pages))
-		return false;
-
 	spin_lock_irqsave(&zone->lock, flags);
 	page = list_first_entry_or_null(&zone->unaccepted_pages,
 					struct page, lru);
@@ -6978,23 +6970,29 @@ static bool try_to_accept_memory_one(str
 	return true;
 }
 
-static bool try_to_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	long to_accept;
-	int ret = false;
+	bool ret = false;
+
+	if (!has_unaccepted_memory())
+		return false;
+
+	if (list_empty(&zone->unaccepted_pages))
+		return false;
 
 	/* How much to accept to get to high watermark? */
 	to_accept = high_wmark_pages(zone) -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
-		    __zone_watermark_unusable_free(zone, order, 0));
+		    __zone_watermark_unusable_free(zone, order, 0) -
+		    zone_page_state(zone, NR_UNACCEPTED));
 
-	/* Accept at least one page */
-	do {
+	while (to_accept > 0) {
 		if (!try_to_accept_memory_one(zone))
 			break;
 		ret = true;
 		to_accept -= MAX_ORDER_NR_PAGES;
-	} while (to_accept > 0);
+	}
 
 	return ret;
 }
@@ -7037,7 +7035,7 @@ static void accept_page(struct page *pag
 {
 }
 
-static bool try_to_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	return false;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch


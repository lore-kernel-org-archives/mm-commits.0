Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301D2940B;
	Mon, 12 May 2025 00:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747009617; cv=none; b=thVkCPkbKgMLxgCeiGRA6Cd5kLV6dyix7lrYtmk2Y3U8VXZTcySTfobEs82CF1yEpP3/LxUTm5RnUG31PufzxzSkmOIfqDxnlmkGWCgf9UFhVhftg4xQUSZhDdFL67oJL7xNqSSjbOQjZOYOeUiuzaEonY2+2djELyLeKlnQWAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747009617; c=relaxed/simple;
	bh=LMikkdJBDP5bC3+ucIrgMCc44/Ovtjy4Pw7f8hTCKd0=;
	h=Date:To:From:Subject:Message-Id; b=YJ1iguYMorrCyrzRLFAXjp96CGOXrB/zbd6nozrryYgky1uDxD7qS+45UNyvN1mFrdyJ+SGDm9iirv+qZUw3aTC3CAy177x5YD6z5pfqJxXUfTAsQDt6aM8ZlOmnyrmnmYa76x1dt+NZ5uzM8juAojsbeyFM9YosN9c85h3XC0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icvWL+r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icvWL+r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665A4C4CEE4;
	Mon, 12 May 2025 00:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747009616;
	bh=LMikkdJBDP5bC3+ucIrgMCc44/Ovtjy4Pw7f8hTCKd0=;
	h=Date:To:From:Subject:From;
	b=icvWL+r4edqKXgZSzmiBi1k8vLTx8FLpetWATU/cSWSLACn+J/4B76UCgo8iI8b/8
	 wkGQYrSrGd3RltMX1I9lQrBHQiHOX6TGWf8fwTk//HoCfdALStB1ESkNtS60Sw+tNP
	 /jTOgNGuoJ8jwVO4Y8Il8qOiNi66VjXpdmrsAbwI=
Date: Sun, 11 May 2025 17:26:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ast@kernel.org,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch removed from -mm tree
Message-Id: <20250512002656.665A4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: ensure try_alloc_pages() plays well with unaccepted memory
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc: ensure try_alloc_pages() plays well with unaccepted memory
Date: Tue, 6 May 2025 14:25:08 +0300

try_alloc_pages() will not attempt to allocate memory if the system has
*any* unaccepted memory.  Memory is accepted as needed and can remain in
the system indefinitely, causing the interface to always fail.

Rather than immediately giving up, attempt to use already accepted memory
on free lists.

Pass 'alloc_flags' to cond_accept_memory() and do not accept new memory
for ALLOC_TRYLOCK requests.

Found via code inspection - only BPF uses this at present and the
runtime effects are unclear.

Link: https://lkml.kernel.org/r/20250506112509.905147-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory
+++ a/mm/page_alloc.c
@@ -290,7 +290,8 @@ EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
-static bool cond_accept_memory(struct zone *zone, unsigned int order);
+static bool cond_accept_memory(struct zone *zone, unsigned int order,
+			       int alloc_flags);
 static bool __free_unaccepted(struct page *page);
 
 int page_group_by_mobility_disabled __read_mostly;
@@ -3611,7 +3612,7 @@ retry:
 			}
 		}
 
-		cond_accept_memory(zone, order);
+		cond_accept_memory(zone, order, alloc_flags);
 
 		/*
 		 * Detect whether the number of free pages is below high
@@ -3638,7 +3639,7 @@ check_alloc_wmark:
 				       gfp_mask)) {
 			int ret;
 
-			if (cond_accept_memory(zone, order))
+			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
 			/*
@@ -3691,7 +3692,7 @@ try_this_zone:
 
 			return page;
 		} else {
-			if (cond_accept_memory(zone, order))
+			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
 			/* Try again if zone has deferred pages */
@@ -4844,7 +4845,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0);
+		cond_accept_memory(zone, 0, alloc_flags);
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
 		if (zone_watermark_fast(zone, 0,  mark,
@@ -4853,7 +4854,7 @@ retry_this_zone:
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0))
+		if (cond_accept_memory(zone, 0, alloc_flags))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -7281,7 +7282,8 @@ static inline bool has_unaccepted_memory
 	return static_branch_unlikely(&zones_with_unaccepted_pages);
 }
 
-static bool cond_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order,
+			       int alloc_flags)
 {
 	long to_accept, wmark;
 	bool ret = false;
@@ -7292,6 +7294,10 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
+	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
+	if (alloc_flags & ALLOC_TRYLOCK)
+		return false;
+
 	wmark = promo_wmark_pages(zone);
 
 	/*
@@ -7348,7 +7354,8 @@ static bool page_contains_unaccepted(str
 	return false;
 }
 
-static bool cond_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order,
+			       int alloc_flags)
 {
 	return false;
 }
@@ -7419,11 +7426,6 @@ struct page *try_alloc_pages_noprof(int
 	if (!pcp_allowed_order(order))
 		return NULL;
 
-#ifdef CONFIG_UNACCEPTED_MEMORY
-	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
-	if (has_unaccepted_memory())
-		return NULL;
-#endif
 	/* Bailout, since _deferred_grow_zone() needs to take a lock */
 	if (deferred_pages_enabled())
 		return NULL;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are



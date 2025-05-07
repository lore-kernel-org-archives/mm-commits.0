Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80BB28FAAA
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746651077; cv=none; b=bgFEFORF0bCUCTn0XsXqtNakRPZnTkF76Hk/q5Gf5GNg//13XeawlnOH12vCHRJhULtyCum23GrHLaTOJ2AeMiROVU4pa4+8/YGvhPYy+Fw6V0tjqzhxtfc/eoyrBY0SwVofpVfIw/ZNGL7A6gYgevHWN6pWztcXcmUbux6yp/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746651077; c=relaxed/simple;
	bh=r8S99y/UW6mS3+oH74NOqSLW6Q9zhGglo7KmTBPWpvA=;
	h=Date:To:From:Subject:Message-Id; b=G9ub/PpBYlg3kDrq97rmYuvU+op5fCBNNNUrlhYZOcFXYx9LILVGqZZSBonj6H6V+ogyY7aLBsD6Ke6I9eQziwcEeY5fV2FTiQLowcX7QgNw4HRLCQvsXSZ5iQxeKViHdJCDTznN41la45ypYFI92BX2JLDOxS798NWaWz9MEu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vm16y+ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vm16y+ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB66C4CEE2;
	Wed,  7 May 2025 20:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746651077;
	bh=r8S99y/UW6mS3+oH74NOqSLW6Q9zhGglo7KmTBPWpvA=;
	h=Date:To:From:Subject:From;
	b=vm16y+qlI1EcGNMNv15MpJ5pyNXmLUsXWOuZK66nFvyeuvZophkP8bTXId1HYUIfK
	 pnL0tYEz7S8DMKMynaSp+lrXf4f0ZLdWS3mqOO+6LKYTvakrEl0dn8CqxwM0EubBY3
	 wIkc9+OkgAzvD57DZsll2GWFu8IbGlYh6Ip2v9qo=
Date: Wed, 07 May 2025 13:51:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ast@kernel.org,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507205117.1DB66C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: ensure try_alloc_pages() plays well with unaccepted memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch

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
Subject: mm/page_alloc: ensure try_alloc_pages() plays well with unaccepted memory
Date: Tue, 6 May 2025 14:25:08 +0300

try_alloc_pages() will not attempt to allocate memory if the system has
*any* unaccepted memory.  Memory is accepted as needed and can remain in
the system indefinitely, causing the interface to always fail.

Rather than immediately giving up, attempt to use already accepted memory
on free lists.

Pass 'alloc_flags' to cond_accept_memory() and do not accept new memory
for ALLOC_TRYLOCK requests.

Link: https://lkml.kernel.org/r/20250506112509.905147-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -4852,7 +4853,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0);
+		cond_accept_memory(zone, 0, alloc_flags);
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
 		if (zone_watermark_fast(zone, 0,  mark,
@@ -4861,7 +4862,7 @@ retry_this_zone:
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0))
+		if (cond_accept_memory(zone, 0, alloc_flags))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -7289,7 +7290,8 @@ static inline bool has_unaccepted_memory
 	return static_branch_unlikely(&zones_with_unaccepted_pages);
 }
 
-static bool cond_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order,
+			       int alloc_flags)
 {
 	long to_accept, wmark;
 	bool ret = false;
@@ -7300,6 +7302,10 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
+	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
+	if (alloc_flags & ALLOC_TRYLOCK)
+		return false;
+
 	wmark = promo_wmark_pages(zone);
 
 	/*
@@ -7356,7 +7362,8 @@ static bool page_contains_unaccepted(str
 	return false;
 }
 
-static bool cond_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order,
+			       int alloc_flags)
 {
 	return false;
 }
@@ -7427,11 +7434,6 @@ struct page *try_alloc_pages_noprof(int
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

mm-page_alloc-ensure-try_alloc_pages-plays-well-with-unaccepted-memory.patch
mm-page_alloc-fix-race-condition-in-unaccepted-memory-handling.patch


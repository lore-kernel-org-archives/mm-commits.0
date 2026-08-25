Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7246345EDA
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622836; cv=none; b=aF2b5gqIb5jGh61NF0BdOq2kRS2BLzlQaNpqTypP8moS2UoQCNny2/me65QVna41FYkM+2Xi66nfc8YVZKpvRo2sMZz5YnejHnR6aiSSs4vP7gMsNGcZPbFMdKGb4Elep+AHdAMrP3KywENtotK2L4tbU1AXbgaSn/a2qSOp2tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622836; c=relaxed/simple;
	bh=VklTfriIyJGTD/jFEsbvBnMl7p9Ys5gmpyDipin9s48=;
	h=Date:To:From:Subject:Message-Id; b=a/w01MS3IYlmp71yoVb+Kz9e5Aj1LdItpVcQ+3aq1OK3xCMFjqWF3b740mPoeti9OSP9s4eSZGu0tZaLW7zvlmrURjxwEwiEZPpQ38DigFqPiUl8yhpwEJ6g2DoNcdM8CIrPnVU/VYle4eNstfmyiT+A2RTyAKFMExt67u0CKlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hDUTbA8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hDUTbA8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2291F000E9;
	Tue, 25 Aug 2026 01:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622834;
	bh=Qc0PB9SUahIt0hHkaGjD2wf2FOFVMJLtDApcWDwGpWE=;
	h=Date:To:From:Subject;
	b=hDUTbA8udUQK8gPAh+RbRrBoj9xeXrUp3Bu3xfBnmyDTS8cm9o38JrXlJzHDzThUU
	 Tz1/KkeFhGwQXOphiFZavTRoudg+Rqrsp+1oaI3rR9Oh6qKWaP/NJe9p2q9IQ1DOTX
	 u+t3//WBcebKVwmUspVohLwd/e5WK0lVelzzILg0=
Date: Mon, 24 Aug 2026 18:53:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-remove-pgdat_page_ext_init.patch removed from -mm tree
Message-Id: <20260825015354.7E2291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_ext: remove pgdat_page_ext_init()
has been removed from the -mm tree.  Its filename was
     mm-page_ext-remove-pgdat_page_ext_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/page_ext: remove pgdat_page_ext_init()
Date: Wed, 5 Aug 2026 00:11:42 +0900

pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on FLATMEM. 
FLATMEM depends on !NUMA, so the pgdat is always the zero-initialized
contig_page_data and the store has no effect.

So remove the call site, the unused function and its declaration.

No functional change.

Link: https://lore.kernel.org/20260804151145.3419768-3-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    5 -----
 mm/mm_init.c             |    1 -
 mm/page_ext.c            |    9 ---------
 3 files changed, 15 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-remove-pgdat_page_ext_init
+++ a/include/linux/page_ext.h
@@ -55,7 +55,6 @@ struct page_ext {
 
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
-extern void pgdat_page_ext_init(struct pglist_data *pgdat);
 
 static inline bool early_page_ext_enabled(void)
 {
@@ -202,10 +201,6 @@ static inline bool early_page_ext_enable
 	return false;
 }
 
-static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 static inline void page_ext_init(void)
 {
 }
--- a/mm/mm_init.c~mm-page_ext-remove-pgdat_page_ext_init
+++ a/mm/mm_init.c
@@ -1394,7 +1394,6 @@ static void __meminit pgdat_init_interna
 	for (i = 0; i < NR_VMSCAN_THROTTLE; i++)
 		init_waitqueue_head(&pgdat->reclaim_wait[i]);
 
-	pgdat_page_ext_init(pgdat);
 	lruvec_init(&pgdat->__lruvec);
 }
 
--- a/mm/page_ext.c~mm-page_ext-remove-pgdat_page_ext_init
+++ a/mm/page_ext.c
@@ -164,11 +164,6 @@ void __init page_ext_init_flatmem_late(v
 	invoke_init_callbacks();
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-	pgdat->node_page_ext = NULL;
-}
-
 static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -494,10 +489,6 @@ oom:
 	panic("Out of memory");
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 #endif
 
 /**
_

Patches currently in -mm which might be from ekffu200098@gmail.com are



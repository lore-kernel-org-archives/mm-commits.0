Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3561A08C2
	for <mm-commits@vger.kernel.org>; Tue, 16 Jul 2024 18:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721155273; cv=none; b=oR39SiochAHUWLaemeojAZup7LbGn7u09dFfYEol8TdV5N7H3BSF2hMn+nkaDdE+tEZiEOK/KJ94sJRtG6QmHlPGLDvfAAolrHq0w6s05cLQw+Rc8LiZtQnrLFcinDFX99dWpGV9n0xSaVWRe/+vha37RCQ6E++VdDA36PkMM0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721155273; c=relaxed/simple;
	bh=yL5vdn5JXBwqau21LXSjZW69HEpJOYaDMajezQNIB/8=;
	h=Date:To:From:Subject:Message-Id; b=LwSot2Y+cgiWJvLxtgoRjFD/pn/dvYE3IldYWCGaBdwaU36x1j84lt0J1fNbzcaD9WTKeUgiY5iLv269elsbLCXF1rvqwjvRdrkVsKwquPXEXcUgciS1dxKC/uAUApBYE+G6qMrhPp30BRBxBAxtCjIjZ3IkvLlx+mtc0PTcKoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ohS1Oqmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohS1Oqmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBADC4AF0B;
	Tue, 16 Jul 2024 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721155272;
	bh=yL5vdn5JXBwqau21LXSjZW69HEpJOYaDMajezQNIB/8=;
	h=Date:To:From:Subject:From;
	b=ohS1Oqmfyj+KW3Nfh0Fd3VGkXDMj3+esR0xlccXjy5l4KsEegEemSlBrf/ILILhia
	 /umI1qedwA8ux7br0IbRMvaHw56oj4oVyXkT874AwNAcdBnywbjRvKT/MGuRht1LJJ
	 QoYqShd/CLDGp4zmIBonahkV7CEY+L9ps/cMvpZU=
Date: Tue, 16 Jul 2024 11:41:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,jxgao@google.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20240716184112.4CBADC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix endless reclaim on machines with unaccepted memory.
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
Subject: mm: fix endless reclaim on machines with unaccepted memory.
Date: Tue, 16 Jul 2024 16:00:13 +0300

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

To address this issue, teach shrink_node() and shrink_zones() to accept
memory before attempting to reclaim.

Link: https://lkml.kernel.org/r/20240716130013.1997325-1-kirill.shutemov@linux.intel.com
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Jianxiong Gao <jxgao@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: stable@vger.kernel.org	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    9 +++++++++
 mm/page_alloc.c |    8 +-------
 mm/vmscan.c     |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-fix-endless-reclaim-on-machines-with-unaccepted-memory
+++ a/mm/internal.h
@@ -1515,4 +1515,13 @@ static inline void shrinker_debugfs_remo
 void workingset_update_node(struct xa_node *node);
 extern struct list_lru shadow_nodes;
 
+#ifdef CONFIG_UNACCEPTED_MEMORY
+bool try_to_accept_memory(struct zone *zone, unsigned int order);
+#else
+static inline bool try_to_accept_memory(struct zone *zone, unsigned int order)
+{
+	return false;
+}
+#endif /* CONFIG_UNACCEPTED_MEMORY */
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/page_alloc.c~mm-fix-endless-reclaim-on-machines-with-unaccepted-memory
+++ a/mm/page_alloc.c
@@ -287,7 +287,6 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static void accept_page(struct page *page, unsigned int order);
-static bool try_to_accept_memory(struct zone *zone, unsigned int order);
 static inline bool has_unaccepted_memory(void);
 static bool __free_unaccepted(struct page *page);
 
@@ -6940,7 +6939,7 @@ static bool try_to_accept_memory_one(str
 	return true;
 }
 
-static bool try_to_accept_memory(struct zone *zone, unsigned int order)
+bool try_to_accept_memory(struct zone *zone, unsigned int order)
 {
 	long to_accept;
 	int ret = false;
@@ -6999,11 +6998,6 @@ static void accept_page(struct page *pag
 {
 }
 
-static bool try_to_accept_memory(struct zone *zone, unsigned int order)
-{
-	return false;
-}
-
 static inline bool has_unaccepted_memory(void)
 {
 	return false;
--- a/mm/vmscan.c~mm-fix-endless-reclaim-on-machines-with-unaccepted-memory
+++ a/mm/vmscan.c
@@ -5900,12 +5900,44 @@ static void shrink_node_memcgs(pg_data_t
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
 }
 
+#ifdef CONFIG_UNACCEPTED_MEMORY
+static bool node_try_to_accept_memory(pg_data_t *pgdat, struct scan_control *sc)
+{
+	bool progress = false;
+	struct zone *zone;
+	int z;
+
+	for (z = 0; z <= sc->reclaim_idx; z++) {
+		zone = pgdat->node_zones + z;
+		if (!managed_zone(zone))
+			continue;
+
+		if (try_to_accept_memory(zone, sc->order))
+			progress = true;
+	}
+
+	return progress;
+}
+#else
+static inline bool node_try_to_accept_memory(pg_data_t *pgdat,
+					     struct scan_control *sc)
+{
+	return false;
+}
+#endif /* CONFIG_UNACCEPTED_MEMORY */
+
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
+	/* Try to accept memory before going for reclaim */
+	if (node_try_to_accept_memory(pgdat, sc)) {
+		if (!should_continue_reclaim(pgdat, 0, sc))
+			return;
+	}
+
 	if (lru_gen_enabled() && root_reclaim(sc)) {
 		lru_gen_shrink_node(pgdat, sc);
 		return;
@@ -6118,6 +6150,10 @@ static void shrink_zones(struct zonelist
 						 GFP_KERNEL | __GFP_HARDWALL))
 				continue;
 
+			/* Try to accept memory before going for reclaim */
+			if (try_to_accept_memory(zone, sc->order))
+				continue;
+
 			/*
 			 * If we already have plenty of memory free for
 			 * compaction in this zone, don't free any more.
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch


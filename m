Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACB413C9D1
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568648; cv=none; b=Wr+gpRjaleFZI/zeMrICRZBYjHZ2xqMtFVkbHDY55XxLxB+ZgOsBu+CdSA+9sEHNzxavkCjHv/MSwOlA4CF9JAsvOlIw7/tY5XJ+vk4HtJ+w+6u7M6V4AyynRu9cc1fUu0LphN5aEc43JrlWC6oLrg6fZVGJcg5yJxAFMIDwGRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568648; c=relaxed/simple;
	bh=THQn2gqf/f21u06QweQdyMp3ejpyj1IaAjg6y/VhS4c=;
	h=Date:To:From:Subject:Message-Id; b=h134KgRtXtxImT8gYQwO5eLP53gd6KuCkEjTwxKDb1u95u7ywckS9bD0wHSl8Meiy6efZy7XHcWmYXcO9gkzrSF0T8okcipOHDg2326bAqA/zuChhH4ms3Xmihr391h57iqttpPI5aTMYeJKtrphng8iQPXF+ZnhWY/y7YgseV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YyZpLtP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YyZpLtP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F45C433C7;
	Wed, 27 Mar 2024 19:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711568648;
	bh=THQn2gqf/f21u06QweQdyMp3ejpyj1IaAjg6y/VhS4c=;
	h=Date:To:From:Subject:From;
	b=YyZpLtP2A9HFcX7gg8SNqvpdhwpxi9hbcidYbLcV/Df4ZdxuC0D4g0DAm1CJhiSF8
	 YtFh2cEs3b0ytJbbCtEtDsMQP7b4eD+JcZ3UKSSO0ngcs0VqlDEKKy7ON79hRgcO1l
	 lQzkEXUvm4fXwSJGl1eJh31v2YOpmyq3Ld/yOQ/o=
Date: Wed, 27 Mar 2024 12:44:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-batch-vmstat-updates-in-expand.patch added to mm-unstable branch
Message-Id: <20240327194408.26F45C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: batch vmstat updates in expand()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-batch-vmstat-updates-in-expand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-batch-vmstat-updates-in-expand.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: batch vmstat updates in expand()
Date: Wed, 27 Mar 2024 15:01:11 -0400

expand() currently updates vmstat for every subpage.  This is unnecessary,
since they're all of the same zone and migratetype.

Count added pages locally, then do a single vmstat update.

Link: https://lkml.kernel.org/r/20240327190111.GC7597@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-vmstat-updates-in-expand
+++ a/mm/page_alloc.c
@@ -1341,6 +1341,7 @@ static inline void expand(struct zone *z
 	int low, int high, int migratetype)
 {
 	unsigned long size = 1 << high;
+	unsigned long nr_added = 0;
 
 	while (high > low) {
 		high--;
@@ -1356,9 +1357,11 @@ static inline void expand(struct zone *z
 		if (set_page_guard(zone, &page[size], high))
 			continue;
 
-		add_to_free_list(&page[size], zone, high, migratetype, false);
+		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
+		nr_added += size;
 	}
+	account_freepages(zone, nr_added, migratetype);
 }
 
 static void check_new_page_bad(struct page *page)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch
mm-page_alloc-consolidate-free-page-accounting-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-2.patch
mm-page_alloc-batch-vmstat-updates-in-expand.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF833BD64C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896590; cv=none; b=qr86AboyZXXPgChtSeCxiNpUbwgoMlGORHctFYDboSPY3TMHMhek4MUYiL22xtvDZqWw1vEScNieVfdLTd0keAYKjfyt4bqMtK2IbQkog8BXtBcf+cpV/rvZkw/wE9mmQvcAF/BQ9MycLpUrg4D3uKudHsombQClKsG/JLd3wqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896590; c=relaxed/simple;
	bh=EqlDAjUvq/nB1t93kT13lbtUZyDhGdpTrxzfRIPBrM4=;
	h=Date:To:From:Subject:Message-Id; b=kMdicnMC9qN91/ycEvDk+heOYfG6lhqZ8KxZs64UPZ9gUkN255NbviFWFN3dI8e0mS2Ra7ei8V5V9zhhceZMTvgBWg8XOErR7E4A5i7R1htmTmJj28/Ld+z54YSr0fXni0n8dgvvE6asFFP1/oZon87LV/Rdz1zsd54915Q9TfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XmjlH6q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XmjlH6q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8AF1F000E9;
	Wed,  5 Aug 2026 02:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896589;
	bh=6N3HZRsKOCJmw1Zqgz63lluET6HFcTGDySIutZ0kLdM=;
	h=Date:To:From:Subject;
	b=XmjlH6q7vaRwZone3+M53qckv0CawpVzR2sP+2LIEx5rPQINFBV3u7P/TbwFXEYRo
	 MZVN/9cb8OIMvJwdeZ/JjT9IAcHTjm+oLK7qHBucsFFcgJLcJMcRlSMdUmryM/ZQzD
	 zU9eybpywL0zb+bEoh7qF+6ny2kjj0sECeM5Pe8A=
Date: Tue, 04 Aug 2026 19:23:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-stop-recording-free-page-order-in-page-private.patch removed from -mm tree
Message-Id: <20260805022308.EF8AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: stop recording free page order in page->private
has been removed from the -mm tree.  Its filename was
     mm-compaction-stop-recording-free-page-order-in-page-private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: stop recording free page order in page->private
Date: Thu, 09 Jul 2026 14:06:02 -0400

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by
free page orders, it is no longer needed to store the order in each page's
->private field.  And there is no code using the stored order.  Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail().

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-2-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-stop-recording-free-page-order-in-page-private
+++ a/mm/compaction.c
@@ -645,7 +645,6 @@ static unsigned long isolate_freepages_b
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
-		set_page_private(page, order);
 
 		nr_scanned += isolated - 1;
 		total_isolated += isolated;
@@ -1618,7 +1617,6 @@ static void fast_isolate_freepages(struc
 		/* Isolate the page if available */
 		if (page) {
 			if (__isolate_free_page(page, order)) {
-				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
 				total_isolated += nr_isolated;
@@ -1847,7 +1845,6 @@ again:
 		size >>= 1;
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
-		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
xarray-honor-xa_flags_account-in-xas_split_alloc.patch


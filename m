Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C220CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898263; cv=none; b=ev/Ddc8F3xgGgcQiTHfHB1bcL7K88IiRhnqhB94tuu+Bj3/sBAdG0BlOnvU+w5aQrMtDVSgJNHAaAe17QjTi+dnkU4VwL9WAzbsmscBNVLAtd6PcN9EXP/Oeb3fGm5t7WdBna01ngSlQ1U2yIxi4qSwEYpX83yC4znCD9vV0R1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898263; c=relaxed/simple;
	bh=MJEPrlWvnYKbWibAImMo3swCR0dGsxI0tWq6FVNjm7I=;
	h=Date:To:From:Subject:Message-Id; b=lKLrRmj9qTdUtmcv4G/MmupeKLsADbpytUBN2yttn0EMCagGrSZGVg661sWPA7qCPAJu8XB4B+hXITPB9RyjQhCQbAdpP0YJOM7lf7Mg6y8Cx5T5hrClRpyscy1TwX4k7tNqJYjmcYV1e+HEWglbkYRsCm36UMeT+BxlOWN0KaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qVU9SDPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qVU9SDPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C694CC4CEF1;
	Sat, 31 Jan 2026 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898262;
	bh=MJEPrlWvnYKbWibAImMo3swCR0dGsxI0tWq6FVNjm7I=;
	h=Date:To:From:Subject:From;
	b=qVU9SDPKeEzr+GETCY5p/0AXX8DteKtZ5/ZrxOm8vpdPZ776Z5nac3H+Dt6Sl27d2
	 mwo0ZVM+Jip6KDp44athHGvlj3v/C5i3lR7q8adfHHV0wXVMY6T50Hk9fKLOfPaiVV
	 lqprNPOsu+/BQZphUDhh6F7ItqxpE9of8h118/k4=
Date: Sat, 31 Jan 2026 14:24:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch removed from -mm tree
Message-Id: <20260131222422.C694CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: fold balloon_mapping_gfp_mask() into balloon_page_alloc()
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: fold balloon_mapping_gfp_mask() into balloon_page_alloc()
Date: Tue, 20 Jan 2026 00:01:22 +0100

Let's just remove balloon_mapping_gfp_mask().

Link: https://lkml.kernel.org/r/20260119230133.3551867-15-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    7 -------
 mm/balloon_compaction.c            |   12 ++++++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc
+++ a/include/linux/balloon_compaction.h
@@ -106,13 +106,6 @@ static inline void balloon_page_insert(s
 	list_add(&page->lru, &balloon->pages);
 }
 
-static inline gfp_t balloon_mapping_gfp_mask(void)
-{
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
-		return GFP_HIGHUSER_MOVABLE;
-	return GFP_HIGHUSER;
-}
-
 /*
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
--- a/mm/balloon_compaction.c~mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc
+++ a/mm/balloon_compaction.c
@@ -112,10 +112,14 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequ
  */
 struct page *balloon_page_alloc(void)
 {
-	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-				       __GFP_NOMEMALLOC | __GFP_NORETRY |
-				       __GFP_NOWARN);
-	return page;
+	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		gfp_flags |= GFP_HIGHUSER_MOVABLE;
+	else
+		gfp_flags |= GFP_HIGHUSER;
+
+	return alloc_page(gfp_flags);
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch


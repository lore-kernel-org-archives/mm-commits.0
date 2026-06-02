Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16F3BC668
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439170; cv=none; b=TEcbhRCn1yrPjTdM0sKfm2arEaubGA8E6zmgxniK3+keI9240V+WlGQdwurUDMH91VRfd9tCzkHk86CUFAydTngr3sQxDeWgdFdLoXZBL90Hi85961dK3T3VdpPgsRUjhOr+CKRNo7feD2Aztq4PqC/Emsj6DFw/oZhQMDkzCTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439170; c=relaxed/simple;
	bh=DmJlayk6m6d30s1+wt8e3NktL1nyW//Q4c3flAf/p9E=;
	h=Date:To:From:Subject:Message-Id; b=jmJwi6sCGs5GH4jxIeS+fi1N2ynihOVpJrjYBRWh1MwCY6tbsa9HgjJFROTmXc+l93oMyd1Sv0LT9YWAbj9gljNwQb61fLQOuEkokZo1OAYAFB+v+MSZAULowFc8CHVmfIoh00nb4yQnIXhSE0vhl1HYyKMrEzf7v7JgiXHSWeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apz00caV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apz00caV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B521F00898;
	Tue,  2 Jun 2026 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439169;
	bh=9wWCiQVqNw7tl5sTe0OvJWjiqGHI3Z6TusqDMViT13w=;
	h=Date:To:From:Subject;
	b=apz00caVd6Rc/KpwQbpJpW/JFlSrzIVjdD1ZP6urqpVVWXca+o1ZF37K11hk1usXt
	 5s82ZhBSstBo3rNn6CWkCBoxD7vhmkPMSx8J1KGfxNvL4lWcP7xzWbojxPjKgA24lW
	 70CUzEwob1cDVMko246AAH2Ocfc2Kz/9qMkSLSrA=
Date: Tue, 02 Jun 2026 15:26:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch removed from -mm tree
Message-Id: <20260602222608.E2B521F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
Date: Tue, 26 May 2026 11:28:36 +0000

Vlastimil pointed out that the VM_BUG_ON()s have fallen out of favour, so
remove them.

Link: https://lore.kernel.org/20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/all/4074a816-9e75-45a6-8141-25459bcc106b@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers
+++ a/mm/page_alloc.c
@@ -653,13 +653,8 @@ static inline unsigned int order_to_pind
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			VM_BUG_ON(!is_pmd_order(order));
-
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			return NR_LOWORDER_PCP_LISTS + movable;
-		}
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
@@ -672,8 +667,6 @@ static inline int pindex_to_order(unsign
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pindex >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return order;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-delete-stale-comment-about-cachelines.patch


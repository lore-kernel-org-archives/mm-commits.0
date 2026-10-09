Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C613EEAC7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525613; cv=none; b=pOuMFohWP+cVJyhexY9eil4gDkPxFV6/h5Wzp5M2mkjw9DhIdbTGiOG1LhG38NWRKr9E1ENwlMyL1lxE3N4kUJ8wzJLCMtip4E+GaeSG1C71ZlUHGhtI9Ypp0opI+XkUfB8rhwXTeY5gBj8CY/ZTiVSItbusplVV/MGdO4xAd40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525613; c=relaxed/simple;
	bh=x1csXOC3Uot8dXtfWiqHKrKq9vZz+rTeWICuQSQSXyE=;
	h=Date:To:From:Subject:Message-Id; b=BRQhn5/RK1nbyHn0isoZIYzAnMG6AIcF0HAzG0o7B/bJWs9RRnkW/sCRklIVZAlhSETODUWeKwepiun817XIMd7jbgbaoY7bWntPVTKW7ualcdbIMZdLzcLQfkKFz14ed9OuNAp7U0+IG491uBZb0zyvoF9YPMkjoHaHOqX0ztM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1A6OFjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1A6OFjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202A11F00893;
	Fri,  9 Oct 2026 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525612;
	bh=19CSwPLBCjCuryScaJ4p+iK11HCWwZq3ay5oBggolsg=;
	h=Date:To:From:Subject;
	b=x1A6OFjoDhaxKhyND8kIQTumVg21Q0nnbLVIh2Rg05iaTozLsFCvjtMg4bSJhc2Sr
	 mW0xewGQzRFuUfz/emKvpJ18m4ws6wTcIEUL5JLWAzsXw7nVvYtw9ne4VsW98BlAdw
	 0woBjEAG80FduYltw0wutPYGal2WV8prIrwBKvR4=
Date: Thu, 08 Oct 2026 23:00:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch removed from -mm tree
Message-Id: <20261009060012.202A11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: drop the unused do_lru argument of the file split helper
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: drop the unused do_lru argument of the file split helper
Date: Wed, 23 Sep 2026 23:32:45 +0200

The only caller of __folio_freeze_split_file() always passes do_lru as
true, so the argument and the branches gated on it are dead code.  Drop
it.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-14-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper
+++ a/mm/huge_memory.c
@@ -4136,8 +4136,7 @@ out_unlock:
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		bool do_lru, struct list_head *list,
-		enum split_type split_type)
+		struct list_head *list, enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4231,9 +4230,7 @@ static int __folio_freeze_split_file(str
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4255,8 +4252,7 @@ static int __folio_freeze_split_file(str
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4282,9 +4278,7 @@ static int __folio_freeze_split_file(str
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);
 fail_mmap_unlock:
@@ -4360,7 +4354,7 @@ static int __folio_split(struct folio *f
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
-						true, list, split_type);
+						list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing
_

Patches currently in -mm which might be from kasong@tencent.com are



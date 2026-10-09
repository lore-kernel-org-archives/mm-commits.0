Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793241CB4D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525599; cv=none; b=V2uQUKpzn0IuPRuAT9oN66NHPT2qoma7TgJNf/5y5jttVdgZYn9b/a9wG4tvPmQ33op9bOxbEmoqkc0vMBxLC8nrTf1hKjQ77pbVCeQvgi/guGnv+0YBQZp2aDPgi7UEL47fdkC6HBySJlLbeEhr87JcPw5sGDf17qkndECmxGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525599; c=relaxed/simple;
	bh=qZQT9lv8Wd1FGOcsMujYjZMERqeA8CEu9WcLQ0LVP5I=;
	h=Date:To:From:Subject:Message-Id; b=V1RvpiM4PNnPfzp0Vl3/pi5MrPhjNBVj7/flXN7iZbGycGUxVVHfZS16xd2YOMzQekOnID5Fh9dMncSa/UUsaa6AcTzNN5qU/K51HcIcta8UcvZ4B9I81Q3NorRRxS26xtGbgV9fhsniMF/QMvnfD/fFvQ1Q/83kOzW6OPGbmLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uBrB6Ysx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uBrB6Ysx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9271F000FF;
	Fri,  9 Oct 2026 05:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525597;
	bh=zOqJph6eiyYd6Lw/4StPBgLfSuiqZepTCev8Q5+3JxA=;
	h=Date:To:From:Subject;
	b=uBrB6YsxIfMSpB+ADUefiPRPRxeH37kwlRmEkjdRy23Fsx8TL5/d+OZ16v2WcFDNL
	 ihBvze7X/254e1sevWwEBAQJ1NzDIhrcoqsVFISrP+fqXJdhMDMbm8oV94ad+Uun0j
	 r70Eq1fkMCBtZaepZdaO34nTaiyJLcE4ZEFhZG1g=
Date: Thu, 08 Oct 2026 22:59:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch removed from -mm tree
Message-Id: <20261009055957.7A9271F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: rename __split_unmapped_folio() to __split_frozen_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: rename __split_unmapped_folio() to __split_frozen_folio()
Date: Wed, 23 Sep 2026 23:32:36 +0200

The helper splits a folio whose refcount is frozen: the frozen refcount is
the state it relies on, while unmapping is arranged by the caller
beforehand.  The old name caused confusion and people may try to call the
helper on non-frozen folios.

Also add a VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio)) to self document
that frozen implies unmapped.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-5-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/huge_memory.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio
+++ a/mm/huge_memory.c
@@ -3810,8 +3810,8 @@ static void __split_folio_to_order(struc
 }
 
 /**
- * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
- * two ways: uniform split or non-uniform split.
+ * __split_frozen_folio() - splits a frozen @folio to lower order folios
+ * in two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3850,7 +3850,7 @@ static void __split_folio_to_order(struc
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
+static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, enum split_type split_type)
 {
@@ -3860,6 +3860,9 @@ static int __split_unmapped_folio(struct
 	struct folio *old_folio = folio;
 	int split_order;
 
+	/* Frozen implies unmapped, callers unmap before splitting. */
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
+
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
@@ -4037,8 +4040,8 @@ static int __folio_freeze_split_anon(str
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
-				     NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
+				   NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4104,8 +4107,8 @@ static int __folio_freeze_split_file(str
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-				     mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+				   mapping, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
@@ -4169,9 +4172,9 @@ static int __folio_freeze_split_file(str
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
- * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It calls __split_frozen_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
- * preparing @folio for __split_unmapped_folio().
+ * preparing @folio for __split_frozen_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
@@ -4274,7 +4277,7 @@ static int __folio_split(struct folio *f
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 * __split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,
_

Patches currently in -mm which might be from kasong@tencent.com are



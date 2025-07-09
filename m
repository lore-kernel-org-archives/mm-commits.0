Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AEE199947
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027836; cv=none; b=bdUNpFuyWhkv0vwjyaXHmy0zuddrR5N7LXEXYqSInCpeONKFOrSOWG1+LF3/e2T2Gnsh7sTAdbL8c1KQKw4r09WaSJmbSfIxBSXX4lNxlmIJAK5B72m3rrbQP2y/NU9JC1xXgrmdCvXVmVcQwothKTgBzZo+GxWkF/9iSK2WCkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027836; c=relaxed/simple;
	bh=2GN3z+9Z430tY9KlaFWmYDQzA2wY+aTVivzlYGhy0ZY=;
	h=Date:To:From:Subject:Message-Id; b=r+wqx07MkN9DjmCHYZ0AL9ohF4x0R8IO1ahBLR82o21e3pKhA1vg2kPtCQfeMzJ2VnByiBOfqwxos1+PDghsTyd+00cyqGEFlw9TiSxW+K0RkH0+1JkZce7UHwSrmBAirzct5YFklvwa5eRkhTEFy16mztVYlc2YGDFh7UjXqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZVLJYIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZVLJYIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A38EC4CEED;
	Wed,  9 Jul 2025 02:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027836;
	bh=2GN3z+9Z430tY9KlaFWmYDQzA2wY+aTVivzlYGhy0ZY=;
	h=Date:To:From:Subject:From;
	b=cZVLJYIr9K/wKCZFv+Jncv4D8cPWMfM1penbpVBDUyCf43gnDgrOMr76nYWUykeJH
	 zjI+quIPSUhZ29qqM9czB48VYzfFdzUEC4jF7l5/mnU7VvyJ8MwmSnh+EM9olT/lpi
	 xLZNBI+hcfifmMejRQGfmA7SVODQIc9EtA6g3dyc=
Date: Tue, 08 Jul 2025 19:23:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch added to mm-new branch
Message-Id: <20250709022356.9A38EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}
Date: Tue, 8 Jul 2025 19:59:41 -0500

damos->migrate_dests provides a list of nodes the migrate_{hot,cold}
actions should migrate to, as well as the weights which specify the ratio
pages should be migrated to each destination node.

This patch interleaves pages in the migrate_{hot,cold} actions according
to the information provided in damos->migrate_dests if it is used.  The
interleaving algorithm used is similar to the one used in
weighted_interleave_nid().  If damos->migration_dests is not provided, the
actions migrate pages to the node specified in damos->target_nid as
before.

Link: https://lkml.kernel.org/r/20250709005952.17776-12-bijan311@gmail.com
Co-developed-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |  108 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 92 insertions(+), 16 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold
+++ a/mm/damon/vaddr.c
@@ -611,11 +611,69 @@ static unsigned int damon_va_check_acces
 	return max_nr_accesses;
 }
 
+struct damos_va_migrate_private {
+	struct list_head *migration_lists;
+	struct damos_migrate_dests *dests;
+};
+
+/*
+ * Place the given folio in the migration_list corresponding to where the folio
+ * should be migrated.
+ *
+ * The algorithm used here is similar to weighted_interleave_nid()
+ */
+static void damos_va_migrate_dests_add(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr,
+		struct damos_migrate_dests *dests,
+		struct list_head *migration_lists)
+{
+	pgoff_t ilx;
+	int order;
+	unsigned int target;
+	unsigned int weight_total = 0;
+	int i;
+
+	/*
+	 * If dests is empty, there is only one migration list corresponding
+	 * to s->target_nid.
+	 */
+	if (!dests->nr_dests) {
+		i = 0;
+		goto isolate;
+	}
+
+	order = folio_order(folio);
+	ilx = vma->vm_pgoff >> order;
+	ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+
+	for (i = 0; i < dests->nr_dests; i++)
+		weight_total += dests->weight_arr[i];
+
+	/* If the total weights are somehow 0, don't migrate at all */
+	if (!weight_total)
+		return;
+
+	target = ilx % weight_total;
+	for (i = 0; i < dests->nr_dests; i++) {
+		if (target < dests->weight_arr[i])
+			break;
+		target -= dests->weight_arr[i];
+	}
+
+isolate:
+	if (!folio_isolate_lru(folio))
+		return;
+
+	list_add(&folio->lru, &migration_lists[i]);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
-	struct list_head *migration_list = walk->private;
+	struct damos_va_migrate_private *priv = walk->private;
+	struct list_head *migration_lists = priv->migration_lists;
+	struct damos_migrate_dests *dests = priv->dests;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pmd_t pmde;
@@ -633,12 +691,9 @@ static int damos_va_migrate_pmd_entry(pm
 	if (!folio)
 		goto unlock;
 
-	if (!folio_isolate_lru(folio))
-		goto put_folio;
-
-	list_add(&folio->lru, migration_list);
+	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+		migration_lists);
 
-put_folio:
 	folio_put(folio);
 unlock:
 	spin_unlock(ptl);
@@ -651,7 +706,9 @@ unlock:
 static int damos_va_migrate_pte_entry(pte_t *pte, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
-	struct list_head *migration_list = walk->private;
+	struct damos_va_migrate_private *priv = walk->private;
+	struct list_head *migration_lists = priv->migration_lists;
+	struct damos_migrate_dests *dests = priv->dests;
 	struct folio *folio;
 	pte_t ptent;
 
@@ -663,12 +720,9 @@ static int damos_va_migrate_pte_entry(pt
 	if (!folio)
 		return 0;
 
-	if (!folio_isolate_lru(folio))
-		goto out;
+	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+		migration_lists);
 
-	list_add(&folio->lru, migration_list);
-
-out:
 	folio_put(folio);
 	return 0;
 }
@@ -721,26 +775,48 @@ static unsigned long damos_va_migrate(st
 		unsigned long *sz_filter_passed)
 {
 	LIST_HEAD(folio_list);
+	struct damos_va_migrate_private priv;
 	struct mm_struct *mm;
+	int nr_dests;
+	int nid;
+	bool use_target_nid;
 	unsigned long applied = 0;
+	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_migrate_pmd_entry,
 		.pte_entry = damos_va_migrate_pte_entry,
 		.walk_lock = PGWALK_RDLOCK,
 	};
 
+	use_target_nid = dests->nr_dests == 0;
+	nr_dests = use_target_nid ? 1 : dests->nr_dests;
+	priv.dests = dests;
+	priv.migration_lists = kmalloc_array(nr_dests,
+		sizeof(*priv.migration_lists), GFP_KERNEL);
+	if (!priv.migration_lists)
+		return 0;
+
+	for (int i = 0; i < nr_dests; i++)
+		INIT_LIST_HEAD(&priv.migration_lists[i]);
+
+
 	mm = damon_get_mm(target);
 	if (!mm)
-		return 0;
+		goto free_lists;
 
 	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &folio_list);
+	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmap_read_unlock(mm);
 	mmput(mm);
 
-	applied = damon_migrate_pages(&folio_list, s->target_nid);
-	cond_resched();
+	for (int i = 0; i < nr_dests; i++) {
+		nid = use_target_nid ? s->target_nid : dests->node_id_arr[i];
+		applied += damon_migrate_pages(&priv.migration_lists[i], nid);
+		cond_resched();
+	}
 
+free_lists:
+	kfree(priv.migration_lists);
 	return applied * PAGE_SIZE;
 }
 
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-commit-damos-target_nid.patch
mm-damon-core-commit-damos-migrate_dests.patch
mm-damon-move-migration-helpers-from-paddr-to-ops-common.patch
mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch
docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch
mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch
mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch
mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch


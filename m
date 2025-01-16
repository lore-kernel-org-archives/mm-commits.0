Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2A5172BD5
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006274; cv=none; b=cooLtdDdxV+sHnklX5CGEYAKbAlYKncDOWb8af/XQ35vLRmYtsWCugPqJ3/RODhNM8iyi3ZQ99i69OhLESbjceN/Zj5kK3YjwpA5E3KCeWOv7Ne2UwQ7CYXQJOITxH5bVaKdOODputN/7DQRzuw0e5WoCfGuNITArVliIr/8S4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006274; c=relaxed/simple;
	bh=xhQmTTDZKLV4AU+9pjo4xLMsXlgQsUuAhHhM2NfUPnQ=;
	h=Date:To:From:Subject:Message-Id; b=iQdyPmeWI7BDqEcy2wDV90QsBuPMuU55lxhZY1bpgxpmKyfHMlR8fTcNAqr3ulCtK9GGuXrUTqlZWnYuJ5ubyN+FNpKeFchOXrkfDexnuuA/uvYEv22BbHvnHUn/V6uEDWG+gLewNb5ATTC8s6bwz1o2dK7+1491f7OscD8lBXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KJ4qIq0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KJ4qIq0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10C9C4CED6;
	Thu, 16 Jan 2025 05:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006273;
	bh=xhQmTTDZKLV4AU+9pjo4xLMsXlgQsUuAhHhM2NfUPnQ=;
	h=Date:To:From:Subject:From;
	b=KJ4qIq0KGnUYzWxbNim1RJVnjGMyB1GfnY8N/XpEDoNc46/6VnoErjCeRXAKuvsfg
	 QPfGUDeVvXEb20mPePx0KVRq7yGwHQwdhuOo6aMKwx7HPBJULSPs51A9OoyZQCHb3M
	 TH9x0Z4cUsITM7nNXG6nZYu8Zwc53Zr0aDlTKM58=
Date: Wed, 15 Jan 2025 21:44:33 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-optimize-deactivation.patch removed from -mm tree
Message-Id: <20250116054433.C10C9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: optimize deactivation
has been removed from the -mm tree.  Its filename was
     mm-mglru-optimize-deactivation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: optimize deactivation
Date: Mon, 30 Dec 2024 21:35:33 -0700

Do not shuffle a folio in the deactivation paths if it is already in the
oldest generation.  This reduces the LRU lock contention.

Before this patch, the contention is reproducible by FIO, e.g.,

  fio -filename=/dev/nvme1n1p2 -direct=0 -thread -size=1024G \
      -rwmixwrite=30  --norandommap --randrepeat=0 -ioengine=sync \
      -bs=4k -numjobs=400 -runtime=25000 --time_based \
      -group_reporting -name=mglru

  98.96%--_raw_spin_lock_irqsave
          folio_lruvec_lock_irqsave
          |
           --98.78%--folio_batch_move_lru
               |
                --98.63%--deactivate_file_folio
                          mapping_try_invalidate
                          invalidate_mapping_pages
                          invalidate_bdev
                          blkdev_common_ioctl
                          blkdev_ioctl

After this patch, deactivate_file_folio() bails out early without taking
the LRU lock.

A side effect is that a folio can be left at the head of the oldest
generation, rather than the tail.  If reclaim happens at the same time, it
cannot reclaim this folio immediately.  Since there is no known
correlation between truncation and reclaim, this side effect is considered
insignificant.

Link: https://lkml.kernel.org/r/20241231043538.4075764-3-yuzhao@google.com
Reported-by: Bharata B Rao <bharata@amd.com>
Closes: https://lore.kernel.org/CAOUHufawNerxqLm7L9Yywp3HJFiYVrYO26ePUb1jH-qxNGWzyA@mail.gmail.com/
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-mglru-optimize-deactivation
+++ a/mm/swap.c
@@ -379,7 +379,8 @@ static void __lru_cache_activate_folio(s
 }
 
 #ifdef CONFIG_LRU_GEN
-static void folio_inc_refs(struct folio *folio)
+
+static void lru_gen_inc_refs(struct folio *folio)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
 
@@ -406,10 +407,34 @@ static void folio_inc_refs(struct folio
 		new_flags |= old_flags & ~LRU_REFS_MASK;
 	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
 }
-#else
-static void folio_inc_refs(struct folio *folio)
+
+static bool lru_gen_clear_refs(struct folio *folio)
+{
+	struct lru_gen_folio *lrugen;
+	int gen = folio_lru_gen(folio);
+	int type = folio_is_file_lru(folio);
+
+	if (gen < 0)
+		return true;
+
+	set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+
+	lrugen = &folio_lruvec(folio)->lrugen;
+	/* whether can do without shuffling under the LRU lock */
+	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+}
+
+#else /* !CONFIG_LRU_GEN */
+
+static void lru_gen_inc_refs(struct folio *folio)
+{
+}
+
+static bool lru_gen_clear_refs(struct folio *folio)
 {
+	return false;
 }
+
 #endif /* CONFIG_LRU_GEN */
 
 /**
@@ -428,7 +453,7 @@ static void folio_inc_refs(struct folio
 void folio_mark_accessed(struct folio *folio)
 {
 	if (lru_gen_enabled()) {
-		folio_inc_refs(folio);
+		lru_gen_inc_refs(folio);
 		return;
 	}
 
@@ -524,7 +549,7 @@ void folio_add_lru_vma(struct folio *fol
  */
 static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 {
-	bool active = folio_test_active(folio);
+	bool active = folio_test_active(folio) || lru_gen_enabled();
 	long nr_pages = folio_nr_pages(folio);
 
 	if (folio_test_unevictable(folio))
@@ -589,7 +614,10 @@ static void lru_lazyfree(struct lruvec *
 
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	folio_clear_referenced(folio);
+	if (lru_gen_enabled())
+		lru_gen_clear_refs(folio);
+	else
+		folio_clear_referenced(folio);
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal
@@ -657,6 +685,9 @@ void deactivate_file_folio(struct folio
 	if (folio_test_unevictable(folio))
 		return;
 
+	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
+		return;
+
 	folio_batch_add_and_move(folio, lru_deactivate_file, true);
 }
 
@@ -670,7 +701,10 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_unevictable(folio) || !(folio_test_active(folio) || lru_gen_enabled()))
+	if (folio_test_unevictable(folio))
+		return;
+
+	if (lru_gen_enabled() ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
 		return;
 
 	folio_batch_add_and_move(folio, lru_deactivate, true);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch


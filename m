Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CDC38382
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247678; cv=none; b=FTBT0dcDlMz7L3bgGewoYA4kraEu7XUWVe85Lgfp5xMsSoPvRHLVzrSFVGyA3lHKeqSYBldHuPFlrNeomipAZ0+gyPShJwt2x2MgYtjnPzSFSc23mL2sZGB1EQNll7tdhah99cfUR77kl3J/tQycqZ0d6od0w3nFdYTq9lsyZ1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247678; c=relaxed/simple;
	bh=kQMk/5s7mbNgjOwrNEMjArnYJhyUbDcM5jcnqSd21Ls=;
	h=Date:To:From:Subject:Message-Id; b=EPyMzLuzIE1z6ERVwlOYfuVddrG1881pbbS2MzHH0whPZd9fR3wO7yQo1Qy/UHxErUTGz1AFmEWhAMdUmIqZXiZuZo41TxSq3nKNPnpbzks9zyH9moRJO9E2lWXKq7s2nmn6wjbr3dcY7qKm0PnU7RHLKWQwTqYMvL6x4fSe0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ayQDNspZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ayQDNspZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C68AC4CEC2;
	Mon,  2 Sep 2024 03:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247678;
	bh=kQMk/5s7mbNgjOwrNEMjArnYJhyUbDcM5jcnqSd21Ls=;
	h=Date:To:From:Subject:From;
	b=ayQDNspZBiKTwKkPGWfG5YWdoFwduvM/0bsFLc0VI2CK9B5IMr2d1wfemm/rrzDCs
	 ZvXFOAshY2OukHuLA2zxn9hu7QDdC4QQgGIv2pzFHvy8v7ycFHDZbcYGTneuKj1AaO
	 0sG3swda4lw6RhBXGfKcm5NLafkmN2YwyYUx5sEQ=
Date: Sun, 01 Sep 2024 20:27:58 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-cpu_fbatches-activate.patch removed from -mm tree
Message-Id: <20240902032758.8C68AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: rename cpu_fbatches->activate
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-cpu_fbatches-activate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: rename cpu_fbatches->activate
Date: Wed, 10 Jul 2024 20:13:14 -0600

Rename cpu_fbatches->activate to cpu_fbatches->lru_activate, and its
handler folio_activate_fn() to lru_activate() so that all the boilerplate
can be removed at the end of this series.

Link: https://lkml.kernel.org/r/20240711021317.596178-3-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/swap.c~mm-swap-rename-cpu_fbatches-activate
+++ a/mm/swap.c
@@ -67,7 +67,7 @@ struct cpu_fbatches {
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
 #ifdef CONFIG_SMP
-	struct folio_batch activate;
+	struct folio_batch lru_activate;
 #endif
 };
 static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
@@ -331,7 +331,7 @@ void lru_note_cost_refault(struct folio
 		      folio_nr_pages(folio), 0);
 }
 
-static void folio_activate_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 
@@ -351,10 +351,10 @@ static void folio_activate_fn(struct lru
 #ifdef CONFIG_SMP
 static void folio_activate_drain(int cpu)
 {
-	struct folio_batch *fbatch = &per_cpu(cpu_fbatches.activate, cpu);
+	struct folio_batch *fbatch = &per_cpu(cpu_fbatches.lru_activate, cpu);
 
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, folio_activate_fn);
+		folio_batch_move_lru(fbatch, lru_activate);
 }
 
 void folio_activate(struct folio *folio)
@@ -371,8 +371,8 @@ void folio_activate(struct folio *folio)
 	}
 
 	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.activate);
-	folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_activate);
+	folio_batch_add_and_move(fbatch, folio, lru_activate);
 	local_unlock(&cpu_fbatches.lock);
 }
 
@@ -389,7 +389,7 @@ void folio_activate(struct folio *folio)
 		return;
 
 	lruvec = folio_lruvec_lock_irq(folio);
-	folio_activate_fn(lruvec, folio);
+	lru_activate(lruvec, folio);
 	unlock_page_lruvec_irq(lruvec);
 	folio_set_lru(folio);
 }
@@ -490,7 +490,7 @@ void folio_mark_accessed(struct folio *f
 	} else if (!folio_test_active(folio)) {
 		/*
 		 * If the folio is on the LRU, queue it for activation via
-		 * cpu_fbatches.activate. Otherwise, assume the folio is in a
+		 * cpu_fbatches.lru_activate. Otherwise, assume the folio is in a
 		 * folio_batch, mark it active and it'll be moved to the active
 		 * LRU on the next drain.
 		 */
@@ -829,7 +829,7 @@ static bool cpu_needs_drain(unsigned int
 		folio_batch_count(&fbatches->lru_deactivate_file) ||
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
-		folio_batch_count(&fbatches->activate) ||
+		folio_batch_count(&fbatches->lru_activate) ||
 		need_mlock_drain(cpu) ||
 		has_bh_in_lru(cpu, NULL);
 }
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FAE15EFCD
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849589; cv=none; b=puuoahgLtksjbgEv+6pLqP9XBzrxhAHv9+4wIwH6IHE3HQmw2UXAJQ47OR2k3M/YcbhPOmQGSC9x5QhC+236raddKxkWT+dFmKdvpzIMV1b9WyQY8Akicv+YFIDFYDyCC9oiEKof9jSfEfchc/HZw3DukqS8SR/mrC6FN6gPwSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849589; c=relaxed/simple;
	bh=cm2PwM/nyy4lTjBfxhg3rFQW5E6iSoMNbydrfZGCbsk=;
	h=Date:To:From:Subject:Message-Id; b=CHw6bs76kWiccpifvsdN0Riql3y7CRMNNRrg7VGX+81EftC1uKjpNwjMXk14HZWCxpGMy8fL3XiqYgAu/L67s/6MZbaUJ8jnYCTA0ZoXnkbGWlkybwikxE7RmqBk8mIvjRDClEDG2NQJAc4jTqYauCYuK+yV2nxVjIFSn6b2SPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SzADBrV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SzADBrV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F982C32781;
	Wed, 24 Jul 2024 19:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849589;
	bh=cm2PwM/nyy4lTjBfxhg3rFQW5E6iSoMNbydrfZGCbsk=;
	h=Date:To:From:Subject:From;
	b=SzADBrV7K1pImOWEUM9eQAhvfHYU2stcxZ9HOGZpdQbi2JUZ6bstVBbbNziGPTCtC
	 ZJXZdE+IGyki1T8cb7kAkUiB3OcvFiDyWdtBitlCrHrD5VUq7I8sTqcx4mVKHYy3Rt
	 FpXimFvYHJiqe2DdGFoQ3XOOk3McUsuyqSiO3H/U=
Date: Wed, 24 Jul 2024 12:33:09 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-remaining-_fn-suffix.patch added to mm-unstable branch
Message-Id: <20240724193309.8F982C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove remaining _fn suffix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-remaining-_fn-suffix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-remaining-_fn-suffix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: remove remaining _fn suffix
Date: Wed, 10 Jul 2024 20:13:16 -0600

Remove remaining _fn suffix from cpu_fbatches handlers, which are already
self-explanatory.

Link: https://lkml.kernel.org/r/20240711021317.596178-5-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/swap.c~mm-swap-remove-remaining-_fn-suffix
+++ a/mm/swap.c
@@ -160,7 +160,7 @@ EXPORT_SYMBOL(put_pages_list);
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
-static void lru_add_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_add(struct lruvec *lruvec, struct folio *folio)
 {
 	int was_unevictable = folio_test_clear_unevictable(folio);
 	long nr_pages = folio_nr_pages(folio);
@@ -230,7 +230,7 @@ static void folio_batch_add_and_move(str
 	folio_batch_move_lru(fbatch, move_fn);
 }
 
-static void lru_move_tail_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	if (folio_test_unevictable(folio))
 		return;
@@ -265,7 +265,7 @@ void folio_rotate_reclaimable(struct fol
 
 	local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_move_tail);
-	folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_move_tail);
 	local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 }
 
@@ -527,7 +527,7 @@ void folio_add_lru(struct folio *folio)
 	folio_get(folio);
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
-	folio_batch_add_and_move(fbatch, folio, lru_add_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_add);
 	local_unlock(&cpu_fbatches.lock);
 }
 EXPORT_SYMBOL(folio_add_lru);
@@ -571,7 +571,7 @@ void folio_add_lru_vma(struct folio *fol
  * written out by flusher threads as this is much more efficient
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_file_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 {
 	bool active = folio_test_active(folio);
 	long nr_pages = folio_nr_pages(folio);
@@ -612,7 +612,7 @@ static void lru_deactivate_file_fn(struc
 	}
 }
 
-static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 
@@ -628,7 +628,7 @@ static void lru_deactivate_fn(struct lru
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 }
 
-static void lru_lazyfree_fn(struct lruvec *lruvec, struct folio *folio)
+static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 
@@ -662,7 +662,7 @@ void lru_add_drain_cpu(int cpu)
 	struct folio_batch *fbatch = &fbatches->lru_add;
 
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_add_fn);
+		folio_batch_move_lru(fbatch, lru_add);
 
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
@@ -671,21 +671,21 @@ void lru_add_drain_cpu(int cpu)
 
 		/* No harm done if a racing interrupt already did this */
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
-		folio_batch_move_lru(fbatch, lru_move_tail_fn);
+		folio_batch_move_lru(fbatch, lru_move_tail);
 		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 	}
 
 	fbatch = &fbatches->lru_deactivate_file;
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_deactivate_file_fn);
+		folio_batch_move_lru(fbatch, lru_deactivate_file);
 
 	fbatch = &fbatches->lru_deactivate;
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_deactivate_fn);
+		folio_batch_move_lru(fbatch, lru_deactivate);
 
 	fbatch = &fbatches->lru_lazyfree;
 	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_lazyfree_fn);
+		folio_batch_move_lru(fbatch, lru_lazyfree);
 
 	folio_activate_drain(cpu);
 }
@@ -716,7 +716,7 @@ void deactivate_file_folio(struct folio
 
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate_file);
-	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file);
 	local_unlock(&cpu_fbatches.lock);
 }
 
@@ -743,7 +743,7 @@ void folio_deactivate(struct folio *foli
 
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
-	folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_deactivate);
 	local_unlock(&cpu_fbatches.lock);
 }
 
@@ -770,7 +770,7 @@ void folio_mark_lazyfree(struct folio *f
 
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
-	folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
+	folio_batch_add_and_move(fbatch, folio, lru_lazyfree);
 	local_unlock(&cpu_fbatches.lock);
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch


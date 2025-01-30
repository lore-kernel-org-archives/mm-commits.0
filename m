Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDF4139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280453; cv=none; b=Be1bHUBrDBNZbGYpHWpK+T/WE4GzMe418C5izGKYC0fcz8twXW2NvwpxPZuechDlLGT7UGJHCQdqBxzFHCD1/d1VGF0n/ZetG4f5WeYMZIx/jInIejwow6m+YQeHmIlK/SD3YQ1pLY7HEL0wXvFsJjZOd+GBN7VibPLMZU8m2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280453; c=relaxed/simple;
	bh=hFsO9sOeblmnDNzQygKu1F26HRjUUPq9QZu7U4BTE3s=;
	h=Date:To:From:Subject:Message-Id; b=NhkPIPE6oE+XAN1AEV98lzlYfPxAb8esN/RMpHqFkNh7eSggYnEVPtUedFnlMOgVsStJYcMNGZTnv5P/Ep5ME6Op6sddEbDZS9QQNSOnnAjAeKRVmdcSnsqBw0aYLmyiIIoTmDul4E98fWfzBkNqrKofGdj0S+JBCrKAYan280c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hp85ENLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hp85ENLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048A4C4CED2;
	Thu, 30 Jan 2025 23:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280452;
	bh=hFsO9sOeblmnDNzQygKu1F26HRjUUPq9QZu7U4BTE3s=;
	h=Date:To:From:Subject:From;
	b=Hp85ENLeGm2nHxtthnYIkbcXFsBs47OwHeVtg0BFD2xUYH/9aGNcWPtv8TXPYVD2+
	 3/peaI3dtq480dk3sqGMllBJ2CnjGHBTh/qq9qgxWlGUyzW9NqK9AfsD6eEpv44WjV
	 F/eglpQ4zQCT7l3Noxr5V/BQyAXN9kQ0SdmJQ4F8=
Date: Thu, 30 Jan 2025 15:40:51 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio.patch added to mm-unstable branch
Message-Id: <20250130234052.048A4C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: use folio_set_dropbehind() instead of deactivate_file_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/truncate: use folio_set_dropbehind() instead of deactivate_file_folio()
Date: Thu, 30 Jan 2025 12:00:43 +0200

The recently introduced PG_dropbehind allows for freeing folios
immediately after writeback. Unlike PG_reclaim, it does not need vmscan
to be involved to get the folio freed.

The new flag allows to replace whole deactivate_file_folio() machinery
with simple folio_set_dropbehind().

Link: https://lkml.kernel.org/r/20250130100050.1868208-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: gehao <gehao@kylinos.cn>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 
 mm/swap.c     |   90 ------------------------------------------------
 mm/truncate.c |    5 ++
 3 files changed, 4 insertions(+), 92 deletions(-)

--- a/mm/internal.h~mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio
+++ a/mm/internal.h
@@ -379,7 +379,6 @@ static inline vm_fault_t vmf_anon_prepar
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
-void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
--- a/mm/swap.c~mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio
+++ a/mm/swap.c
@@ -54,7 +54,6 @@ struct cpu_fbatches {
 	 */
 	local_lock_t lock;
 	struct folio_batch lru_add;
-	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
 #ifdef CONFIG_SMP
@@ -524,68 +523,6 @@ void folio_add_lru_vma(struct folio *fol
 		folio_add_lru(folio);
 }
 
-/*
- * If the folio cannot be invalidated, it is moved to the
- * inactive list to speed up its reclaim.  It is moved to the
- * head of the list, rather than the tail, to give the flusher
- * threads some time to write it out, as this is much more
- * effective than the single-page writeout from reclaim.
- *
- * If the folio isn't mapped and dirty/writeback, the folio
- * could be reclaimed asap using the reclaim flag.
- *
- * 1. active, mapped folio -> none
- * 2. active, dirty/writeback folio -> inactive, head, reclaim
- * 3. inactive, mapped folio -> none
- * 4. inactive, dirty/writeback folio -> inactive, head, reclaim
- * 5. inactive, clean -> inactive, tail
- * 6. Others -> none
- *
- * In 4, it moves to the head of the inactive list so the folio is
- * written out by flusher threads as this is much more efficient
- * than the single-page writeout from reclaim.
- */
-static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
-{
-	bool active = folio_test_active(folio) || lru_gen_enabled();
-	long nr_pages = folio_nr_pages(folio);
-
-	if (folio_test_unevictable(folio))
-		return;
-
-	/* Some processes are using the folio */
-	if (folio_mapped(folio))
-		return;
-
-	lruvec_del_folio(lruvec, folio);
-	folio_clear_active(folio);
-	folio_clear_referenced(folio);
-
-	if (folio_test_writeback(folio) || folio_test_dirty(folio)) {
-		/*
-		 * Setting the reclaim flag could race with
-		 * folio_end_writeback() and confuse readahead.  But the
-		 * race window is _really_ small and  it's not a critical
-		 * problem.
-		 */
-		lruvec_add_folio(lruvec, folio);
-		folio_set_reclaim(folio);
-	} else {
-		/*
-		 * The folio's writeback ended while it was in the batch.
-		 * We move that folio to the tail of the inactive list.
-		 */
-		lruvec_add_folio_tail(lruvec, folio);
-		__count_vm_events(PGROTATED, nr_pages);
-	}
-
-	if (active) {
-		__count_vm_events(PGDEACTIVATE, nr_pages);
-		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
-				     nr_pages);
-	}
-}
-
 static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
@@ -652,10 +589,6 @@ void lru_add_drain_cpu(int cpu)
 		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
 	}
 
-	fbatch = &fbatches->lru_deactivate_file;
-	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_deactivate_file);
-
 	fbatch = &fbatches->lru_deactivate;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate);
@@ -667,28 +600,6 @@ void lru_add_drain_cpu(int cpu)
 	folio_activate_drain(cpu);
 }
 
-/**
- * deactivate_file_folio() - Deactivate a file folio.
- * @folio: Folio to deactivate.
- *
- * This function hints to the VM that @folio is a good reclaim candidate,
- * for example if its invalidation fails due to the folio being dirty
- * or under writeback.
- *
- * Context: Caller holds a reference on the folio.
- */
-void deactivate_file_folio(struct folio *folio)
-{
-	/* Deactivating an unevictable folio will not accelerate reclaim */
-	if (folio_test_unevictable(folio))
-		return;
-
-	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
-		return;
-
-	folio_batch_add_and_move(folio, lru_deactivate_file, true);
-}
-
 /*
  * folio_deactivate - deactivate a folio
  * @folio: folio to deactivate
@@ -772,7 +683,6 @@ static bool cpu_needs_drain(unsigned int
 	/* Check these in order of likelihood that they're not zero */
 	return folio_batch_count(&fbatches->lru_add) ||
 		folio_batch_count(&fbatches->lru_move_tail) ||
-		folio_batch_count(&fbatches->lru_deactivate_file) ||
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
 		folio_batch_count(&fbatches->lru_activate) ||
--- a/mm/truncate.c~mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio
+++ a/mm/truncate.c
@@ -486,7 +486,10 @@ unsigned long mapping_try_invalidate(str
 			 * of interest and try to speed up its reclaim.
 			 */
 			if (!ret) {
-				deactivate_file_folio(folio);
+				if (!folio_test_unevictable(folio) &&
+				    !folio_mapped(folio))
+					folio_set_dropbehind(folio);
+
 				/* Likely in the lru cache of a remote CPU */
 				if (nr_failed)
 					(*nr_failed)++;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-migrate-transfer-pg_dropbehind-to-the-new-folio.patch
drm-i915-gem-convert-__shmem_writeback-to-folios.patch
drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-zswap-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio.patch
mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list.patch
mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq.patch
mm-remove-pg_reclaim.patch
mm-vmscan-do-not-demote-pg_dropbehind-folios.patch
mm-rename-pg_dropbehind-to-pg_reclaim.patch


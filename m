Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A50E47781
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849584; cv=none; b=XIrcyRY63/iGCz0ui7eS1JPbQ4seNKuW/vGxCAxtEhHzNqQBUB1trozOTa3ZXM44YtMECxTgpKefWOYy1KT1U+zRYTHW2MJvDi10S6lcGehog0eh+V20mln3OcQMashWrymr1iRtT8lMsBQHeF12w1AA7KSfOIsCRWF9T3oiBtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849584; c=relaxed/simple;
	bh=fG8PsVRifbXgWnp4qkpQyMBRPLhYd/VjLvcF6scznEE=;
	h=Date:To:From:Subject:Message-Id; b=nMuwbbOF3/XmgXUeVXlLh3awQF8UPwHHnjMwXGGfSLy3N4t+v1XUkeS6XSxp+tLbnlsiVuoOCHJwFMakwuM+kbnk6NTFkpxuKbkeSUVehSMcwHexFED+CEp5m47Ykk5PpwPxbGaR3rPu1rqxpahGTEYNjy/zpxW/Cuii5p0CR8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AhQmdjBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AhQmdjBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7099C32781;
	Wed, 24 Jul 2024 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849583;
	bh=fG8PsVRifbXgWnp4qkpQyMBRPLhYd/VjLvcF6scznEE=;
	h=Date:To:From:Subject:From;
	b=AhQmdjBnRAzHLlSBDrkBKLmnhe7d5WtpGesZ2m+fb9jx36ToQK48KFv0rMlRIUL50
	 dDlvfXujyar3Jcqyz+JkoJdStt3r9Ndzl8FgPAkQwUOwXomAOvfjz6CPB4BQX+lhBX
	 nHY3AZ/I5uLlMxtDJwb3f7XuCXWKvyLoMn02CBU4=
Date: Wed, 24 Jul 2024 12:32:58 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-reduce-indentation-level.patch added to mm-unstable branch
Message-Id: <20240724193303.D7099C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: reduce indentation level
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-reduce-indentation-level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-reduce-indentation-level.patch

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
Subject: mm/swap: reduce indentation level
Date: Wed, 10 Jul 2024 20:13:13 -0600

Patch series "mm/swap: remove boilerplate".


Use folio_activate() as an example:

Before this series
------------------
    if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
      struct folio_batch *fbatch;

      folio_get(folio);
      if (!folio_test_clear_lru(folio)) {
        folio_put(folio);
        return;
      }

      local_lock(&cpu_fbatches.lock);
      fbatch = this_cpu_ptr(&cpu_fbatches.activate);
      folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
      local_unlock(&cpu_fbatches.lock);
    }
  }

After this series
-----------------
  void folio_activate(struct folio *folio)
  {
    if (folio_test_active(folio) || folio_test_unevictable(folio))
      return;
  
    folio_batch_add_and_move(folio, lru_activate, true);
  }

And this is applied to all 6 folio_batch handlers in mm/swap.c.

bloat-o-meter
-------------
  add/remove: 12/13 grow/shrink: 3/2 up/down: 4653/-4721 (-68)
  ...
  Total: Before=28083019, After=28082951, chg -0.00%


This patch (of 5):

Reduce indentation level by returning directly when there is no cleanup
needed, i.e.,

  if (condition) {    |    if (condition) {
    do_this();        |      do_this();
    return;           |      return;
  } else {            |    }
    do_that();        |
  }                   |    do_that();

and

  if (condition) {    |    if (!condition)
    do_this();        |      return;
    do_that();        |
  }                   |    do_this();
  return;             |    do_that();

Presumably the old style became repetitive as the result of copy and
paste.

Link: https://lkml.kernel.org/r/20240711021317.596178-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20240711021317.596178-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  209 +++++++++++++++++++++++++++-------------------------
 1 file changed, 109 insertions(+), 100 deletions(-)

--- a/mm/swap.c~mm-swap-reduce-indentation-level
+++ a/mm/swap.c
@@ -117,7 +117,9 @@ void __folio_put(struct folio *folio)
 	if (unlikely(folio_is_zone_device(folio))) {
 		free_zone_device_folio(folio);
 		return;
-	} else if (folio_test_hugetlb(folio)) {
+	}
+
+	if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
 	}
@@ -228,17 +230,19 @@ static void folio_batch_add_and_move(str
 	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
 	    !lru_cache_disabled())
 		return;
+
 	folio_batch_move_lru(fbatch, move_fn);
 }
 
 static void lru_move_tail_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_unevictable(folio)) {
-		lruvec_del_folio(lruvec, folio);
-		folio_clear_active(folio);
-		lruvec_add_folio_tail(lruvec, folio);
-		__count_vm_events(PGROTATED, folio_nr_pages(folio));
-	}
+	if (folio_test_unevictable(folio))
+		return;
+
+	lruvec_del_folio(lruvec, folio);
+	folio_clear_active(folio);
+	lruvec_add_folio_tail(lruvec, folio);
+	__count_vm_events(PGROTATED, folio_nr_pages(folio));
 }
 
 /*
@@ -250,22 +254,23 @@ static void lru_move_tail_fn(struct lruv
  */
 void folio_rotate_reclaimable(struct folio *folio)
 {
-	if (!folio_test_locked(folio) && !folio_test_dirty(folio) &&
-	    !folio_test_unevictable(folio)) {
-		struct folio_batch *fbatch;
-		unsigned long flags;
+	struct folio_batch *fbatch;
+	unsigned long flags;
 
-		folio_get(folio);
-		if (!folio_test_clear_lru(folio)) {
-			folio_put(folio);
-			return;
-		}
+	if (folio_test_locked(folio) || folio_test_dirty(folio) ||
+	    folio_test_unevictable(folio))
+		return;
 
-		local_lock_irqsave(&lru_rotate.lock, flags);
-		fbatch = this_cpu_ptr(&lru_rotate.fbatch);
-		folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
-		local_unlock_irqrestore(&lru_rotate.lock, flags);
+	folio_get(folio);
+	if (!folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
 	}
+
+	local_lock_irqsave(&lru_rotate.lock, flags);
+	fbatch = this_cpu_ptr(&lru_rotate.fbatch);
+	folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
+	local_unlock_irqrestore(&lru_rotate.lock, flags);
 }
 
 void lru_note_cost(struct lruvec *lruvec, bool file,
@@ -328,18 +333,19 @@ void lru_note_cost_refault(struct folio
 
 static void folio_activate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
-		long nr_pages = folio_nr_pages(folio);
+	long nr_pages = folio_nr_pages(folio);
 
-		lruvec_del_folio(lruvec, folio);
-		folio_set_active(folio);
-		lruvec_add_folio(lruvec, folio);
-		trace_mm_lru_activate(folio);
+	if (folio_test_active(folio) || folio_test_unevictable(folio))
+		return;
 
-		__count_vm_events(PGACTIVATE, nr_pages);
-		__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE,
-				     nr_pages);
-	}
+
+	lruvec_del_folio(lruvec, folio);
+	folio_set_active(folio);
+	lruvec_add_folio(lruvec, folio);
+	trace_mm_lru_activate(folio);
+
+	__count_vm_events(PGACTIVATE, nr_pages);
+	__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
 }
 
 #ifdef CONFIG_SMP
@@ -353,20 +359,21 @@ static void folio_activate_drain(int cpu
 
 void folio_activate(struct folio *folio)
 {
-	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
-		struct folio_batch *fbatch;
+	struct folio_batch *fbatch;
 
-		folio_get(folio);
-		if (!folio_test_clear_lru(folio)) {
-			folio_put(folio);
-			return;
-		}
+	if (folio_test_active(folio) || folio_test_unevictable(folio))
+		return;
 
-		local_lock(&cpu_fbatches.lock);
-		fbatch = this_cpu_ptr(&cpu_fbatches.activate);
-		folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
-		local_unlock(&cpu_fbatches.lock);
+	folio_get(folio);
+	if (!folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
 	}
+
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.activate);
+	folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
+	local_unlock(&cpu_fbatches.lock);
 }
 
 #else
@@ -378,12 +385,13 @@ void folio_activate(struct folio *folio)
 {
 	struct lruvec *lruvec;
 
-	if (folio_test_clear_lru(folio)) {
-		lruvec = folio_lruvec_lock_irq(folio);
-		folio_activate_fn(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
-		folio_set_lru(folio);
-	}
+	if (!folio_test_clear_lru(folio))
+		return;
+
+	lruvec = folio_lruvec_lock_irq(folio);
+	folio_activate_fn(lruvec, folio);
+	unlock_page_lruvec_irq(lruvec);
+	folio_set_lru(folio);
 }
 #endif
 
@@ -610,41 +618,41 @@ static void lru_deactivate_file_fn(struc
 
 static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_unevictable(folio) && (folio_test_active(folio) || lru_gen_enabled())) {
-		long nr_pages = folio_nr_pages(folio);
+	long nr_pages = folio_nr_pages(folio);
 
-		lruvec_del_folio(lruvec, folio);
-		folio_clear_active(folio);
-		folio_clear_referenced(folio);
-		lruvec_add_folio(lruvec, folio);
+	if (folio_test_unevictable(folio) || !(folio_test_active(folio) || lru_gen_enabled()))
+		return;
 
-		__count_vm_events(PGDEACTIVATE, nr_pages);
-		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
-				     nr_pages);
-	}
+	lruvec_del_folio(lruvec, folio);
+	folio_clear_active(folio);
+	folio_clear_referenced(folio);
+	lruvec_add_folio(lruvec, folio);
+
+	__count_vm_events(PGDEACTIVATE, nr_pages);
+	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 }
 
 static void lru_lazyfree_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-	    !folio_test_swapcache(folio) && !folio_test_unevictable(folio)) {
-		long nr_pages = folio_nr_pages(folio);
+	long nr_pages = folio_nr_pages(folio);
 
-		lruvec_del_folio(lruvec, folio);
-		folio_clear_active(folio);
-		folio_clear_referenced(folio);
-		/*
-		 * Lazyfree folios are clean anonymous folios.  They have
-		 * the swapbacked flag cleared, to distinguish them from normal
-		 * anonymous folios
-		 */
-		folio_clear_swapbacked(folio);
-		lruvec_add_folio(lruvec, folio);
+	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
+		return;
 
-		__count_vm_events(PGLAZYFREE, nr_pages);
-		__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE,
-				     nr_pages);
-	}
+	lruvec_del_folio(lruvec, folio);
+	folio_clear_active(folio);
+	folio_clear_referenced(folio);
+	/*
+	 * Lazyfree folios are clean anonymous folios.  They have
+	 * the swapbacked flag cleared, to distinguish them from normal
+	 * anonymous folios
+	 */
+	folio_clear_swapbacked(folio);
+	lruvec_add_folio(lruvec, folio);
+
+	__count_vm_events(PGLAZYFREE, nr_pages);
+	__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
 }
 
 /*
@@ -726,21 +734,21 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (!folio_test_unevictable(folio) && (folio_test_active(folio) ||
-	    lru_gen_enabled())) {
-		struct folio_batch *fbatch;
-
-		folio_get(folio);
-		if (!folio_test_clear_lru(folio)) {
-			folio_put(folio);
-			return;
-		}
+	struct folio_batch *fbatch;
+
+	if (folio_test_unevictable(folio) || !(folio_test_active(folio) || lru_gen_enabled()))
+		return;
 
-		local_lock(&cpu_fbatches.lock);
-		fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
-		folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
-		local_unlock(&cpu_fbatches.lock);
+	folio_get(folio);
+	if (!folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
 	}
+
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
+	folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
+	local_unlock(&cpu_fbatches.lock);
 }
 
 /**
@@ -752,21 +760,22 @@ void folio_deactivate(struct folio *foli
  */
 void folio_mark_lazyfree(struct folio *folio)
 {
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-	    !folio_test_swapcache(folio) && !folio_test_unevictable(folio)) {
-		struct folio_batch *fbatch;
-
-		folio_get(folio);
-		if (!folio_test_clear_lru(folio)) {
-			folio_put(folio);
-			return;
-		}
+	struct folio_batch *fbatch;
 
-		local_lock(&cpu_fbatches.lock);
-		fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
-		folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
-		local_unlock(&cpu_fbatches.lock);
+	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
+		return;
+
+	folio_get(folio);
+	if (!folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
 	}
+
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
+	folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
+	local_unlock(&cpu_fbatches.lock);
 }
 
 void lru_add_drain(void)
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch


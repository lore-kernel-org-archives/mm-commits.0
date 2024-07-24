Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888E16C686
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849586; cv=none; b=uSnVkku+l5MZbsanMbkToHTdFfsKbZQr4fX67seg61NdHYa4ecZ8r9qzTHzky7/Ql4G2nm2jwMmXO5P76/zT9aewg3hL5gxxewrI+VUAN8MTchifcupISeSsqw8FRW14wQxY9dFvwtC8KaJuJSx8BKmtR1YC9Z5UzdUwIiBdZqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849586; c=relaxed/simple;
	bh=KW74/wkG9/cAmaVlx7vbZO7SctuN1vTeER9sDC9OVE8=;
	h=Date:To:From:Subject:Message-Id; b=WqZ23cH75ceSkW14dLAqXfj5FiKz5JmhvU9BXFQKEByue4vLoIh8+FLuJo/Z5DetZk4iKzugPLa8JAt1Bffth6gu5PWAwKuQwKor1Eatu1saMb/DvXcnhtGZ/T11fIvLXhexMHFJZWaTAiWy+kGEM1F3EkDS+UyqXM028PiqSAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZfOiycr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZfOiycr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C82C32786;
	Wed, 24 Jul 2024 19:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849585;
	bh=KW74/wkG9/cAmaVlx7vbZO7SctuN1vTeER9sDC9OVE8=;
	h=Date:To:From:Subject:From;
	b=BZfOiycrpG92HB622AOjZ4uLS2exa/06DSQqzPpQOmuLmWy8ubqqr0r8r5/eA2k3o
	 0W+WIoZ0a2ThubYXYd1CugkNo4I8qb95TpLaNZsqPiSn//bzDDirUUSQlhPq/o3iLB
	 PHovVVzp0l5TE7Kbt0ccpUEwOz9U4B/FWEUT2BVI=
Date: Wed, 24 Jul 2024 12:33:05 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-cpu_fbatches-activate.patch added to mm-unstable branch
Message-Id: <20240724193305.D1C82C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: rename cpu_fbatches->activate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-rename-cpu_fbatches-activate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-cpu_fbatches-activate.patch

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

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch


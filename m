Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729A9421F11
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815914; cv=none; b=OCS2/h6cqmubtXWw4Rxh7lr7Pg9V5q7IJqSejeTKgf0BN7pMIYhVxR6hISqO9c4ZKz83wAVEpTOcJFlKqyrUcyYNXo7JyzZkMPyrpGZZWR/mtujfXUz9STpKW2j8vqi3nkG9kEe4xJUdcMVhtmjPDqFkiS4sphWvKYwXmkEJp6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815914; c=relaxed/simple;
	bh=Eck+ij5rXj5hSyjT8McfXF6hQkif9wJjPPF8y0TYWFU=;
	h=Date:To:From:Subject:Message-Id; b=hjj76m51bJGQCnl/Iapmu8o81anZuqS2Obzh1zVyWx1DGBR0oQMsrVxAvKMuk74hOXprdBaLYuFAHTOJjSsXg5ylxWhfJfu13oQ17EN1RvpKN4ZJP0tIJMGmN1dw6Oj2UEj/TG033uvey7s6GdfZSNt6xZ39UdRdfgwmSausSds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=trIbk/hs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="trIbk/hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B7A1F000E9;
	Tue, 26 May 2026 17:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779815910;
	bh=zEQ18al6yJEG7+uUI17BBu1fpIY8PrdGlL3+69fAaxk=;
	h=Date:To:From:Subject;
	b=trIbk/hsrCctxfi2Bo2xPM+q6K0ayN/bIKBUz3N8pXcGdu4k9mfKxTEwuLFos2pfe
	 M4S/FuUI5OpYCC8tB0EHpDwlMTRxFnYGER/43Xby0QVbTn4gopa7ATdBJwKuLLUxXJ
	 qudYndIupmJKFAhLiErCsoQJ8VG41rr1Hh3oozrY=
Date: Tue, 26 May 2026 10:18:29 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,willy@infradead.org,will@kernel.org,weixugc@google.com,wangzicheng@honor.com,surenb@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,pfalcato@suse.de,liulei.rjpt@vivo.com,lance.yang@linux.dev,kasong@tencent.com,kaleshsingh@google.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active.patch added to mm-unstable branch
Message-Id: <20260526171830.51B7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: use folio_mark_accessed to replace folio_set_active
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: use folio_mark_accessed to replace folio_set_active
Date: Tue, 26 May 2026 21:09:38 +0800

MGLRU gives high priority to folios mapped in page tables.  As a result,
folio_set_active() is invoked for all folios read during page faults.  In
practice, however, readahead can bring in many folios that are never
accessed via page tables.

A previous attempt by Lei Liu proposed introducing a separate LRU for
readahead[1] to make readahead pages easier to reclaim, but that approach
is likely over-engineered.

Before commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
folios with PG_active were always placed in the youngest generation,
leading to over-protection and increased refaults.  After that commit,
PG_active folios are placed in the second youngest generation, which is
still too optimistic given the presence of readahead.  In contrast, the
classic active/inactive scheme is more conservative.

This patch switches to using folio_mark_accessed() and
begins prefaulted file folios from the second oldest
generation instead of active generations.
We should also adjust the following accordingly:
- WORKINGSET_ACTIVATE: aligned with setting active for refaulted workingset
  folios;
- lru_gen_folio_seq(): place (pre)faulted file folios into the second
oldest generation;
- promote second-scanned folios to workingset in
folio_check_references(): we now have to depend on
folio_lru_refs() > 1, since we previously relied on PG_referenced
being set during the first scan, but PG_referenced is now set
earlier.

On x86, running a kernel build inside a memcg with a 1GB memory
limit using 20 threads.

w/o patch:
real	1m50.764s
user	25m32.305s
sys	4m0.012s
pswpin: 1333245
pswpout: 4366443
pgpgin: 6962592
pgpgout: 17780712
swpout_zero: 1019603
swpin_zero: 14764
refault_file: 287794
refault_anon: 1347963

w/ patch:
real	1m48.879s
user	25m29.224s
sys	3m37.421s
pswpin: 568480
pswpout: 2322657
pgpgin: 4073416
pgpgout: 9613408
swpout_zero: 593275
swpin_zero: 9118
refault_file: 262505
refault_anon: 577550

active/inactive LRU:

real	1m49.928s
user	25m28.196s
sys	3m40.740s
pswpin: 463452
pswpout: 2309119
pgpgin: 4438856
pgpgout: 9568628
swpout_zero: 743704
swpin_zero: 7244
refault_file: 562555
refault_anon: 470694

Lance and Xueyuan made a huge contribution to this patch through testing.

Link: https://lore.kernel.org/20260526130938.66253-1-baohua@kernel.org
Link: https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/ [1]
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 +-
 mm/swap.c                 |   16 +++++++++++++---
 mm/vmscan.c               |    6 +++++-
 mm/workingset.c           |   10 ++++++----
 4 files changed, 25 insertions(+), 9 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active
+++ a/include/linux/mm_inline.h
@@ -247,7 +247,7 @@ static inline unsigned long lru_gen_foli
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
 		gen = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - folio_test_workingset(folio);
+		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
--- a/mm/swap.c~mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active
+++ a/mm/swap.c
@@ -544,10 +544,20 @@ void folio_add_lru(struct folio *folio)
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	/* see the comment in lru_gen_folio_seq() */
+	/*
+	 * For refaulted workingset folios, set PG_active so they
+	 * can be added to active generations.
+	 * For prefaulted file folios, folio_mark_accessed() sets
+	 * PG_referenced so lru_gen_folio_seq() places them into
+	 * the second oldest generation.
+	 */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-		folio_set_active(folio);
+	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
+		if (folio_test_workingset(folio))
+			folio_set_active(folio);
+		else if (!folio_test_referenced(folio))
+			folio_mark_accessed(folio);
+	}
 
 	folio_batch_add_and_move(folio, lru_add);
 }
--- a/mm/vmscan.c~mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active
+++ a/mm/vmscan.c
@@ -848,7 +848,11 @@ static bool lru_gen_set_refs(struct foli
 		return false;
 	}
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+	/* Promote on second access */
+	if (folio_lru_refs(folio) > 1)
+		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+	else
+		folio_mark_accessed(folio);
 	return true;
 }
 #else
--- a/mm/workingset.c~mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active
+++ a/mm/workingset.c
@@ -319,11 +319,13 @@ static void lru_gen_refault(struct folio
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
-	/* see folio_add_lru() where folio_set_active() will be called */
-	if (lru_gen_in_fault())
-		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
-
 	if (workingset) {
+		/*
+		 * see folio_add_lru(), where folio_set_active() is
+		 * called for workingset folios
+		 */
+		if (lru_gen_in_fault())
+			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch
mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch
mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active.patch


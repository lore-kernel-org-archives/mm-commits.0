Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69645C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiBPAbn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:31:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245147AbiBPAap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35558FA214
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93FA3615FE
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8357C340EB;
        Wed, 16 Feb 2022 00:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971428;
        bh=rURNn1WWwtXpotLn2IXFyHoqdr71I6Hb1br1dkAp+ig=;
        h=Date:To:From:Subject:From;
        b=idSdOqy1JcLmovtaVIq3ZGGoEL0NMsy2dZET005Wj22ViveOQd6yK5WD36Cb/BF9a
         AkDCfpGD3qpovi4EpqtbcuK0XHs5mKpILB1Ya7yOoTHbLpdRKMYg0lrAmXHIrERt6X
         xiul+7FRaDp3PlzpwUhgqj8e5LcHzcavE3ufRhcI=
Date:   Tue, 15 Feb 2022 16:30:27 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch added to -mm tree
Message-Id: <20220216003027.E8357C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: delete smp_mb() from __pagevec_lru_add_fn()
has been added to the -mm tree.  Its filename is
     mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: delete smp_mb() from __pagevec_lru_add_fn()

My reading of comment on smp_mb__after_atomic() in __pagevec_lru_add_fn()
says that it can now be deleted; and that remains so when the next patch
is added.

Link: https://lkml.kernel.org/r/28a7c6ff-6270-9060-8df0-862bdcaac366@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

--- a/mm/swap.c~mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn
+++ a/mm/swap.c
@@ -1025,37 +1025,18 @@ static void __pagevec_lru_add_fn(struct
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
+	folio_set_lru(folio);
 	/*
-	 * A folio becomes evictable in two ways:
-	 * 1) Within LRU lock [munlock_vma_page() and __munlock_pagevec()].
-	 * 2) Before acquiring LRU lock to put the folio on the correct LRU
-	 *    and then
-	 *   a) do PageLRU check with lock [check_move_unevictable_pages]
-	 *   b) do PageLRU check before lock [clear_page_mlock]
-	 *
-	 * (1) & (2a) are ok as LRU lock will serialize them. For (2b), we need
-	 * following strict ordering:
-	 *
-	 * #0: __pagevec_lru_add_fn		#1: clear_page_mlock
-	 *
-	 * folio_set_lru()			folio_test_clear_mlocked()
-	 * smp_mb() // explicit ordering	// above provides strict
-	 *					// ordering
-	 * folio_test_mlocked()			folio_test_lru()
+	 * Is an smp_mb__after_atomic() still required here, before
+	 * folio_evictable() tests PageMlocked, to rule out the possibility
+	 * of stranding an evictable folio on an unevictable LRU?  I think
+	 * not, because munlock_page() only clears PageMlocked while the LRU
+	 * lock is held.
 	 *
-	 *
-	 * if '#1' does not observe setting of PG_lru by '#0' and
-	 * fails isolation, the explicit barrier will make sure that
-	 * folio_evictable check will put the folio on the correct
-	 * LRU. Without smp_mb(), folio_set_lru() can be reordered
-	 * after folio_test_mlocked() check and can make '#1' fail the
-	 * isolation of the folio whose mlocked bit is cleared (#0 is
-	 * also looking at the same folio) and the evictable folio will
-	 * be stranded on an unevictable LRU.
+	 * (That is not true of __page_cache_release(), and not necessarily
+	 * true of release_pages(): but those only clear PageMlocked after
+	 * put_page_testzero() has excluded any other users of the page.)
 	 */
-	folio_set_lru(folio);
-	smp_mb__after_atomic();
-
 	if (folio_evictable(folio)) {
 		if (was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch


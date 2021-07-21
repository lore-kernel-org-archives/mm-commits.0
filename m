Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0757FC6377A
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 22:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA4A61246
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 22:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhGUV12 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 17:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhGUV12 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 17:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4325361208;
        Wed, 21 Jul 2021 22:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626905283;
        bh=GjDrepHOVlSUQDjjs4bS7NYpuh1rJoi113eSQyiXumU=;
        h=Date:From:To:Subject:From;
        b=bid3GDpbEqkbCUrpn3FLSFDjGewyVwax7Z8gXB++Rq4uwrVD14/pvI6HWmkDeHlB1
         od9iheIPBX9OSYvn9b7kmrZgD2oMPXK1BO6GKlkXcVARcUDUqGxIS9qn6h1BqMZwKD
         73+Gsk9Vy7q/3ve2FPJHD/srXlD3H559dzEKgwzk=
Date:   Wed, 21 Jul 2021 15:08:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rjw@rjwysocki.net, pavel@ucw.cz,
        minchan@kernel.org, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        david@redhat.com, apopple@nvidia.com, alexs@kernel.org,
        evgreen@chromium.org
Subject:  + mm-enable-suspend-only-swap-spaces.patch added to -mm
 tree
Message-ID: <20210721220801.Rm26S%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable suspend-only swap spaces
has been added to the -mm tree.  Its filename is
     mm-enable-suspend-only-swap-spaces.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-enable-suspend-only-swap-spaces.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-enable-suspend-only-swap-spaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Evan Green <evgreen@chromium.org>
Subject: mm: enable suspend-only swap spaces

Currently it's not possible to enable hibernation without also enabling
generic swap for a given swap area.  These two use cases are not the same.
For example there may be users who want to enable hibernation, but whose
drives don't have the write endurance for generic swap activities.  Swap
and hibernate also have different security/integrity requirements,
prompting folks to possibly set up something like block-level integrity
for swap and image-level integrity for hibernate.  Keeping swap and
hibernate separate in these cases becomes not just a matter of preference,
but correctness.

Add a new SWAP_FLAG_NOSWAP that adds a swap region but refuses to allow
generic swapping to it.  This region can still be wired up for use in
suspend-to-disk activities, but will never have regular pages swapped to
it.  This flag will be passed in by utilities like swapon(8), usage would
probably look something like: swapon -o noswap /dev/sda2.

Swap regions with SWAP_FLAG_NOSWAP set will not appear in /proc/meminfo
under SwapTotal and SwapFree, since they are not usable as general swap.

Link: https://lkml.kernel.org/r/20210721143946.v3.1.I09866d90c6de14f21223a03e9e6a31f8a02ecbaf@changeid
Signed-off-by: Evan Green <evgreen@chromium.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Evan Green <evgreen@chromium.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++-
 mm/swapfile.c        |   52 +++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 16 deletions(-)

--- a/include/linux/swap.h~mm-enable-suspend-only-swap-spaces
+++ a/include/linux/swap.h
@@ -28,10 +28,11 @@ struct pagevec;
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
 #define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
 #define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
+#define SWAP_FLAG_NOSWAP	0x80000 /* use only for hibernate, not swap */
 
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
-				 SWAP_FLAG_DISCARD_PAGES)
+				 SWAP_FLAG_DISCARD_PAGES | SWAP_FLAG_NOSWAP)
 #define SWAP_BATCH 64
 
 static inline int current_is_kswapd(void)
@@ -182,6 +183,7 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
+	SWP_NOSWAP	= (1 << 13),	/* use only for suspend, not swap */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 14),	/* refcount in scan_swap_map */
 };
--- a/mm/swapfile.c~mm-enable-suspend-only-swap-spaces
+++ a/mm/swapfile.c
@@ -697,7 +697,8 @@ static void swap_range_alloc(struct swap
 	if (si->inuse_pages == si->pages) {
 		si->lowest_bit = si->max;
 		si->highest_bit = 0;
-		del_from_avail_list(si);
+		if (!(si->flags & SWP_NOSWAP))
+			del_from_avail_list(si);
 	}
 }
 
@@ -726,10 +727,12 @@ static void swap_range_free(struct swap_
 		bool was_full = !si->highest_bit;
 
 		WRITE_ONCE(si->highest_bit, end);
-		if (was_full && (si->flags & SWP_WRITEOK))
+		if (was_full &&
+		    ((si->flags & (SWP_WRITEOK | SWP_NOSWAP)) == SWP_WRITEOK))
 			add_to_avail_list(si);
 	}
-	atomic_long_add(nr_entries, &nr_swap_pages);
+	if (!(si->flags & SWP_NOSWAP))
+		atomic_long_add(nr_entries, &nr_swap_pages);
 	si->inuse_pages -= nr_entries;
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
@@ -1078,6 +1081,9 @@ start_over:
 			WARN(!(si->flags & SWP_WRITEOK),
 			     "swap_info %d in list but !SWP_WRITEOK\n",
 			     si->type);
+			WARN((si->flags & SWP_NOSWAP),
+			     "swap_info %d in list but SWP_NOSWAP\n",
+			     si->type);
 			__del_from_avail_list(si);
 			spin_unlock(&si->lock);
 			goto nextsi;
@@ -1338,8 +1344,12 @@ void swap_free(swp_entry_t entry)
 	struct swap_info_struct *p;
 
 	p = _swap_info_get(entry);
-	if (p)
-		__swap_entry_free(p, entry);
+	if (p) {
+		if (p->flags & SWP_NOSWAP)
+			swap_entry_free(p, entry);
+		else
+			__swap_entry_free(p, entry);
+	}
 }
 
 /*
@@ -1783,8 +1793,10 @@ swp_entry_t get_swap_page_of_type(int ty
 
 	/* This is called for allocating swap entry, not cache */
 	spin_lock(&si->lock);
-	if ((si->flags & SWP_WRITEOK) && scan_swap_map_slots(si, 1, 1, &entry))
-		atomic_long_dec(&nr_swap_pages);
+	if ((si->flags & SWP_WRITEOK) && scan_swap_map_slots(si, 1, 1, &entry)) {
+		if (!(si->flags & SWP_NOSWAP))
+			atomic_long_dec(&nr_swap_pages);
+	}
 	spin_unlock(&si->lock);
 fail:
 	return entry;
@@ -2454,8 +2466,6 @@ static void setup_swap_info(struct swap_
 static void _enable_swap_info(struct swap_info_struct *p)
 {
 	p->flags |= SWP_WRITEOK;
-	atomic_long_add(p->pages, &nr_swap_pages);
-	total_swap_pages += p->pages;
 
 	assert_spin_locked(&swap_lock);
 	/*
@@ -2469,7 +2479,11 @@ static void _enable_swap_info(struct swa
 	 * swap_info_struct.
 	 */
 	plist_add(&p->list, &swap_active_head);
-	add_to_avail_list(p);
+	if (!(p->flags & SWP_NOSWAP)) {
+		atomic_long_add(p->pages, &nr_swap_pages);
+		total_swap_pages += p->pages;
+		add_to_avail_list(p);
+	}
 }
 
 static void enable_swap_info(struct swap_info_struct *p, int prio,
@@ -2564,7 +2578,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-	del_from_avail_list(p);
+	if (!(p->flags & SWP_NOSWAP))
+		del_from_avail_list(p);
+
 	spin_lock(&p->lock);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
@@ -2581,8 +2597,10 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		least_priority++;
 	}
 	plist_del(&p->list, &swap_active_head);
-	atomic_long_sub(p->pages, &nr_swap_pages);
-	total_swap_pages -= p->pages;
+	if (!(p->flags & SWP_NOSWAP)) {
+		atomic_long_sub(p->pages, &nr_swap_pages);
+		total_swap_pages -= p->pages;
+	}
 	p->flags &= ~SWP_WRITEOK;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
@@ -3335,16 +3353,20 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio =
 		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
+
+	if (swap_flags & SWAP_FLAG_NOSWAP)
+		p->flags |= SWP_NOSWAP;
 	enable_swap_info(p, prio, swap_map, cluster_info, frontswap_map);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s%s\n",
+	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s%s%s\n",
 		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "",
 		(p->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(p->flags & SWP_PAGE_DISCARD) ? "c" : "",
-		(frontswap_map) ? "FS" : "");
+		(frontswap_map) ? "FS" : "",
+		(p->flags & SWP_NOSWAP) ? "N" : "");
 
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
_

Patches currently in -mm which might be from evgreen@chromium.org are

mm-enable-suspend-only-swap-spaces.patch


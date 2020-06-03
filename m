From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 086/131] mm: shmem: remove rare optimization when
 swapin races with hole punching
Date: Wed, 03 Jun 2020 16:01:34 -0700
Message-ID: <20200603230134.IaJjlfqVp%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgFCXIi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:38 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: shmem: remove rare optimization when swapin races with hole punching

Commit 215c02bc33bb ("tmpfs: fix shmem_getpage_gfp() VM_BUG_ON")
recognized that hole punching can race with swapin and removed the
BUG_ON() for a truncated entry from the swapin path.

The patch also added a swapcache deletion to optimize this rare case:
Since swapin has the page locked, and free_swap_and_cache() merely
trylocks, this situation can leave the page stranded in swapcache. 
Usually, page reclaim picks up stale swapcache pages, and the race can
happen at any other time when the page is locked.  (The same happens for
non-shmem swapin racing with page table zapping.) The thinking here was:
we already observed the race and we have the page locked, we may as well
do the cleanup instead of waiting for reclaim.

However, this optimization complicates the next patch which moves the
cgroup charging code around.  As this is just a minor speedup for a race
condition that is so rare that it required a fuzzer to trigger the
original BUG_ON(), it's no longer worth the complications.

Link: http://lkml.kernel.org/r/20200511181056.GA339505@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching
+++ a/mm/shmem.c
@@ -1665,27 +1665,16 @@ static int shmem_swapin_page(struct inod
 	}
 
 	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
-	if (!error) {
-		error = shmem_add_to_page_cache(page, mapping, index,
-						swp_to_radix_entry(swap), gfp);
-		/*
-		 * We already confirmed swap under page lock, and make
-		 * no memory allocation here, so usually no possibility
-		 * of error; but free_swap_and_cache() only trylocks a
-		 * page, so it is just possible that the entry has been
-		 * truncated or holepunched since swap was confirmed.
-		 * shmem_undo_range() will have done some of the
-		 * unaccounting, now delete_from_swap_cache() will do
-		 * the rest.
-		 */
-		if (error) {
-			mem_cgroup_cancel_charge(page, memcg);
-			delete_from_swap_cache(page);
-		}
-	}
 	if (error)
 		goto failed;
 
+	error = shmem_add_to_page_cache(page, mapping, index,
+					swp_to_radix_entry(swap), gfp);
+	if (error) {
+		mem_cgroup_cancel_charge(page, memcg);
+		goto failed;
+	}
+
 	mem_cgroup_commit_charge(page, memcg, true);
 
 	spin_lock_irq(&info->lock);
_

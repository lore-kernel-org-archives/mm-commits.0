From: akpm@linux-foundation.org
Subject: + mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch
 added to -mm tree
Date: Tue, 14 Jan 2014 16:15:46 -0800
Message-ID: <52d5d332.Ph1rSZyD6FeQ0AO+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOAPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 19:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com

Subject: + mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch added to -mm tree
To: hughd@google.com,hannes@cmpxchg.org,mhocko@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 16:15:46 -0800


The patch titled
     Subject: mm/memcg: iteration skip memcgs not yet fully initialized
has been added to the -mm tree.  Its filename is
     mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: iteration skip memcgs not yet fully initialized

It is surprising that the mem_cgroup iterator can return memcgs which have
not yet been fully initialized.  By accident (or trial and error?) this
appears not to present an actual problem; but it may be better to prevent
such surprises, by skipping memcgs not yet online.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized
+++ a/mm/memcontrol.c
@@ -1078,10 +1078,8 @@ skip_node:
 	 * protected by css_get and the tree walk is rcu safe.
 	 */
 	if (next_css) {
-		struct mem_cgroup *mem = mem_cgroup_from_css(next_css);
-
-		if (css_tryget(&mem->css))
-			return mem;
+		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
+			return mem_cgroup_from_css(next_css);
 		else {
 			prev_css = next_css;
 			goto skip_node;
_

Patches currently in -mm which might be from hughd@google.com are

mm-remove-bug_on-from-mlock_vma_page.patch
fsnotify-do-not-share-events-between-notification-groups-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-memcg-fix-last_dead_count-memory-wastage.patch
mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch


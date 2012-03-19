From: akpm@linux-foundation.org
Subject: + mm-forbid-lumpy-reclaim-in-shrink_active_list.patch added to -mm tree
Date: Mon, 19 Mar 2012 16:57:33 -0700
Message-ID: <20120319235733.D8000A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58269 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab2CSX5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 19:57:36 -0400
Received: by wgbdt11 with SMTP id dt11so43073wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 16:57:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: forbid lumpy-reclaim in shrink_active_list()
has been added to the -mm tree.  Its filename is
     mm-forbid-lumpy-reclaim-in-shrink_active_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: forbid lumpy-reclaim in shrink_active_list()

Reset the reclaim mode in shrink_active_list() to RECLAIM_MODE_SINGLE |
RECLAIM_MODE_ASYNC.  (sync/async sign is used only in shrink_page_list and
does not affect shrink_active_list)

Currenly shrink_active_list() sometimes works in lumpy-reclaim mode, if
RECLAIM_MODE_LUMPYRECLAIM is left over from an earlier
shrink_inactive_list().  Meanwhile, in age_active_anon() sc->reclaim_mode
is totally zero.  So the current behavior is too complex and confusing,
and this looks like bug.

In general, shrink_active_list() populates the inactive list for the next
shrink_inactive_list().  Lumpy shring_inactive_list() isolates pages
around the chosen one from both the active and inactive lists.  So, there
is no reason for lumpy isolation in shrink_active_list().

See also: https://lkml.org/lkml/2012/3/15/583

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Proposed-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-forbid-lumpy-reclaim-in-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~mm-forbid-lumpy-reclaim-in-shrink_active_list
+++ a/mm/vmscan.c
@@ -1690,6 +1690,8 @@ static void shrink_active_list(unsigned 
 
 	lru_add_drain();
 
+	reset_reclaim_mode(sc);
+
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
_
Subject: Subject: mm: forbid lumpy-reclaim in shrink_active_list()

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch
mm-forbid-lumpy-reclaim-in-shrink_active_list.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-kill-dead-prev_priority-stubs.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch


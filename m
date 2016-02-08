From: akpm@linux-foundation.org
Subject: + mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 15:02:07 -0800
Message-ID: <56b91e6f.psVnzVL67fHTUR2F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbcBHXCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 18:02:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kswapd: remove bogus check of balance_classzone_idx
has been added to the -mm tree.  Its filename is
     mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, kswapd: remove bogus check of balance_classzone_idx

During work on kcompactd integration I have spotted a confusing check of
balance_classzone_idx, which I believe is bogus.

The balanced_classzone_idx is filled by balance_pgdat() as the highest
zone it attempted to balance.  This was introduced by commit dc83edd941f4
("mm: kswapd: use the classzone idx that kswapd was using for
sleeping_prematurely()").  The intention is that (as expressed in today's
function names), the value used for kswapd_shrink_zone() calls in
balance_pgdat() is the same as for the decisions in kswapd_try_to_sleep().
An unwanted side-effect of that commit was breaking the checks in
kswapd() whether there was another kswapd_wakeup with a tighter (=lower)
classzone_idx.  Commits 215ddd6664ce ("mm: vmscan: only read
new_classzone_idx from pgdat when reclaiming successfully") and
d2ebd0f6b895 ("kswapd: avoid unnecessary rebalance after an unsuccessful
balancing") tried to fixed, but apparently introduced a bogus check that
this patch removes.

Consider zone indexes X < Y < Z, where:
- Z is the value used for the first kswapd wakeup.
- Y is returned as balanced_classzone_idx, which means zones with index higher
  than Y (including Z) were found to be unreclaimable.
- X is the value used for the second kswapd wakeup

The new wakeup with value X means that kswapd is now supposed to balance
harder all zones with index <= X.  But instead, due to Y < Z, it will go
sleep and won't read the new value X.  This is subtly wrong.

The effect of this patch is that kswapd will react better in some
situations, where e.g.  the first wakeup is for ZONE_DMA32, the second is
for ZONE_DMA, and due to unreclaimable ZONE_NORMAL.  Before this patch,
kswapd would go sleep instead of reclaiming ZONE_DMA harder.  I expect
these situations are very rare, and more value is in better
maintainability due to the removal of confusing and bogus check.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-kswapd-remove-bogus-check-of-balance_classzone_idx mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-remove-bogus-check-of-balance_classzone_idx
+++ a/mm/vmscan.c
@@ -3468,8 +3468,7 @@ static int kswapd(void *p)
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (balanced_classzone_idx >= new_classzone_idx &&
-					balanced_order == new_order) {
+		if (balanced_order == new_order) {
 			new_order = pgdat->kswapd_max_order;
 			new_classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order =  0;
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch
mm-use-radix_tree_iter_retry-fix.patch


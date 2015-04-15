From: akpm@linux-foundation.org
Subject: [merged] mm-clarify-__gfp_nofail-deprecation-status.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:04 -0700
Message-ID: <552eb7c8.NO6uUQo3NBDSsTXp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544AbbDOTLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify __GFP_NOFAIL deprecation status
has been removed from the -mm tree.  Its filename was
     mm-clarify-__gfp_nofail-deprecation-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: clarify __GFP_NOFAIL deprecation status

__GFP_NOFAIL is documented as a deprecated flag since 478352e789f5 (mm:
add comment about deprecation of __GFP_NOFAIL).  This has discouraged
people from using it but in some cases an opencoded endless loop around
allocator has been used instead.  So the allocator is not aware of the de
facto __GFP_NOFAIL allocation because this information was not
communicated properly.

Let's make clear that if the allocation context really cannot effort
failure because there is no good failure policy then using __GFP_NOFAIL is
preferable to opencoding the loop outside of the allocator.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vipul Pandya <vipul@chelsio.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-clarify-__gfp_nofail-deprecation-status include/linux/gfp.h
--- a/include/linux/gfp.h~mm-clarify-__gfp_nofail-deprecation-status
+++ a/include/linux/gfp.h
@@ -57,8 +57,10 @@ struct vm_area_struct;
  * _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.  This modifier is deprecated and no new
- * users should be added.
+ * cannot handle allocation failures. New users should be evaluated carefully
+ * (and the flag should be used only when there is no reasonable failure policy)
+ * but it is definitely preferable to use the flag rather than opencode endless
+ * loop around allocator.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely.
  *
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
memcg-zap-mem_cgroup_lookup.patch
memcg-remove-obsolete-comment.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-change-deactivate_page-with-deactivate_file_page.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch
mm-use-read_once-for-non-scalar-types.patch
mm-remove-rest-of-access_once-usages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
fork-report-pid-reservation-failure-properly.patch
linux-next.patch


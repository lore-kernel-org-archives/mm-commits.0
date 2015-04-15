From: akpm@linux-foundation.org
Subject: [merged] sparc-clarify-__gfp_nofail-allocation.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:07 -0700
Message-ID: <552eb7cb.XRLRTQJTeBYD+Qmc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbbDOTLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: clarify __GFP_NOFAIL allocation
has been removed from the -mm tree.  Its filename was
     sparc-clarify-__gfp_nofail-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: sparc: clarify __GFP_NOFAIL allocation

920c3ed74134 ([SPARC64]: Add basic infrastructure for MD add/remove
notification.) has added __GFP_NOFAIL for the allocation request but it
hasn't mentioned why is this strict requirement really needed.  The code
was handling an allocation failure and propagated it properly up the
callchain so it is not clear why it is needed.

Dave has clarified the intention when I tried to remove the flag as not
being necessary:

: It is a serious failure.
: 
: If we miss an MDESC update due to this allocation failure, the update
: is not an event which gets retransmitted so we will lose the updated
: machine description forever.
: 
: We really need this allocation to succeed.

So add a comment to clarify the nofail flag and get rid of the failure
check because __GFP_NOFAIL allocation doesn't fail.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
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

 arch/sparc/kernel/mdesc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/sparc/kernel/mdesc.c~sparc-clarify-__gfp_nofail-allocation arch/sparc/kernel/mdesc.c
--- a/arch/sparc/kernel/mdesc.c~sparc-clarify-__gfp_nofail-allocation
+++ a/arch/sparc/kernel/mdesc.c
@@ -130,26 +130,26 @@ static struct mdesc_mem_ops memblock_mde
 static struct mdesc_handle *mdesc_kmalloc(unsigned int mdesc_size)
 {
 	unsigned int handle_size;
+	struct mdesc_handle *hp;
+	unsigned long addr;
 	void *base;
 
 	handle_size = (sizeof(struct mdesc_handle) -
 		       sizeof(struct mdesc_hdr) +
 		       mdesc_size);
 
+	/*
+	 * Allocation has to succeed because mdesc update would be missed
+	 * and such events are not retransmitted.
+	 */
 	base = kmalloc(handle_size + 15, GFP_KERNEL | __GFP_NOFAIL);
-	if (base) {
-		struct mdesc_handle *hp;
-		unsigned long addr;
+	addr = (unsigned long)base;
+	addr = (addr + 15UL) & ~15UL;
+	hp = (struct mdesc_handle *) addr;
 
-		addr = (unsigned long)base;
-		addr = (addr + 15UL) & ~15UL;
-		hp = (struct mdesc_handle *) addr;
+	mdesc_handle_init(hp, handle_size, base);
 
-		mdesc_handle_init(hp, handle_size, base);
-		return hp;
-	}
-
-	return NULL;
+	return hp;
 }
 
 static void mdesc_kfree(struct mdesc_handle *hp)
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


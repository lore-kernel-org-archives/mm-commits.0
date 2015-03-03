From: akpm@linux-foundation.org
Subject: + sparc-clarify-__gfp_nofail-allocation.patch added to -mm tree
Date: Mon, 02 Mar 2015 16:17:06 -0800
Message-ID: <54f4fd82.LW53pXJabSGQ0aLk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbCCARI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: clarify __GFP_NOFAIL allocation
has been added to the -mm tree.  Its filename is
     sparc-clarify-__gfp_nofail-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-clarify-__gfp_nofail-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-clarify-__gfp_nofail-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
fork-report-pid-reservation-failure-properly.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
sparc-clarify-__gfp_nofail-allocation.patch
cxgb4-drop-__gfp_nofail-allocation.patch


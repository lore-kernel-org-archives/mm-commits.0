From: akpm@linux-foundation.org
Subject: + cxgb4-drop-__gfp_nofail-allocation.patch added to -mm tree
Date: Mon, 02 Mar 2015 16:17:08 -0800
Message-ID: <54f4fd84.AKmdg2zKxHfJTCnb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbCCARJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cxgb4: drop __GFP_NOFAIL allocation
has been added to the -mm tree.  Its filename is
     cxgb4-drop-__gfp_nofail-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cxgb4-drop-__gfp_nofail-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cxgb4-drop-__gfp_nofail-allocation.patch

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
Subject: cxgb4: drop __GFP_NOFAIL allocation

set_filter_wr is requesting __GFP_NOFAIL allocation although it can return
ENOMEM without any problems obviously (t4_l2t_set_switching does that
already).  So the non-failing requirement is too strong without any
obvious reason.  Drop __GFP_NOFAIL and reorganize the code to have the
failure paths easier.

The same applies to _c4iw_write_mem_dma_aligned which uses __GFP_NOFAIL
and then checks the return value and returns -ENOMEM on failure.  This
doesn't make any sense what so ever.  Either the allocation cannot fail or
it can.

del_filter_wr seems to be safe as well because the filter entry is not
marked as pending and the return value is propagated up the stack up to
c4iw_destroy_listen.

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

 drivers/infiniband/hw/cxgb4/mem.c               |    2 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   15 +++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/infiniband/hw/cxgb4/mem.c~cxgb4-drop-__gfp_nofail-allocation drivers/infiniband/hw/cxgb4/mem.c
--- a/drivers/infiniband/hw/cxgb4/mem.c~cxgb4-drop-__gfp_nofail-allocation
+++ a/drivers/infiniband/hw/cxgb4/mem.c
@@ -73,7 +73,7 @@ static int _c4iw_write_mem_dma_aligned(s
 		c4iw_init_wr_wait(&wr_wait);
 	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
 
-	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-drop-__gfp_nofail-allocation drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-drop-__gfp_nofail-allocation
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1121,6 +1121,10 @@ static int set_filter_wr(struct adapter
 	struct fw_filter_wr *fwr;
 	unsigned int ftid;
 
+	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
 	/* If the new filter requires loopback Destination MAC and/or VLAN
 	 * rewriting then we need to allocate a Layer 2 Table (L2T) entry for
 	 * the filter.
@@ -1128,19 +1132,21 @@ static int set_filter_wr(struct adapter
 	if (f->fs.newdmac || f->fs.newvlan) {
 		/* allocate L2T entry for new filter */
 		f->l2t = t4_l2t_alloc_switching(adapter->l2t);
-		if (f->l2t == NULL)
+		if (f->l2t == NULL) {
+			kfree(skb);
 			return -EAGAIN;
+		}
 		if (t4_l2t_set_switching(adapter, f->l2t, f->fs.vlan,
 					f->fs.eport, f->fs.dmac)) {
 			cxgb4_l2t_release(f->l2t);
 			f->l2t = NULL;
+			kfree(skb);
 			return -ENOMEM;
 		}
 	}
 
 	ftid = adapter->tids.ftid_base + fidx;
 
-	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL | __GFP_NOFAIL);
 	fwr = (struct fw_filter_wr *)__skb_put(skb, sizeof(*fwr));
 	memset(fwr, 0, sizeof(*fwr));
 
@@ -1238,7 +1244,10 @@ static int del_filter_wr(struct adapter
 	len = sizeof(*fwr);
 	ftid = adapter->tids.ftid_base + fidx;
 
-	skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
 	fwr = (struct fw_filter_wr *)__skb_put(skb, len);
 	t4_mk_filtdelwr(ftid, fwr, adapter->sge.fw_evtq.abs_id);
 
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


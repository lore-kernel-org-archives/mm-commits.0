From: akpm@linux-foundation.org
Subject: + cxgb4-drop-__gfp_nofail-allocation-fix.patch added to -mm tree
Date: Tue, 03 Mar 2015 12:13:47 -0800
Message-ID: <54f615fb.RrzuLAgwE5DZRJPf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbbCCUNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 15:13:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmotm: cxgb4-drop-__gfp_nofail-allocation-fix
has been added to the -mm tree.  Its filename is
     cxgb4-drop-__gfp_nofail-allocation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cxgb4-drop-__gfp_nofail-allocation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cxgb4-drop-__gfp_nofail-allocation-fix.patch

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
Subject: mmotm: cxgb4-drop-__gfp_nofail-allocation-fix

Use kfree_skb instead of kfree because the allocation is done by
alloc_skb.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vipul Pandya <vipul@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-drop-__gfp_nofail-allocation-fix drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-drop-__gfp_nofail-allocation-fix
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1133,14 +1133,14 @@ static int set_filter_wr(struct adapter
 		/* allocate L2T entry for new filter */
 		f->l2t = t4_l2t_alloc_switching(adapter->l2t);
 		if (f->l2t == NULL) {
-			kfree(skb);
+			kfree_skb(skb);
 			return -EAGAIN;
 		}
 		if (t4_l2t_set_switching(adapter, f->l2t, f->fs.vlan,
 					f->fs.eport, f->fs.dmac)) {
 			cxgb4_l2t_release(f->l2t);
 			f->l2t = NULL;
-			kfree(skb);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 	}
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
cxgb4-drop-__gfp_nofail-allocation.patch
cxgb4-drop-__gfp_nofail-allocation-fix.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
fork-report-pid-reservation-failure-properly.patch


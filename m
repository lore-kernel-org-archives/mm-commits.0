From: akpm@linux-foundation.org
Subject: [folded-merged] cxgb4-drop-__gfp_nofail-allocation-fix.patch
 removed from -mm tree
Date: Tue, 14 Apr 2015 13:23:48 -0700
Message-ID: <552d7754.dejK7/uwokD6DEqv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbbDNUXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 16:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hariprasad@chelsio.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mmotm: cxgb4-drop-__gfp_nofail-allocation-fix
has been removed from the -mm tree.  Its filename was
     cxgb4-drop-__gfp_nofail-allocation-fix.patch

This patch was dropped because it was folded into cxgb4-drop-__gfp_nofail-allocation.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mmotm: cxgb4-drop-__gfp_nofail-allocation-fix

Use kfree_skb instead of kfree because the allocation is done by
alloc_skb.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Hariprasad S <hariprasad@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-drop-__gfp_nofail-allocation-fix drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-drop-__gfp_nofail-allocation-fix
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1161,14 +1161,14 @@ static int set_filter_wr(struct adapter
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

mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch
cxgb4-drop-__gfp_nofail-allocation.patch


From: akpm@linux-foundation.org
Subject: + memcg-swap-cgroup-for-remembering-usage-fix-3.patch added to -mm tree
Date: Mon, 17 Nov 2008 10:14:44 -0800
Message-ID: <200811171814.mAHIEinN021194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbYKQSO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 13:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, xemul@openvz.org


The patch titled
     memcg: fix argument for kunmap_atomic
has been added to the -mm tree.  Its filename is
     memcg-swap-cgroup-for-remembering-usage-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix argument for kunmap_atomic
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

kunmap_atomic() should take kmapped address as argument.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-3 mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-3
+++ a/mm/page_cgroup.c
@@ -350,7 +350,7 @@ struct mem_cgroup *swap_cgroup_record(sw
 	sc += pos;
 	old = sc->val;
 	sc->val = mem;
-	kunmap_atomic(mappage, KM_USER0);
+	kunmap_atomic((void *)sc, KM_USER0);
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 	return old;
 }
@@ -384,7 +384,7 @@ struct mem_cgroup *lookup_swap_cgroup(sw
 	sc = kmap_atomic(mappage, KM_USER0);
 	sc += pos;
 	ret = sc->val;
-	kunmap_atomic(mappage, KM_USER0);
+	kunmap_atomic((void *)sc, KM_USER0);
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch


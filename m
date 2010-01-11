From: akpm@linux-foundation.org
Subject: + memcg-move-charges-of-anonymous-swap-fix.patch added to -mm tree
Date: Mon, 11 Jan 2010 15:44:25 -0800
Message-ID: <201001112344.o0BNiPjB003391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab0AKXok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 18:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, randy.dunlap@oracle.com


The patch titled
     memcg-move-charges-of-anonymous-swap-fix
has been added to the -mm tree.  Its filename is
     memcg-move-charges-of-anonymous-swap-fix.patch

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
Subject: memcg-move-charges-of-anonymous-swap-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

build fix in !CONFIG_SWAP case.

  CC      mm/memcontrol.o
mm/memcontrol.c: In function 'is_target_pte_for_mc':
mm/memcontrol.c:3648: error: implicit declaration of function 'mem_cgroup_count_swap_user'
make[1]: *** [mm/memcontrol.o] Error 1
make: *** [mm] Error 2

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/swap.h~memcg-move-charges-of-anonymous-swap-fix include/linux/swap.h
--- a/include/linux/swap.h~memcg-move-charges-of-anonymous-swap-fix
+++ a/include/linux/swap.h
@@ -488,6 +488,14 @@ mem_cgroup_uncharge_swapcache(struct pag
 {
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+static inline int
+mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep)
+{
+	return 0;
+}
+#endif
+
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch


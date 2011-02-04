From: akpm@linux-foundation.org
Subject: + memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch added to -mm tree
Date: Fri, 04 Feb 2011 13:08:38 -0800
Message-ID: <201102042108.p14L8doV019035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1BDVIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Feb 2011 16:08:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update
has been added to the -mm tree.  Its filename is
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch

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
Subject: memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

try to show the path name of the cgroup too

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update
+++ a/mm/memcontrol.c
@@ -3044,9 +3044,25 @@ void mem_cgroup_print_bad_page(struct pa
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup_used(page);
-	if (pc)
-		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p\n",
+	if (pc) {
+		int ret = -1;
+		char *path;
+
+		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p",
 		       pc, pc->flags, pc->mem_cgroup);
+
+		path = kmalloc(PATH_MAX, GFP_KERNEL);
+		if (path) {
+			rcu_read_lock();
+			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
+							path, PATH_MAX);
+			rcu_read_unlock();
+		}
+
+		printk(KERN_ALERT "(%s)\n",
+				(ret < 0) ? "cannot get the path" : path);
+		kfree(path);
+	}
 }
 #endif
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch


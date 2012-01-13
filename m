From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-mem_cgroup_print_bad_page.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:39 -0800
Message-ID: <20120113203540.1C80A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40171 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab2AMUfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:42 -0500
Received: by wgbdt14 with SMTP id dt14so106252wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix mem_cgroup_print_bad_page
has been removed from the -mm tree.  Its filename was
     memcg-fix-mem_cgroup_print_bad_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix mem_cgroup_print_bad_page

If DEBUG_VM, mem_cgroup_print_bad_page() is called whenever bad_page()
shows a "Bad page state" message, removes page from circulation, adds a
taint and continues.  This is at a very low level, often when a spinlock
is held (sometimes when page table lock is held, for example).

We want to recover from this badness, not make it worse: we must not
kmalloc memory here, we must not do a cgroup path lookup via dubious
pointers.  No doubt that code was useful to debug a particular case at one
time, and may be again, but take it out of the mainline kernel.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-mem_cgroup_print_bad_page mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mem_cgroup_print_bad_page
+++ a/mm/memcontrol.c
@@ -3364,23 +3364,8 @@ void mem_cgroup_print_bad_page(struct pa
 
 	pc = lookup_page_cgroup_used(page);
 	if (pc) {
-		int ret = -1;
-		char *path;
-
-		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p",
+		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
 		       pc, pc->flags, pc->mem_cgroup);
-
-		path = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (path) {
-			rcu_read_lock();
-			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
-							path, PATH_MAX);
-			rcu_read_unlock();
-		}

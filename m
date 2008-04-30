From: akpm@linux-foundation.org
Subject: - memcgroup-make-the-memory-controller-more-desktop-responsive.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:11 -0700
Message-ID: <200804300543.m3U5hB4b029299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760692AbYD3GMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, menage@google.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcgroup: make the memory controller more desktop responsive
has been removed from the -mm tree.  Its filename was
     memcgroup-make-the-memory-controller-more-desktop-responsive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: make the memory controller more desktop responsive
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch makes the memory controller more responsive on my desktop.

1. Set all cached pages as inactive.  We were by default marking all pages
   as active, thus forcing us to go through two passes for reclaiming pages

2. Remove congestion_wait(), since we already have that logic in
   do_try_to_free_pages()

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-make-the-memory-controller-more-desktop-responsive mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-make-the-memory-controller-more-desktop-responsive
+++ a/mm/memcontrol.c
@@ -591,7 +591,6 @@ retry:
 			mem_cgroup_out_of_memory(mem, gfp_mask);
 			goto out;
 		}
-		congestion_wait(WRITE, HZ/10);
 	}
 
 	pc->ref_cnt = 1;
@@ -599,7 +598,7 @@ retry:
 	pc->page = page;
 	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
-		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
+		pc->flags = PAGE_CGROUP_FLAG_CACHE;
 
 	lock_page_cgroup(page);
 	if (page_get_page_cgroup(page)) {
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
git-kvm.patch


From: akpm@linux-foundation.org
Subject: + memcgroup-make-the-memory-controller-more-desktop-responsive.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:09:42 -0700
Message-ID: <200804080309.m3839g1Z005460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYDHDK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, menage@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcgroup: make the memory controller more desktop responsive
has been added to the -mm tree.  Its filename is
     memcgroup-make-the-memory-controller-more-desktop-responsive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -604,7 +604,6 @@ retry:
 			mem_cgroup_out_of_memory(mem, gfp_mask);
 			goto out;
 		}
-		congestion_wait(WRITE, HZ/10);
 	}
 
 	pc->ref_cnt = 1;
@@ -612,7 +611,7 @@ retry:
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
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch


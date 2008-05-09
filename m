From: akpm@linux-foundation.org
Subject: + memcg-avoid-unnecessary-initialization.patch added to -mm tree
Date: Fri, 09 May 2008 14:16:22 -0700
Message-ID: <200805092116.m49LGMog026021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbYEIVWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com


The patch titled
     memcg: avoid unnecessary initialization
has been added to the -mm tree.  Its filename is
     memcg-avoid-unnecessary-initialization.patch

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
Subject: memcg: avoid unnecessary initialization
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

* remove over-killing initialization (in fast path)
* makeing the condition for PAGE_CGROUP_FLAG_ACTIVE be more obvious.

Signed-off-by: KAMEAZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-unnecessary-initialization mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-unnecessary-initialization
+++ a/mm/memcontrol.c
@@ -296,7 +296,7 @@ static void __mem_cgroup_remove_list(str
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
 
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, false);
-	list_del_init(&pc->lru);
+	list_del(&pc->lru);
 }
 
 static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
@@ -559,7 +559,7 @@ retry:
 	}
 	unlock_page_cgroup(page);
 
-	pc = kmem_cache_zalloc(page_cgroup_cache, gfp_mask);
+	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (pc == NULL)
 		goto err;
 
@@ -606,9 +606,14 @@ retry:
 	pc->ref_cnt = 1;
 	pc->mem_cgroup = mem;
 	pc->page = page;
-	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
+	/*
+	 * If a page is accounted as a page cache, insert to inactive list.
+	 * If anon, insert to active list.
+	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags = PAGE_CGROUP_FLAG_CACHE;
+	else
+		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 
 	lock_page_cgroup(page);
 	if (page_get_page_cgroup(page)) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-possible-panic-when-config_mm_owner=y.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
cgroups-fix-documentation.patch
memory-hotplug-memmap_init_zone-called-twice.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-avoid-unnecessary-initialization.patch


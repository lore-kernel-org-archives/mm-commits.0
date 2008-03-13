From: akpm@linux-foundation.org
Subject: + memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:58:30 -0700
Message-ID: <200803132158.m2DLwUpZ002439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbYCMV7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcgroup: move memory controller allocations to their own slabs
has been added to the -mm tree.  Its filename is
     memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch

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
Subject: memcgroup: move memory controller allocations to their own slabs
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Move the memory controller data structure page_cgroup to its own slab cache. 
It saves space on the system, allocations are not necessarily pushed to order
of 2 and should provide performance benefits.  Users who disable the memory
controller can also double check that the memory controller is not allocating
page_cgroup's.

NOTE: Hugh Dickins brought up the issue of whether we want to mark page_cgroup
as __GFP_MOVABLE or __GFP_RECLAIMABLE.  I don't think there is an easy answer
at the moment.  page_cgroup's are associated with user pages, they can be
reclaimed once the user page has been reclaimed, so it might make sense to
mark them as __GFP_RECLAIMABLE.  For now, I am leaving the marking to default
values that the slab allocator uses.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-move-memory-controller-allocations-to-their-own-slabs mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-move-memory-controller-allocations-to-their-own-slabs
+++ a/mm/memcontrol.c
@@ -26,6 +26,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
@@ -35,6 +36,7 @@
 
 struct cgroup_subsys mem_cgroup_subsys;
 static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
+static struct kmem_cache *page_cgroup_cache;
 
 /*
  * Statistics for memory cgroup.
@@ -560,7 +562,7 @@ retry:
 	}
 	unlock_page_cgroup(page);
 
-	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
+	pc = kmem_cache_zalloc(page_cgroup_cache, gfp_mask);
 	if (pc == NULL)
 		goto err;
 
@@ -622,7 +624,7 @@ retry:
 		 */
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
-		kfree(pc);
+		kmem_cache_free(page_cgroup_cache, pc);
 		goto retry;
 	}
 	page_assign_page_cgroup(page, pc);
@@ -637,7 +639,7 @@ done:
 	return 0;
 out:
 	css_put(&mem->css);
-	kfree(pc);
+	kmem_cache_free(page_cgroup_cache, pc);
 err:
 	return -ENOMEM;
 }
@@ -695,7 +697,7 @@ void mem_cgroup_uncharge_page(struct pag
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 
-		kfree(pc);
+		kmem_cache_free(page_cgroup_cache, pc);
 		return;
 	}
 
@@ -1006,6 +1008,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (unlikely((cont->parent) == NULL)) {
 		mem = &init_mem_cgroup;
 		init_mm.mem_cgroup = mem;
+		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
 	} else
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

git-kvm.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch


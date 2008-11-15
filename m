From: akpm@linux-foundation.org
Subject: + memcg-memory-hotplug-fix-for-notifier-callback.patch added to -mm tree
Date: Fri, 14 Nov 2008 17:06:23 -0800
Message-ID: <200811150106.mAF16NnV006462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbYKOBGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 20:06:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, xemul@openvz.org


The patch titled
     memcg: memory hotplug fix for notifier callback
has been added to the -mm tree.  Its filename is
     memcg-memory-hotplug-fix-for-notifier-callback.patch

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
Subject: memcg: memory hotplug fix for notifier callback
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fixes for memcg/memory hotplug.

While memory hotplug allocate/free memmap, page_cgroup doesn't free
page_cgroup at OFFLINE when page_cgroup is allocated via bootomem. 
(Because freeing bootmem requires special care.)

Then, if page_cgroup is allocated by bootmem and memmap is freed/allocated
by memory hotplug, page_cgroup->page == page is no longer true.

But current MEM_ONLINE handler doesn't check it and update
page_cgroup->page if it's not necessary to allocate page_cgroup.  (This
was not found because memmap is not freed if SPARSEMEM_VMEMMAP is y.)

And I noticed that MEM_ONLINE can be called against "part of section". 
So, freeing page_cgroup at CANCEL_ONLINE will cause trouble.  (freeing
used page_cgroup) Don't rollback at CANCEL.

One more, current memory hotplug notifier is stopped by slub because it
sets NOTIFY_STOP_MASK to return vaule.  So, page_cgroup's callback never
be called.  (low priority than slub now.)

I think this slub's behavior is not intentional(BUG). and fixes it.

Another way to be considered about page_cgroup allocation:
  - free page_cgroup at OFFLINE even if it's from bootmem
    and remove specieal handler. But it requires more changes.

Signed-off-by: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   43 +++++++++++++++++++++++++++++--------------
 mm/slub.c        |    6 ++++--
 2 files changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/page_cgroup.c~memcg-memory-hotplug-fix-for-notifier-callback mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-memory-hotplug-fix-for-notifier-callback
+++ a/mm/page_cgroup.c
@@ -104,19 +104,29 @@ int __meminit init_section_page_cgroup(u
 	unsigned long table_size;
 	int nid, index;
 
-	if (section->page_cgroup)
-		return 0;
-
-	nid = page_to_nid(pfn_to_page(pfn));
-
-	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-	if (slab_is_available()) {
-		base = kmalloc_node(table_size, GFP_KERNEL, nid);
-		if (!base)
-			base = vmalloc_node(table_size, nid);
-	} else {
-		base = __alloc_bootmem_node_nopanic(NODE_DATA(nid), table_size,
+	if (!section->page_cgroup) {
+		nid = page_to_nid(pfn_to_page(pfn));
+		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+		if (slab_is_available()) {
+			base = kmalloc_node(table_size, GFP_KERNEL, nid);
+			if (!base)
+				base = vmalloc_node(table_size, nid);
+		} else {
+			base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
+				table_size,
 				PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+		}
+	} else {
+		/*
+ 		 * We don't have to allocate page_cgroup again, but
+		 * address of memmap may be changed. So, we have to initialize
+		 * again.
+		 */
+		base = section->page_cgroup + pfn;
+		table_size = 0;
+		/* check address of memmap is changed or not. */
+		if (base->page == pfn_to_page(pfn))
+			return 0;
 	}
 
 	if (!base) {
@@ -204,18 +214,23 @@ static int page_cgroup_callback(struct n
 		ret = online_page_cgroup(mn->start_pfn,
 				   mn->nr_pages, mn->status_change_nid);
 		break;
-	case MEM_CANCEL_ONLINE:
 	case MEM_OFFLINE:
 		offline_page_cgroup(mn->start_pfn,
 				mn->nr_pages, mn->status_change_nid);
 		break;
+	case MEM_CANCEL_ONLINE:
 	case MEM_GOING_OFFLINE:
 		break;
 	case MEM_ONLINE:
 	case MEM_CANCEL_OFFLINE:
 		break;
 	}
-	ret = notifier_from_errno(ret);
+
+	if (ret)
+		ret = notifier_from_errno(ret);
+	else
+		ret = NOTIFY_OK;
+
 	return ret;
 }
 
diff -puN mm/slub.c~memcg-memory-hotplug-fix-for-notifier-callback mm/slub.c
--- a/mm/slub.c~memcg-memory-hotplug-fix-for-notifier-callback
+++ a/mm/slub.c
@@ -3220,8 +3220,10 @@ static int slab_memory_callback(struct n
 	case MEM_CANCEL_OFFLINE:
 		break;
 	}
-
-	ret = notifier_from_errno(ret);
+	if (ret)
+		ret = notifier_from_errno(ret);
+	else
+		ret = NOTIFY_OK;
 	return ret;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
migration-fix-writepage-error.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-memswap-controller-core.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch


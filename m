From: akpm@linux-foundation.org
Subject: [folded-merged] resource-add-release_mem_region_adjustable-fix-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:51:55 -0700
Message-ID: <20130429215155.BC00331C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56265 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D2Vv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:51:57 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so477694vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:51:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, toshi.kani@hp.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: resource-add-release_mem_region_adjustable-fix-fix
has been removed from the -mm tree.  Its filename was
     resource-add-release_mem_region_adjustable-fix-fix.patch

This patch was dropped because it was folded into resource-add-release_mem_region_adjustable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: resource-add-release_mem_region_adjustable-fix-fix

switch back to GFP_KERNEL, less buggily

Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix kernel/resource.c
--- a/kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix
+++ a/kernel/resource.c
@@ -1046,7 +1046,8 @@ int release_mem_region_adjustable(struct
 			resource_size_t start, resource_size_t size)
 {
 	struct resource **p;
-	struct resource *res, *new;
+	struct resource *res;
+	struct resource *new_res;
 	resource_size_t end;
 	int ret = -EINVAL;
 
@@ -1054,6 +1055,9 @@ int release_mem_region_adjustable(struct
 	if ((start < parent->start) || (end > parent->end))
 		return ret;
 
+	/* The kzalloc() result gets checked later */
+	new_res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+
 	p = &parent->child;
 	write_lock(&resource_lock);
 
@@ -1091,32 +1095,33 @@ int release_mem_region_adjustable(struct
 						start - res->start);
 		} else {
 			/* split into two entries */
-			new = kzalloc(sizeof(struct resource), GFP_ATOMIC);
-			if (!new) {
+			if (!new_res) {
 				ret = -ENOMEM;
 				break;
 			}
-			new->name = res->name;
-			new->start = end + 1;
-			new->end = res->end;
-			new->flags = res->flags;
-			new->parent = res->parent;
-			new->sibling = res->sibling;
-			new->child = NULL;
+			new_res->name = res->name;
+			new_res->start = end + 1;
+			new_res->end = res->end;
+			new_res->flags = res->flags;
+			new_res->parent = res->parent;
+			new_res->sibling = res->sibling;
+			new_res->child = NULL;
 
 			ret = __adjust_resource(res, res->start,
 						start - res->start);
 			if (ret) {
-				kfree(new);
+				kfree(new_res);
 				break;
 			}
-			res->sibling = new;
+			res->sibling = new_res;
+			new_res = NULL;
 		}
 
 		break;
 	}
 
 	write_unlock(&resource_lock);
+	kfree(new_res);
 	return ret;
 }
 #endif	/* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch


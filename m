From: akpm@linux-foundation.org
Subject: [folded-merged] resource-add-release_mem_region_adjustable-fix-fix-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:51:58 -0700
Message-ID: <20130429215158.BE38431C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59855 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D2VwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:52:00 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so580903yhz.5
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:51:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, toshi.kani@hp.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: resource-add-release_mem_region_adjustable-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     resource-add-release_mem_region_adjustable-fix-fix-fix.patch

This patch was dropped because it was folded into resource-add-release_mem_region_adjustable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: resource-add-release_mem_region_adjustable-fix-fix-fix

remove unneeded and wrong kfree(), per Toshi

Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix-fix kernel/resource.c
--- a/kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix-fix
+++ a/kernel/resource.c
@@ -1109,10 +1109,8 @@ int release_mem_region_adjustable(struct
 
 			ret = __adjust_resource(res, res->start,
 						start - res->start);
-			if (ret) {
-				kfree(new_res);
+			if (ret)
 				break;
-			}
 			res->sibling = new_res;
 			new_res = NULL;
 		}
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
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch


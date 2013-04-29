From: akpm@linux-foundation.org
Subject: [folded-merged] mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:56:45 -0700
Message-ID: <20130429215645.EED1C31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36189 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3D2V4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:56:47 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so714635ggm.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:56:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, isimatu.yasuaki@jp.fujitsu.com, linuxram@us.ibm.com, rientjes@google.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotunplug-fix-kfree-of-bootmem-memory-fix
has been removed from the -mm tree.  Its filename was
     mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

This patch was dropped because it was folded into mem-hotunplug-fix-kfree-of-bootmem-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mem-hotunplug-fix-kfree-of-bootmem-memory-fix

s/get_resource/alloc_resource/

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/resource.c~mem-hotunplug-fix-kfree-of-bootmem-memory-fix kernel/resource.c
--- a/kernel/resource.c~mem-hotunplug-fix-kfree-of-bootmem-memory-fix
+++ a/kernel/resource.c
@@ -175,7 +175,7 @@ static void free_resource(struct resourc
 	}
 }
 
-static struct resource *get_resource(gfp_t flags)
+static struct resource *alloc_resource(gfp_t flags)
 {
 	struct resource *res = NULL;
 
@@ -814,7 +814,7 @@ static void __init __reserve_region_with
 {
 	struct resource *parent = root;
 	struct resource *conflict;
-	struct resource *res = get_resource(GFP_ATOMIC);
+	struct resource *res = alloc_resource(GFP_ATOMIC);
 	struct resource *next_res = NULL;
 
 	if (!res)
@@ -849,7 +849,7 @@ static void __init __reserve_region_with
 			end = res->end;
 			res->end = conflict->start - 1;
 			if (conflict->end < end) {
-				next_res = get_resource(GFP_ATOMIC);
+				next_res = alloc_resource(GFP_ATOMIC);
 				if (!next_res) {
 					free_resource(res);
 					break;
@@ -941,7 +941,7 @@ struct resource * __request_region(struc
 				   const char *name, int flags)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	struct resource *res = get_resource(GFP_KERNEL);
+	struct resource *res = alloc_resource(GFP_KERNEL);
 
 	if (!res)
 		return NULL;
@@ -1097,8 +1097,8 @@ int release_mem_region_adjustable(struct
 	if ((start < parent->start) || (end > parent->end))
 		return ret;
 
-	/* The get_resource() result gets checked later */
-	new_res = get_resource(GFP_KERNEL);
+	/* The alloc_resource() result gets checked later */
+	new_res = alloc_resource(GFP_KERNEL);
 
 	p = &parent->child;
 	write_lock(&resource_lock);
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
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration.patch
memcg-add-memorypressure_level-events.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io.patch
mem-hotunplug-fix-kfree-of-bootmem-memory.patch


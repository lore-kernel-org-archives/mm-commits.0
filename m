From: akpm@linux-foundation.org
Subject: [folded-merged] auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:41:26 -0700
Message-ID: <20130429214126.D70A531C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61240 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3D2Vl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:41:28 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so711926qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:41:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eparis@redhat.com, rakib.mullick@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: auditsc-use-kzalloc-instead-of-kmallocmemset-fix
has been removed from the -mm tree.  Its filename was
     auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch

This patch was dropped because it was folded into auditsc-use-kzalloc-instead-of-kmallocmemset.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: auditsc-use-kzalloc-instead-of-kmallocmemset-fix

remove audit_set_context() altogether - fold it into its caller

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset-fix kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset-fix
+++ a/kernel/auditsc.c
@@ -1034,13 +1034,6 @@ static inline void audit_free_aux(struct
 	}
 }
 
-static inline void audit_set_context(struct audit_context *context,
-				      enum audit_state state)
-{
-	context->state      = state;
-	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
-}
-
 static inline struct audit_context *audit_alloc_context(enum audit_state state)
 {
 	struct audit_context *context;
@@ -1048,7 +1041,8 @@ static inline struct audit_context *audi
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return NULL;
-	audit_set_context(context, state);
+	context->state = state;
+	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 	INIT_LIST_HEAD(&context->killed_trees);
 	INIT_LIST_HEAD(&context->names_list);
 	return context;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
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


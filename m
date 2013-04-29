From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:41:51 -0700
Message-ID: <20130429214151.8407D31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50831 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab3D2Vlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:41:53 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so427774vcb.4
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:41:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eparis@redhat.com, gang.chen@asianux.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix
has been removed from the -mm tree.  Its filename was
     kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch

This patch was dropped because it was folded into kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix

run put_tree() *before* mutex_lock()

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/audit_tree.c~kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix kernel/audit_tree.c
--- a/kernel/audit_tree.c~kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix
+++ a/kernel/audit_tree.c
@@ -619,8 +619,8 @@ void audit_trim_trees(void)
 		trim_marked(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
-		mutex_lock(&audit_filter_mutex);
 		put_tree(tree);
+		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
 	mutex_unlock(&audit_filter_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
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


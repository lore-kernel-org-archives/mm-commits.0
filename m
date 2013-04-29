From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-add-memorypressure_level-events-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:54:22 -0700
Message-ID: <20130429215422.A7D7B31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43093 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab3D2VyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:54:23 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so273848yen.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:54:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton.vorontsov@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-memorypressure_level-events-fix
has been removed from the -mm tree.  Its filename was
     memcg-add-memorypressure_level-events-fix.patch

This patch was dropped because it was folded into memcg-add-memorypressure_level-events.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-add-memorypressure_level-events-fix

fix CONFIG_CGROPUPS=n warnings:

In file included from mm/vmscan.c:22:
include/linux/vmpressure.h:44: warning: 'struct cftype' declared inside parameter list
include/linux/vmpressure.h:44: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/vmpressure.h:44: warning: 'struct cgroup' declared inside parameter list
include/linux/vmpressure.h:46: warning: 'struct cftype' declared inside parameter list
include/linux/vmpressure.h:46: warning: 'struct cgroup' declared inside parameter list

Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN include/linux/vmpressure.h~memcg-add-memorypressure_level-events-fix include/linux/vmpressure.h
--- a/include/linux/vmpressure.h~memcg-add-memorypressure_level-events-fix
+++ a/include/linux/vmpressure.h
@@ -28,12 +28,6 @@ struct mem_cgroup;
 extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 		       unsigned long scanned, unsigned long reclaimed);
 extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
-#else
-static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
-			      unsigned long scanned, unsigned long reclaimed) {}
-static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
-				   int prio) {}
-#endif /* CONFIG_MEMCG */
 
 extern void vmpressure_init(struct vmpressure *vmpr);
 extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
@@ -44,5 +38,10 @@ extern int vmpressure_register_event(str
 				     const char *args);
 extern void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
 					struct eventfd_ctx *eventfd);
-
+#else
+static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
+			      unsigned long scanned, unsigned long reclaimed) {}
+static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
+				   int prio) {}
+#endif /* CONFIG_MEMCG */
 #endif /* __LINUX_VMPRESSURE_H */
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
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch


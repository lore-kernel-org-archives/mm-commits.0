From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2.patch removed
 from -mm tree
Date: Fri, 08 Sep 2017 15:58:33 -0700
Message-ID: <59b32099.C8oqQiY0wKH7c+CX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48516 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdIHW6e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 18:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, arnd@arndb.de, ebaskakov@nvidia.com, liubo95@huawei.com, sfr@canb.auug.org.au, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: struct hmm is only use by HMM mirror functionality v2
has been removed from the -mm tree.  Its filename was
     mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2.patch

This patch was dropped because it was folded into mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm: struct hmm is only use by HMM mirror functionality v2

The struct hmm is only used if the HMM mirror functionality is enabled
move associated code behind CONFIG_HMM_MIRROR to avoid build error if one
enable some of the HMM memory configuration without the mirror feature.

Link: http://lkml.kernel.org/r/20170825213133.27286-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |    8 ++++----
 mm/hmm.c            |    7 +++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2 include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2
+++ a/include/linux/hmm.h
@@ -501,18 +501,18 @@ void hmm_device_put(struct hmm_device *h
 
 
 /* Below are for HMM internal use only! Not to be used by device driver! */
+#if IS_ENABLED(CONFIG_HMM_MIRROR)
 void hmm_mm_destroy(struct mm_struct *mm);
 
 static inline void hmm_mm_init(struct mm_struct *mm)
 {
 	mm->hmm = NULL;
 }
-
-#else /* IS_ENABLED(CONFIG_HMM) */
-
-/* Below are for HMM internal use only! Not to be used by device driver! */
+#else /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 static inline void hmm_mm_destroy(struct mm_struct *mm) {}
 static inline void hmm_mm_init(struct mm_struct *mm) {}
+#endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
+
 
 #endif /* IS_ENABLED(CONFIG_HMM) */
 #endif /* LINUX_HMM_H */
diff -puN mm/hmm.c~mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2 mm/hmm.c
--- a/mm/hmm.c~mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2
+++ a/mm/hmm.c
@@ -41,11 +41,12 @@
  */
 DEFINE_STATIC_KEY_FALSE(device_private_key);
 EXPORT_SYMBOL(device_private_key);
-static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
 #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 
 
-#ifdef CONFIG_HMM
+#if IS_ENABLED(CONFIG_HMM_MIRROR)
+static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
+
 /*
  * struct hmm - HMM per mm struct
  *
@@ -128,9 +129,7 @@ void hmm_mm_destroy(struct mm_struct *mm
 {
 	kfree(mm->hmm);
 }
-#endif /* CONFIG_HMM */
 
-#if IS_ENABLED(CONFIG_HMM_MIRROR)
 static void hmm_invalidate_range(struct hmm *hmm,
 				 enum hmm_update_type action,
 				 unsigned long start,
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch
mm-hmm-fix-build-when-hmm-is-disabled.patch
lib-interval_tree-fast-overlap-detection-fix.patch


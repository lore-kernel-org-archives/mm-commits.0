From: akpm@linux-foundation.org
Subject: + mm-hmm-fix-build-when-hmm-is-disabled.patch added to -mm tree
Date: Thu, 31 Aug 2017 14:37:21 -0700
Message-ID: <59a88191.54hMkabokpxiabJ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdHaVhW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Aug 2017 17:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix build when HMM is disabled
has been added to the -mm tree.  Its filename is
     mm-hmm-fix-build-when-hmm-is-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-fix-build-when-hmm-is-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-fix-build-when-hmm-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm: fix build when HMM is disabled

Combinatorial Kconfig is painfull. Withi this patch all below combination
build.

1)

2)
CONFIG_HMM_MIRROR=y

3)
CONFIG_DEVICE_PRIVATE=y

4)
CONFIG_DEVICE_PUBLIC=y

5)
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PUBLIC=y

6)
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y

7)
CONFIG_DEVICE_PRIVATE=y
CONFIG_DEVICE_PUBLIC=y

8)
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_DEVICE_PUBLIC=y

Link: http://lkml.kernel.org/r/20170826002149.20919-1-jglisse@redhat.com
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-fix-build-when-hmm-is-disabled include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-fix-build-when-hmm-is-disabled
+++ a/include/linux/hmm.h
@@ -498,7 +498,7 @@ struct hmm_device {
 struct hmm_device *hmm_device_new(void *drvdata);
 void hmm_device_put(struct hmm_device *hmm_device);
 #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
-
+#endif /* IS_ENABLED(CONFIG_HMM) */
 
 /* Below are for HMM internal use only! Not to be used by device driver! */
 #if IS_ENABLED(CONFIG_HMM_MIRROR)
@@ -517,5 +517,4 @@ static inline void hmm_mm_init(struct mm
 #else /* IS_ENABLED(CONFIG_HMM) */
 static inline void hmm_mm_destroy(struct mm_struct *mm) {}
 static inline void hmm_mm_init(struct mm_struct *mm) {}
-#endif /* IS_ENABLED(CONFIG_HMM) */
 #endif /* LINUX_HMM_H */
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
mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2.patch
mm-hmm-fix-build-when-hmm-is-disabled.patch
lib-interval_tree-fast-overlap-detection-fix.patch


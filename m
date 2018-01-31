From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch removed from -mm tree
Date: Wed, 31 Jan 2018 15:55:08 -0800
Message-ID: <5a72575c.d7EPKeKNdyX4dWBi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57154 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbeAaXzK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:55:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, airlied@linux.ie, alexander.deucher@amd.com, benh@kernel.crashing.org, boris.ostrovsky@oracle.com, christian.koenig@amd.com, dledford@redhat.com, jani.nikula@linux.intel.com, jglisse@redhat.com, joro@8bytes.org, mhocko@suse.com, mike.marciniszyn@intel.com, oded.gabbay@gmail.com, paulus@samba.org, pbonzini@redhat.com, rientjes@google.com, rkrcmar@redhat.com, sean.hefty@intel.com, sivanich@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch

This patch was dropped because it was folded into mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix

make mm_has_blockable_invalidate_notifiers() return bool, use rwsem_is_locked()

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Dimitri Sivanich <sivanich@hpe.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    7 ++++---
 mm/mmu_notifier.c            |    8 ++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix
+++ a/include/linux/mmu_notifier.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MMU_NOTIFIER_H
 #define _LINUX_MMU_NOTIFIER_H
 
+#include <linux/types.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/mm_types.h>
@@ -233,7 +234,7 @@ extern void __mmu_notifier_invalidate_ra
 				  bool only_end);
 extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
-extern int mm_has_blockable_invalidate_notifiers(struct mm_struct *mm);
+extern bool mm_has_blockable_invalidate_notifiers(struct mm_struct *mm);
 
 static inline void mmu_notifier_release(struct mm_struct *mm)
 {
@@ -473,9 +474,9 @@ static inline void mmu_notifier_invalida
 {
 }
 
-static inline int mm_has_blockable_invalidate_notifiers(struct mm_struct *mm)
+static inline bool mm_has_blockable_invalidate_notifiers(struct mm_struct *mm)
 {
-	return 0;
+	return false;
 }
 
 static inline void mmu_notifier_mm_init(struct mm_struct *mm)
diff -puN mm/mmu_notifier.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix
+++ a/mm/mmu_notifier.c
@@ -240,13 +240,13 @@ EXPORT_SYMBOL_GPL(__mmu_notifier_invalid
  * Must be called while holding mm->mmap_sem for either read or write.
  * The result is guaranteed to be valid until mm->mmap_sem is dropped.
  */
-int mm_has_blockable_invalidate_notifiers(struct mm_struct *mm)
+bool mm_has_blockable_invalidate_notifiers(struct mm_struct *mm)
 {
 	struct mmu_notifier *mn;
 	int id;
-	int ret = 0;
+	bool ret = false;
 
-	WARN_ON_ONCE(down_write_trylock(&mm->mmap_sem));
+	WARN_ON_ONCE(!rwsem_is_locked(&mm->mmap_sem));
 
 	if (!mm_has_notifiers(mm))
 		return ret;
@@ -259,7 +259,7 @@ int mm_has_blockable_invalidate_notifier
 				continue;
 
 		if (!(mn->ops->flags & MMU_INVALIDATE_DOES_NOT_BLOCK)) {
-			ret = 1;
+			ret = true;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch


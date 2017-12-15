From: akpm@linux-foundation.org
Subject: +
 mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch added to -mm tree
Date: Fri, 15 Dec 2017 15:04:47 -0800
Message-ID: <5a34550f.sjgzhavAXwonnL9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756591AbdLOXEu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 18:04:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, airlied@linux.ie, alexander.deucher@amd.com, benh@kernel.crashing.org, boris.ostrovsky@oracle.com, christian.koenig@amd.com, dledford@redhat.com, jani.nikula@linux.intel.com, jglisse@redhat.com, joro@8bytes.org, mhocko@suse.com, mike.marciniszyn@intel.com, oded.gabbay@gmail.com, paulus@samba.org, pbonzini@redhat.com, rkrcmar@redhat.com, sean.hefty@intel.com, sivanich@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mmu_notifier: annotate mmu notifiers with blockable invalidate callbacks
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mmu_notifier: annotate mmu notifiers with blockable invalidate callbacks

4d4bbd8526a8 ("mm, oom_reaper: skip mm structs with mmu notifiers")
prevented the oom reaper from unmapping private anonymous memory with the
oom reaper when the oom victim mm had mmu notifiers registered.

The rationale is that doing mmu_notifier_invalidate_range_{start,end}()
around the unmap_page_range(), which is needed, can block and the oom
killer will stall forever waiting for the victim to exit, which may not be
possible without reaping.

That concern is real, but only true for mmu notifiers that have blockable
invalidate_range_{start,end}() callbacks.  This patch adds a "flags" field
to mmu notifier ops that can set a bit to indicate that these callbacks do
not block.

The implementation is steered toward an expensive slowpath, such as after
the oom reaper has grabbed mm->mmap_sem of a still alive oom victim.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1712141329500.74052@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Dimitri Sivanich <sivanich@hpe.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/hfi1/mmu_rb.c |    1 
 drivers/iommu/amd_iommu_v2.c        |    1 
 drivers/iommu/intel-svm.c           |    1 
 drivers/misc/sgi-gru/grutlbpurge.c  |    1 
 include/linux/mmu_notifier.h        |   21 +++++++++++++++++
 mm/mmu_notifier.c                   |   31 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                 |    1 
 7 files changed, 57 insertions(+)

diff -puN drivers/infiniband/hw/hfi1/mmu_rb.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks drivers/infiniband/hw/hfi1/mmu_rb.c
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -77,6 +77,7 @@ static void do_remove(struct mmu_rb_hand
 static void handle_remove(struct work_struct *work);
 
 static const struct mmu_notifier_ops mn_opts = {
+	.flags = MMU_INVALIDATE_DOES_NOT_BLOCK,
 	.invalidate_range_start = mmu_notifier_range_start,
 };
 
diff -puN drivers/iommu/amd_iommu_v2.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks drivers/iommu/amd_iommu_v2.c
--- a/drivers/iommu/amd_iommu_v2.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/drivers/iommu/amd_iommu_v2.c
@@ -427,6 +427,7 @@ static void mn_release(struct mmu_notifi
 }
 
 static const struct mmu_notifier_ops iommu_mn = {
+	.flags			= MMU_INVALIDATE_DOES_NOT_BLOCK,
 	.release		= mn_release,
 	.clear_flush_young      = mn_clear_flush_young,
 	.invalidate_range       = mn_invalidate_range,
diff -puN drivers/iommu/intel-svm.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks drivers/iommu/intel-svm.c
--- a/drivers/iommu/intel-svm.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/drivers/iommu/intel-svm.c
@@ -276,6 +276,7 @@ static void intel_mm_release(struct mmu_
 }
 
 static const struct mmu_notifier_ops intel_mmuops = {
+	.flags = MMU_INVALIDATE_DOES_NOT_BLOCK,
 	.release = intel_mm_release,
 	.change_pte = intel_change_pte,
 	.invalidate_range = intel_invalidate_range,
diff -puN drivers/misc/sgi-gru/grutlbpurge.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -258,6 +258,7 @@ static void gru_release(struct mmu_notif
 
 
 static const struct mmu_notifier_ops gru_mmuops = {
+	.flags			= MMU_INVALIDATE_DOES_NOT_BLOCK,
 	.invalidate_range_start	= gru_invalidate_range_start,
 	.invalidate_range_end	= gru_invalidate_range_end,
 	.release		= gru_release,
diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/include/linux/mmu_notifier.h
@@ -10,6 +10,9 @@
 struct mmu_notifier;
 struct mmu_notifier_ops;
 
+/* mmu_notifier_ops flags */
+#define MMU_INVALIDATE_DOES_NOT_BLOCK	(0x01)
+
 #ifdef CONFIG_MMU_NOTIFIER
 
 /*
@@ -27,6 +30,15 @@ struct mmu_notifier_mm {
 
 struct mmu_notifier_ops {
 	/*
+	 * Flags to specify behavior of callbacks for this MMU notifier.
+	 * Used to determine which context an operation may be called.
+	 *
+	 * MMU_INVALIDATE_DOES_NOT_BLOCK: invalidate_{start,end} does not
+	 *				  block
+	 */
+	int flags;
+
+	/*
 	 * Called either by mmu_notifier_unregister or when the mm is
 	 * being destroyed by exit_mmap, always before all pages are
 	 * freed. This can run concurrently with other mmu notifier
@@ -137,6 +149,9 @@ struct mmu_notifier_ops {
 	 * page. Pages will no longer be referenced by the linux
 	 * address space but may still be referenced by sptes until
 	 * the last refcount is dropped.
+	 *
+	 * If both of these callbacks cannot block, mmu_notifier_ops.flags
+	 * should have MMU_INVALIDATE_DOES_NOT_BLOCK set.
 	 */
 	void (*invalidate_range_start)(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
@@ -218,6 +233,7 @@ extern void __mmu_notifier_invalidate_ra
 				  bool only_end);
 extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
+extern int mm_has_blockable_invalidate_notifiers(struct mm_struct *mm);
 
 static inline void mmu_notifier_release(struct mm_struct *mm)
 {
@@ -457,6 +473,11 @@ static inline void mmu_notifier_invalida
 {
 }
 
+static inline int mm_has_blockable_invalidate_notifiers(struct mm_struct *mm)
+{
+	return 0;
+}
+
 static inline void mmu_notifier_mm_init(struct mm_struct *mm)
 {
 }
diff -puN mm/mmu_notifier.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/mm/mmu_notifier.c
@@ -236,6 +236,37 @@ void __mmu_notifier_invalidate_range(str
 }
 EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range);
 
+/*
+ * Must be called while holding mm->mmap_sem for either read or write.
+ * The result is guaranteed to be valid until mm->mmap_sem is dropped.
+ */
+int mm_has_blockable_invalidate_notifiers(struct mm_struct *mm)
+{
+	struct mmu_notifier *mn;
+	int id;
+	int ret = 0;
+
+	WARN_ON_ONCE(down_write_trylock(&mm->mmap_sem));
+
+	if (!mm_has_notifiers(mm))
+		return ret;
+
+	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
+		if (!mn->ops->invalidate_range &&
+		    !mn->ops->invalidate_range_start &&
+		    !mn->ops->invalidate_range_end)
+				continue;
+
+		if (!(mn->ops->flags & MMU_INVALIDATE_DOES_NOT_BLOCK)) {
+			ret = 1;
+			break;
+		}
+	}
+	srcu_read_unlock(&srcu, id);
+	return ret;
+}
+
 static int do_mmu_notifier_register(struct mmu_notifier *mn,
 				    struct mm_struct *mm,
 				    int take_mmap_sem)
diff -puN virt/kvm/kvm_main.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks
+++ a/virt/kvm/kvm_main.c
@@ -476,6 +476,7 @@ static void kvm_mmu_notifier_release(str
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
+	.flags			= MMU_INVALIDATE_DOES_NOT_BLOCK,
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
_

Patches currently in -mm which might be from rientjes@google.com are

mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch
mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch


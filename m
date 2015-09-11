From: akpm@linux-foundation.org
Subject: [merged] mmu-notifier-add-clear_young-callback.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:19 -0700
Message-ID: <55f31947.vlC2Khtc/4THyGOs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIKSLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, pbonzini@redhat.com, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu-notifier: add clear_young callback
has been removed from the -mm tree.  Its filename was
     mmu-notifier-add-clear_young-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mmu-notifier: add clear_young callback

In the scope of the idle memory tracking feature, which is introduced by
the following patch, we need to clear the referenced/accessed bit not only
in primary, but also in secondary ptes.  The latter is required in order
to estimate wss of KVM VMs.  At the same time we want to avoid flushing
tlb, because it is quite expensive and it won't really affect the final
result.

Currently, there is no function for clearing pte young bit that would meet
our requirements, so this patch introduces one.  To achieve that we have
to add a new mmu-notifier callback, clear_young, since there is no method
for testing-and-clearing a secondary pte w/o flushing tlb.  The new method
is not mandatory and currently only implemented by KVM.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   44 +++++++++++++++++++++++++++++++++
 mm/mmu_notifier.c            |   17 ++++++++++++
 virt/kvm/kvm_main.c          |   31 +++++++++++++++++++++++
 3 files changed, 92 insertions(+)

diff -puN include/linux/mmu_notifier.h~mmu-notifier-add-clear_young-callback include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mmu-notifier-add-clear_young-callback
+++ a/include/linux/mmu_notifier.h
@@ -66,6 +66,16 @@ struct mmu_notifier_ops {
 				 unsigned long end);
 
 	/*
+	 * clear_young is a lightweight version of clear_flush_young. Like the
+	 * latter, it is supposed to test-and-clear the young/accessed bitflag
+	 * in the secondary pte, but it may omit flushing the secondary tlb.
+	 */
+	int (*clear_young)(struct mmu_notifier *mn,
+			   struct mm_struct *mm,
+			   unsigned long start,
+			   unsigned long end);
+
+	/*
 	 * test_young is called to check the young/accessed bitflag in
 	 * the secondary pte. This is used to know if the page is
 	 * frequently used without actually clearing the flag or tearing
@@ -203,6 +213,9 @@ extern void __mmu_notifier_release(struc
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					  unsigned long start,
 					  unsigned long end);
+extern int __mmu_notifier_clear_young(struct mm_struct *mm,
+				      unsigned long start,
+				      unsigned long end);
 extern int __mmu_notifier_test_young(struct mm_struct *mm,
 				     unsigned long address);
 extern void __mmu_notifier_change_pte(struct mm_struct *mm,
@@ -231,6 +244,15 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline int mmu_notifier_clear_young(struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long end)
+{
+	if (mm_has_notifiers(mm))
+		return __mmu_notifier_clear_young(mm, start, end);
+	return 0;
+}
+
 static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
@@ -311,6 +333,28 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+#define ptep_clear_young_notify(__vma, __address, __ptep)		\
+({									\
+	int __young;							\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	__young = ptep_test_and_clear_young(___vma, ___address, __ptep);\
+	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
+					    ___address + PAGE_SIZE);	\
+	__young;							\
+})
+
+#define pmdp_clear_young_notify(__vma, __address, __pmdp)		\
+({									\
+	int __young;							\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	__young = pmdp_test_and_clear_young(___vma, ___address, __pmdp);\
+	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
+					    ___address + PMD_SIZE);	\
+	__young;							\
+})
+
 #define	ptep_clear_flush_notify(__vma, __address, __ptep)		\
 ({									\
 	unsigned long ___addr = __address & PAGE_MASK;			\
diff -puN mm/mmu_notifier.c~mmu-notifier-add-clear_young-callback mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mmu-notifier-add-clear_young-callback
+++ a/mm/mmu_notifier.c
@@ -123,6 +123,23 @@ int __mmu_notifier_clear_flush_young(str
 	return young;
 }
 
+int __mmu_notifier_clear_young(struct mm_struct *mm,
+			       unsigned long start,
+			       unsigned long end)
+{
+	struct mmu_notifier *mn;
+	int young = 0, id;
+
+	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
+		if (mn->ops->clear_young)
+			young |= mn->ops->clear_young(mn, mm, start, end);
+	}
+	srcu_read_unlock(&srcu, id);
+
+	return young;
+}
+
 int __mmu_notifier_test_young(struct mm_struct *mm,
 			      unsigned long address)
 {
diff -puN virt/kvm/kvm_main.c~mmu-notifier-add-clear_young-callback virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mmu-notifier-add-clear_young-callback
+++ a/virt/kvm/kvm_main.c
@@ -387,6 +387,36 @@ static int kvm_mmu_notifier_clear_flush_
 	return young;
 }
 
+static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
+					struct mm_struct *mm,
+					unsigned long start,
+					unsigned long end)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int young, idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	/*
+	 * Even though we do not flush TLB, this will still adversely
+	 * affect performance on pre-Haswell Intel EPT, where there is
+	 * no EPT Access Bit to clear so that we have to tear down EPT
+	 * tables instead. If we find this unacceptable, we can always
+	 * add a parameter to kvm_age_hva so that it effectively doesn't
+	 * do anything on clear_young.
+	 *
+	 * Also note that currently we never issue secondary TLB flushes
+	 * from clear_young, leaving this job up to the regular system
+	 * cadence. If we find this inaccurate, we might come up with a
+	 * more sophisticated heuristic later.
+	 */
+	young = kvm_age_hva(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return young;
+}
+
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long address)
@@ -419,6 +449,7 @@ static const struct mmu_notifier_ops kvm
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
+	.clear_young		= kvm_mmu_notifier_clear_young,
 	.test_young		= kvm_mmu_notifier_test_young,
 	.change_pte		= kvm_mmu_notifier_change_pte,
 	.release		= kvm_mmu_notifier_release,
_

Patches currently in -mm which might be from vdavydov@parallels.com are



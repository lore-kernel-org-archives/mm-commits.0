From: akpm@linux-foundation.org
Subject: + ksm-mmu_notifiers-add-set_pte_at_notify.patch added to -mm tree
Date: Mon, 20 Apr 2009 16:32:39 -0700
Message-ID: <200904202332.n3KNWegW002766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbZDTXhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 19:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: MMU_NOTIFIERS: add set_pte_at_notify()
has been added to the -mm tree.  Its filename is
     ksm-mmu_notifiers-add-set_pte_at_notify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: MMU_NOTIFIERS: add set_pte_at_notify()
From: Izik Eidus <ieidus@redhat.com>

This macro allow setting the pte in the shadow page tables directly
instead of flushing the shadow page table entry and then get vmexit in
order to set it.

This function is optimzation for kvm/users of mmu_notifiers for COW pages,
it is useful for kvm when ksm is used beacuse it allow kvm not to have to
recive VMEXIT and only then map the shared page into the mmu shadow pages,
but instead map it directly at the same time linux map the page into the
host page table.

This mmu notifer macro is working by calling to callback that will map
directly the physical page into the shadow page tables.

(users of mmu_notifiers that didnt implement the set_pte_at_notify()
call back will just recive the mmu_notifier_invalidate_page callback)

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   34 +++++++++++++++++++++++++++++++++
 mm/memory.c                  |   10 +++++++--
 mm/mmu_notifier.c            |   20 +++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff -puN include/linux/mmu_notifier.h~ksm-mmu_notifiers-add-set_pte_at_notify include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~ksm-mmu_notifiers-add-set_pte_at_notify
+++ a/include/linux/mmu_notifier.h
@@ -62,6 +62,15 @@ struct mmu_notifier_ops {
 				 unsigned long address);
 
 	/*
+	* change_pte is called in cases that pte mapping into page is changed
+	* for example when ksm mapped pte to point into a new shared page.
+	*/
+	void (*change_pte)(struct mmu_notifier *mn,
+			   struct mm_struct *mm,
+			   unsigned long address,
+			   pte_t pte);
+
+	/*
 	 * Before this is invoked any secondary MMU is still ok to
 	 * read/write to the page previously pointed to by the Linux
 	 * pte because the page hasn't been freed yet and it won't be
@@ -154,6 +163,8 @@ extern void __mmu_notifier_mm_destroy(st
 extern void __mmu_notifier_release(struct mm_struct *mm);
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					  unsigned long address);
+extern void __mmu_notifier_change_pte(struct mm_struct *mm,
+				      unsigned long address, pte_t pte);
 extern void __mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address);
 extern void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
@@ -175,6 +186,13 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline void mmu_notifier_change_pte(struct mm_struct *mm,
+					   unsigned long address, pte_t pte)
+{
+	if (mm_has_notifiers(mm))
+		__mmu_notifier_change_pte(mm, address, pte);
+}
+
 static inline void mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address)
 {
@@ -236,6 +254,16 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+#define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
+({									\
+	struct mm_struct *___mm = __mm;					\
+	unsigned long ___address = __address;				\
+	pte_t ___pte = __pte;						\
+									\
+	set_pte_at(__mm, __address, __ptep, ___pte);			\
+	mmu_notifier_change_pte(___mm, ___address, ___pte);		\
+})
+
 #else /* CONFIG_MMU_NOTIFIER */
 
 static inline void mmu_notifier_release(struct mm_struct *mm)
@@ -248,6 +276,11 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline void mmu_notifier_change_pte(struct mm_struct *mm,
+					   unsigned long address, pte_t pte)
+{
+}
+
 static inline void mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address)
 {
@@ -273,6 +306,7 @@ static inline void mmu_notifier_mm_destr
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define ptep_clear_flush_notify ptep_clear_flush
+#define set_pte_at_notify set_pte_at
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
diff -puN mm/memory.c~ksm-mmu_notifiers-add-set_pte_at_notify mm/memory.c
--- a/mm/memory.c~ksm-mmu_notifiers-add-set_pte_at_notify
+++ a/mm/memory.c
@@ -2114,9 +2114,15 @@ gotten:
 		 * seen in the presence of one thread doing SMC and another
 		 * thread doing COW.
 		 */
-		ptep_clear_flush_notify(vma, address, page_table);
+		ptep_clear_flush(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
-		set_pte_at(mm, address, page_table, entry);
+		/*
+		 * We call here the notify macro beacuse in cases of using
+		 * secondary mmu page table like kvm shadow page, tables we want
+		 * the new page to be mapped directly into the secondary page
+		 * table
+		 */
+		set_pte_at_notify(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
 		if (old_page) {
 			/*
diff -puN mm/mmu_notifier.c~ksm-mmu_notifiers-add-set_pte_at_notify mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~ksm-mmu_notifiers-add-set_pte_at_notify
+++ a/mm/mmu_notifier.c
@@ -99,6 +99,26 @@ int __mmu_notifier_clear_flush_young(str
 	return young;
 }
 
+void __mmu_notifier_change_pte(struct mm_struct *mm, unsigned long address,
+			       pte_t pte)
+{
+	struct mmu_notifier *mn;
+	struct hlist_node *n;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+		if (mn->ops->change_pte)
+			mn->ops->change_pte(mn, mm, address, pte);
+		/*
+		 * some drivers dont have change_pte and therefor we must call
+		 * for invalidate_page in that case
+		 */
+		else if (mn->ops->invalidate_page)
+			mn->ops->invalidate_page(mn, mm, address);
+	}
+	rcu_read_unlock();
+}
+
 void __mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address)
 {
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch


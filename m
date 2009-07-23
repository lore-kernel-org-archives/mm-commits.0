From: akpm@linux-foundation.org
Subject: + ksm-add-mmu_notifier-set_pte_at_notify.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:21 -0700
Message-ID: <200907232107.n6NL7LEi027104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbZGWVIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     ksm: add mmu_notifier set_pte_at_notify()
has been added to the -mm tree.  Its filename is
     ksm-add-mmu_notifier-set_pte_at_notify.patch

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
Subject: ksm: add mmu_notifier set_pte_at_notify()
From: Izik Eidus <ieidus@redhat.com>

KSM is a linux driver that allows dynamicly sharing identical memory pages
between one or more processes.

Unlike tradtional page sharing that is made at the allocation of the
memory, ksm do it dynamicly after the memory was created.  Memory is
periodically scanned; identical pages are identified and merged.

The sharing is made in a transparent way to the procsess that use it.

Ksm is highly important for hypervisors (kvm), where in production
enviorments there might be many copys of the same data data among the host
memory.  This kind of data can be: similar kernels, librarys, cache, and
so on.

Even that ksm was wrote for kvm, any userspace application that want to
use it to share its data can try it.

Ksm may be useful for any application that might have similar (page
aligment) data strctures among the memory, ksm will find this data merge
it to one copy, and even if it will be changed and thereforew copy on
writed, ksm will merge it again as soon as it will be identical again.

Another reason to consider using ksm is the fact that it might simplify
alot the userspace code of application that want to use shared private
data, instead that the application will mange shared area, ksm will do
this for the application, and even write to this data will be allowed
without any synchinization acts from the application.

Ksm was designed to be a loadable module that doesn't change the VM code
of linux.



This patch:

The set_pte_at_notify() macro allows setting a pte in the shadow page
table directly, instead of flushing the shadow page table entry and then
getting vmexit to set it.  It uses a new change_pte() callback to do so.

set_pte_at_notify() is an optimization for kvm, and other users of
mmu_notifiers, for COW pages.  It is useful for kvm when ksm is used,
because it allows kvm not to have to receive vmexit and only then map the
ksm page into the shadow page table, but instead map it directly at the
same time as Linux maps the page into the host page table.

Users of mmu_notifiers who don't implement new mmu_notifier_change_pte()
callback will just receive the mmu_notifier_invalidate_page() callback.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   34 +++++++++++++++++++++++++++++++++
 mm/memory.c                  |    9 ++++++--
 mm/mmu_notifier.c            |   20 +++++++++++++++++++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff -puN include/linux/mmu_notifier.h~ksm-add-mmu_notifier-set_pte_at_notify include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~ksm-add-mmu_notifier-set_pte_at_notify
+++ a/include/linux/mmu_notifier.h
@@ -62,6 +62,15 @@ struct mmu_notifier_ops {
 				 unsigned long address);
 
 	/*
+	 * change_pte is called in cases that pte mapping to page is changed:
+	 * for example, when ksm remaps pte to point to a new shared page.
+	 */
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
+	set_pte_at(___mm, ___address, __ptep, ___pte);			\
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
 
diff -puN mm/memory.c~ksm-add-mmu_notifier-set_pte_at_notify mm/memory.c
--- a/mm/memory.c~ksm-add-mmu_notifier-set_pte_at_notify
+++ a/mm/memory.c
@@ -2113,9 +2113,14 @@ gotten:
 		 * seen in the presence of one thread doing SMC and another
 		 * thread doing COW.
 		 */
-		ptep_clear_flush_notify(vma, address, page_table);
+		ptep_clear_flush(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
-		set_pte_at(mm, address, page_table, entry);
+		/*
+		 * We call the notify macro here because, when using secondary
+		 * mmu page tables (such as kvm shadow page tables), we want the
+		 * new page to be mapped directly into the secondary page table.
+		 */
+		set_pte_at_notify(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
 		if (old_page) {
 			/*
diff -puN mm/mmu_notifier.c~ksm-add-mmu_notifier-set_pte_at_notify mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~ksm-add-mmu_notifier-set_pte_at_notify
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
+		 * Some drivers don't have change_pte,
+		 * so we must call invalidate_page in that case.
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
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch


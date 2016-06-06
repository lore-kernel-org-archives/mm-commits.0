From: akpm@linux-foundation.org
Subject: + khugepaged-simplify-khugepaged-vs-__mmput.patch added to -mm
 tree
Date: Mon, 06 Jun 2016 14:06:22 -0700
Message-ID: <5755e5ce.bjz+JqGhOt5sd6kI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbcFFVGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 17:06:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, sergey.senozhatsky.work@gmail.com, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: simplify khugepaged vs. __mmput
has been added to the -mm tree.  Its filename is
     khugepaged-simplify-khugepaged-vs-__mmput.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-simplify-khugepaged-vs-__mmput.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-simplify-khugepaged-vs-__mmput.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: khugepaged: simplify khugepaged vs. __mmput

__khugepaged_exit is called during the final __mmput and it employs a
complex synchronization dances to make sure it doesn't race with the
khugepaged which might be scanning this mm at the same time.  This is all
caused by the fact that khugepaged doesn't pin mm_users.  Things would
simplify considerably if we simply check the mm at khugepaged_scan_mm_slot
and if mm_users was already 0 then we know it is dead and we can unhash
the mm_slot and move on to another one.  This will also guarantee that
__khugepaged_exit cannot race with khugepaged and so we can free up the
slot if it is still hashed.

Link: http://lkml.kernel.org/r/20160603134934.GJ20676@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   90 +++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 48 deletions(-)

diff -puN mm/huge_memory.c~khugepaged-simplify-khugepaged-vs-__mmput mm/huge_memory.c
--- a/mm/huge_memory.c~khugepaged-simplify-khugepaged-vs-__mmput
+++ a/mm/huge_memory.c
@@ -1936,7 +1936,8 @@ static void insert_to_mm_slots_hash(stru
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
-	return atomic_read(&mm->mm_users) == 0;
+	/* the only pin is from khugepaged_scan_mm_slot */
+	return atomic_read(&mm->mm_users) <= 1;
 }
 
 int __khugepaged_enter(struct mm_struct *mm)
@@ -1948,8 +1949,6 @@ int __khugepaged_enter(struct mm_struct
 	if (!mm_slot)
 		return -ENOMEM;
 
-	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
@@ -1992,36 +1991,43 @@ int khugepaged_enter_vma_merge(struct vm
 	return 0;
 }
 
-void __khugepaged_exit(struct mm_struct *mm)
+static void collect_mm_slot(struct mm_slot *mm_slot)
 {
-	struct mm_slot *mm_slot;
-	int free = 0;
+	struct mm_struct *mm = mm_slot->mm;
 
-	spin_lock(&khugepaged_mm_lock);
-	mm_slot = get_mm_slot(mm);
-	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
+
+	if (khugepaged_test_exit(mm)) {
+		/* free mm_slot */
 		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
-		free = 1;
-	}
-	spin_unlock(&khugepaged_mm_lock);
 
-	if (free) {
-		clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
-		free_mm_slot(mm_slot);
-		mmdrop(mm);
-	} else if (mm_slot) {
 		/*
-		 * This is required to serialize against
-		 * khugepaged_test_exit() (which is guaranteed to run
-		 * under mmap sem read mode). Stop here (after we
-		 * return all pagetables will be destroyed) until
-		 * khugepaged has finished working on the pagetables
-		 * under the mmap_sem.
+		 * Not strictly needed because the mm exited already.
+		 *
+		 * clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
 		 */
-		down_write(&mm->mmap_sem);
-		up_write(&mm->mmap_sem);
+
+		/* khugepaged_mm_lock actually not necessary for the below */
+		free_mm_slot(mm_slot);
+		mmdrop(mm);
+
+		if (khugepaged_scan.mm_slot == mm_slot)
+			khugepaged_scan.mm_slot = NULL;
+	}
+}
+
+void __khugepaged_exit(struct mm_struct *mm)
+{
+	struct mm_slot *mm_slot;
+
+	spin_lock(&khugepaged_mm_lock);
+	mm_slot = get_mm_slot(mm);
+	if (mm_slot) {
+		collect_mm_slot(mm_slot);
+		clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
 	}
+	spin_unlock(&khugepaged_mm_lock);
 }
 
 static void release_pte_page(struct page *page)
@@ -2693,29 +2699,6 @@ out:
 	return ret;
 }
 
-static void collect_mm_slot(struct mm_slot *mm_slot)
-{
-	struct mm_struct *mm = mm_slot->mm;
-
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
-
-	if (khugepaged_test_exit(mm)) {
-		/* free mm_slot */
-		hash_del(&mm_slot->hash);
-		list_del(&mm_slot->mm_node);
-
-		/*
-		 * Not strictly needed because the mm exited already.
-		 *
-		 * clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
-		 */
-
-		/* khugepaged_mm_lock actually not necessary for the below */
-		free_mm_slot(mm_slot);
-		mmdrop(mm);
-	}
-}
-
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 					    struct page **hpage)
 	__releases(&khugepaged_mm_lock)
@@ -2737,6 +2720,16 @@ static unsigned int khugepaged_scan_mm_s
 		khugepaged_scan.address = 0;
 		khugepaged_scan.mm_slot = mm_slot;
 	}
+
+	/*
+	 * Do not even try to do anything if the current mm is already
+	 * dead. khugepaged_mm_lock will make sure only this or
+	 * __khugepaged_exit does the unhasing.
+	 */
+	if (!atomic_inc_not_zero(&mm_slot->mm->mm_users)) {
+		collect_mm_slot(mm_slot);
+		return progress;
+	}
 	spin_unlock(&khugepaged_mm_lock);
 
 	mm = mm_slot->mm;
@@ -2820,6 +2813,7 @@ breakouterloop_mmap_sem:
 
 		collect_mm_slot(mm_slot);
 	}
+	mmput_async(mm);
 
 	return progress;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch
khugepaged-simplify-khugepaged-vs-__mmput.patch


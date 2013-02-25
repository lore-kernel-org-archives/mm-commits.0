From: akpm@linux-foundation.org
Subject: [merged] mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:14 -0800
Message-ID: <20130225204914.A385831C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:51960 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab3BYUtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:16 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so346076vch.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect
has been removed from the -mm tree.  Its filename was
     mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect mm/mmap.c
--- a/mm/mmap.c~mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect
+++ a/mm/mmap.c
@@ -256,6 +256,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
+	bool populate;
 
 	down_write(&mm->mmap_sem);
 
@@ -305,8 +306,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	/* Ok, looks good - let it rip. */
 	if (do_brk(oldbrk, newbrk-oldbrk) != oldbrk)
 		goto out;
+
 set_brk:
 	mm->brk = brk;
+	populate = newbrk > oldbrk && (mm->def_flags & VM_LOCKED) != 0;
+	up_write(&mm->mmap_sem);
+	if (populate)
+		mm_populate(oldbrk, newbrk - oldbrk);
+	return brk;
+
 out:
 	retval = mm->brk;
 	up_write(&mm->mmap_sem);
@@ -2600,10 +2608,8 @@ static unsigned long do_brk(unsigned lon
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
-	if (flags & VM_LOCKED) {
-		if (!mlock_vma_pages_range(vma, addr, addr + len))
-			mm->locked_vm += (len >> PAGE_SHIFT);
-	}
+	if (flags & VM_LOCKED)
+		mm->locked_vm += (len >> PAGE_SHIFT);
 	return addr;
 }
 
@@ -2611,10 +2617,14 @@ unsigned long vm_brk(unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long ret;
+	bool populate;
 
 	down_write(&mm->mmap_sem);
 	ret = do_brk(addr, len);
+	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	up_write(&mm->mmap_sem);
+	if (populate)
+		mm_populate(addr, len);
 	return ret;
 }
 EXPORT_SYMBOL(vm_brk);
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remove-free_area_cache.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch


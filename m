From: akpm@linux-foundation.org
Subject: + mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:42:37 -0800
Message-ID: <20130108234238.B420D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39045 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3AHXmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:42:42 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so80703lbc.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:42:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect
has been added to the -mm tree.  Its filename is
     mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -255,6 +255,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
+	bool populate;
 
 	down_write(&mm->mmap_sem);
 
@@ -304,8 +305,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
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
@@ -2599,10 +2607,8 @@ static unsigned long do_brk(unsigned lon
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
 
@@ -2610,10 +2616,14 @@ unsigned long vm_brk(unsigned long addr,
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

linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch


From: akpm@linux-foundation.org
Subject: + mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:42:41 -0800
Message-ID: <20130108234242.3987982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50553 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3AHXmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:42:43 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so152591yen.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:42:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: use mm_populate() for mremap() of VM_LOCKED vmas
has been added to the -mm tree.  Its filename is
     mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch

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
Subject: mm: use mm_populate() for mremap() of VM_LOCKED vmas

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/mremap.c~mm-use-mm_populate-for-mremap-of-vm_locked-vmas mm/mremap.c
--- a/mm/mremap.c~mm-use-mm_populate-for-mremap-of-vm_locked-vmas
+++ a/mm/mremap.c
@@ -208,7 +208,7 @@ unsigned long move_page_tables(struct vm
 
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
-		unsigned long new_len, unsigned long new_addr)
+		unsigned long new_len, unsigned long new_addr, bool *locked)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -299,9 +299,7 @@ static unsigned long move_vma(struct vm_
 
 	if (vm_flags & VM_LOCKED) {
 		mm->locked_vm += new_len >> PAGE_SHIFT;
-		if (new_len > old_len)
-			mlock_vma_pages_range(new_vma, new_addr + old_len,
-						       new_addr + new_len);
+		*locked = true;
 	}
 
 	return new_addr;
@@ -366,9 +364,8 @@ Eagain:
 	return ERR_PTR(-EAGAIN);
 }
 
-static unsigned long mremap_to(unsigned long addr,
-	unsigned long old_len, unsigned long new_addr,
-	unsigned long new_len)
+static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
+		unsigned long new_addr, unsigned long new_len, bool *locked)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -418,7 +415,7 @@ static unsigned long mremap_to(unsigned 
 	if (ret & ~PAGE_MASK)
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr);
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked);
 	if (!(ret & ~PAGE_MASK))
 		goto out;
 out1:
@@ -456,6 +453,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
+	bool locked = false;
 
 	down_write(&current->mm->mmap_sem);
 
@@ -478,7 +476,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (flags & MREMAP_FIXED) {
 		if (flags & MREMAP_MAYMOVE)
-			ret = mremap_to(addr, old_len, new_addr, new_len);
+			ret = mremap_to(addr, old_len, new_addr, new_len,
+					&locked);
 		goto out;
 	}
 
@@ -520,8 +519,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
-				mlock_vma_pages_range(vma, addr + old_len,
-						   addr + new_len);
+				locked = true;
+				new_addr = addr;
 			}
 			ret = addr;
 			goto out;
@@ -547,11 +546,13 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			goto out;
 		}
 
-		ret = move_vma(vma, addr, old_len, new_len, new_addr);
+		ret = move_vma(vma, addr, old_len, new_len, new_addr, &locked);
 	}
 out:
 	if (ret & ~PAGE_MASK)
 		vm_unacct_memory(charged);
 	up_write(&current->mm->mmap_sem);
+	if (locked && new_len > old_len)
+		mm_populate(new_addr + old_len, new_len - old_len);
 	return ret;
 }
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


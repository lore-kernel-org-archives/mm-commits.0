From: akpm@linux-foundation.org
Subject: [merged] mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:17 -0800
Message-ID: <20130225204917.B423B31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51816 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab3BYUtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:19 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so361524qaj.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use mm_populate() for mremap() of VM_LOCKED vmas
has been removed from the -mm tree.  Its filename was
     mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -209,7 +209,7 @@ unsigned long move_page_tables(struct vm
 
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
-		unsigned long new_len, unsigned long new_addr)
+		unsigned long new_len, unsigned long new_addr, bool *locked)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -300,9 +300,7 @@ static unsigned long move_vma(struct vm_
 
 	if (vm_flags & VM_LOCKED) {
 		mm->locked_vm += new_len >> PAGE_SHIFT;
-		if (new_len > old_len)
-			mlock_vma_pages_range(new_vma, new_addr + old_len,
-						       new_addr + new_len);
+		*locked = true;
 	}
 
 	return new_addr;
@@ -367,9 +365,8 @@ Eagain:
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
@@ -419,7 +416,7 @@ static unsigned long mremap_to(unsigned 
 	if (ret & ~PAGE_MASK)
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr);
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked);
 	if (!(ret & ~PAGE_MASK))
 		goto out;
 out1:
@@ -457,6 +454,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
+	bool locked = false;
 
 	down_write(&current->mm->mmap_sem);
 
@@ -479,7 +477,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (flags & MREMAP_FIXED) {
 		if (flags & MREMAP_MAYMOVE)
-			ret = mremap_to(addr, old_len, new_addr, new_len);
+			ret = mremap_to(addr, old_len, new_addr, new_len,
+					&locked);
 		goto out;
 	}
 
@@ -521,8 +520,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
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
@@ -548,11 +547,13 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
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


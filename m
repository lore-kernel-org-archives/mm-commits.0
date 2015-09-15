From: akpm@linux-foundation.org
Subject: + mm-mremap-use-offset_in_page-macro.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:22:53 -0700
Message-ID: <55f89a3d.DuwhQxssN7r+QyeE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbIOWWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:22:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     mm-mremap-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/mremap: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mremap.c~mm-mremap-use-offset_in_page-macro mm/mremap.c
--- a/mm/mremap.c~mm-mremap-use-offset_in_page-macro
+++ a/mm/mremap.c
@@ -401,7 +401,7 @@ static unsigned long mremap_to(unsigned
 	unsigned long charged = 0;
 	unsigned long map_flags;
 
-	if (new_addr & ~PAGE_MASK)
+	if (offset_in_page(new_addr))
 		goto out;
 
 	if (new_len > TASK_SIZE || new_addr > TASK_SIZE - new_len)
@@ -435,11 +435,11 @@ static unsigned long mremap_to(unsigned
 	ret = get_unmapped_area(vma->vm_file, new_addr, new_len, vma->vm_pgoff +
 				((addr - vma->vm_start) >> PAGE_SHIFT),
 				map_flags);
-	if (ret & ~PAGE_MASK)
+	if (offset_in_page(ret))
 		goto out1;
 
 	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked);
-	if (!(ret & ~PAGE_MASK))
+	if (!(offset_in_page(ret)))
 		goto out;
 out1:
 	vm_unacct_memory(charged);
@@ -484,7 +484,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
 		return ret;
 
-	if (addr & ~PAGE_MASK)
+	if (offset_in_page(addr))
 		return ret;
 
 	old_len = PAGE_ALIGN(old_len);
@@ -566,7 +566,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 					vma->vm_pgoff +
 					((addr - vma->vm_start) >> PAGE_SHIFT),
 					map_flags);
-		if (new_addr & ~PAGE_MASK) {
+		if (offset_in_page(new_addr)) {
 			ret = new_addr;
 			goto out;
 		}
@@ -574,7 +574,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		ret = move_vma(vma, addr, old_len, new_len, new_addr, &locked);
 	}
 out:
-	if (ret & ~PAGE_MASK) {
+	if (offset_in_page(ret)) {
 		vm_unacct_memory(charged);
 		locked = 0;
 	}
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch


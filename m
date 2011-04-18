From: akpm@linux-foundation.org
Subject: [merged] mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:56 -0700
Message-ID: <201104181759.p3IHx75v016120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab1DRSEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: check that we have the right vma in __access_remote_vm()
has been removed from the -mm tree.  Its filename was
     mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: check that we have the right vma in __access_remote_vm()
From: Michael Ellerman <michael@ellerman.id.au>

In __access_remote_vm() we need to check that we have found the right vma,
not the following vma before we try to access it.  Otherwise we might call
the vma's access routine with an address which does not fall inside the
vma.

It was discovered on a current kernel but with an unreleased driver,
from memory it was strace leading to a kernel bad access, but it
obviously depends on what the access implementation does. 

Looking at other access implementations I only see:

$ git grep -A 5 vm_operations|grep access
arch/powerpc/platforms/cell/spufs/file.c-	.access = spufs_mem_mmap_access,
arch/x86/pci/i386.c-	.access = generic_access_phys,
drivers/char/mem.c-	.access = generic_access_phys
fs/sysfs/bin.c-	.access		= bin_access,


The spufs one looks like it might behave badly given the wrong vma, it
assumes vma->vm_file->private_data is a spu_context, and looks like it
would probably blow up pretty quickly if it wasn't.

generic_access_phys() only uses the vma to check vm_flags and get the mm,
and then walks page tables using the address.  So it should bail on the
vm_flags check, or at worst let you access some other VM_IO mapping.

And bin_access() just proxies to another access implementation.


Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-check-that-we-have-the-right-vma-in-__access_remote_vm mm/memory.c
--- a/mm/memory.c~mm-check-that-we-have-the-right-vma-in-__access_remote_vm
+++ a/mm/memory.c
@@ -3688,7 +3688,7 @@ static int __access_remote_vm(struct tas
 			 */
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 			vma = find_vma(mm, addr);
-			if (!vma)
+			if (!vma || vma->vm_start > addr)
 				break;
 			if (vma->vm_ops && vma->vm_ops->access)
 				ret = vma->vm_ops->access(vma, addr, buf,
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch


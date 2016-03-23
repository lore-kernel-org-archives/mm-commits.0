From: akpm@linux-foundation.org
Subject: [merged] mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:44 -0700
Message-ID: <56f2d594.f9vJ2Ue3av8n6xj/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbcCWRmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: don't imply PROT_EXEC on non-exec fs
has been removed from the -mm tree.  Its filename was
     mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm/mprotect.c: don't imply PROT_EXEC on non-exec fs

The mprotect(PROT_READ) fails when called by the READ_IMPLIES_EXEC binary
on a memory mapped file located on non-exec fs.  The mprotect does not
check whether fs is _executable_ or not.  The PROT_EXEC flag is set
automatically even if a memory mapped file is located on non-exec fs.  Fix
it by checking whether a memory mapped file is located on a non-exec fs. 
If so the PROT_EXEC is not implied by the PROT_READ.  The implementation
uses the VM_MAYEXEC flag set properly in mmap.  Now it is consistent with
mmap.

I did the isolated tests (PT_GNU_STACK X/NX, multiple VMAs, X/NX fs).  I
also patched the official 3.19.0-47-generic Ubuntu 14.04 kernel and it
seems to work.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs
+++ a/mm/mprotect.c
@@ -359,6 +359,9 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 	struct vm_area_struct *vma, *prev;
 	int error = -EINVAL;
 	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
+	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
+				(prot & PROT_READ);
+
 	prot &= ~(PROT_GROWSDOWN|PROT_GROWSUP);
 	if (grows == (PROT_GROWSDOWN|PROT_GROWSUP)) /* can't be both */
 		return -EINVAL;
@@ -375,11 +378,6 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		return -EINVAL;
 
 	reqprot = prot;
-	/*
-	 * Does the application expect PROT_READ to imply PROT_EXEC:
-	 */
-	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
-		prot |= PROT_EXEC;
 
 	down_write(&current->mm->mmap_sem);
 
@@ -414,6 +412,10 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 
 		/* Here we know that vma->vm_start <= nstart < vma->vm_end. */
 
+		/* Does the application expect PROT_READ to imply PROT_EXEC */
+		if (rier && (vma->vm_flags & VM_MAYEXEC))
+			prot |= PROT_EXEC;
+
 		newflags = calc_vm_prot_bits(prot, pkey);
 		newflags |= (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));
 
@@ -445,6 +447,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 			error = -ENOMEM;
 			goto out;
 		}
+		prot = reqprot;
 	}
 out:
 	up_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from kwapulinski.piotr@gmail.com are



From: akpm@linux-foundation.org
Subject: - mprotect-patch-for-use-by-slim.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:04 -0700
Message-ID: <200705222124.l4MLO5ph010084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756559AbXEVV2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mprotect patch for use by SLIM
has been removed from the -mm tree.  Its filename was
     mprotect-patch-for-use-by-slim.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: mprotect patch for use by SLIM
From: Kylene Jo Hall <kjhall@us.ibm.com>

This small patch makes mprotect available for use by SLIM for write
revocation.

Updated to allow the usage locking to work properly.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Cc: Dave Safford <safford@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <sergeh@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/mprotect.c      |   22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mprotect-patch-for-use-by-slim include/linux/mm.h
--- a/include/linux/mm.h~mprotect-patch-for-use-by-slim
+++ a/include/linux/mm.h
@@ -141,6 +141,8 @@ extern unsigned int kobjsize(const void 
 #define VM_EXEC		0x00000004
 #define VM_SHARED	0x00000008
 
+extern int do_mprotect(unsigned long start, size_t len, unsigned long prot);
+
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
 #define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
 #define VM_MAYWRITE	0x00000020
diff -puN mm/mprotect.c~mprotect-patch-for-use-by-slim mm/mprotect.c
--- a/mm/mprotect.c~mprotect-patch-for-use-by-slim
+++ a/mm/mprotect.c
@@ -19,6 +19,7 @@
 #include <linux/mempolicy.h>
 #include <linux/personality.h>
 #include <linux/syscalls.h>
+#include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <asm/uaccess.h>
@@ -213,9 +214,10 @@ fail:
 	vm_unacct_memory(charged);
 	return error;
 }
-
-asmlinkage long
-sys_mprotect(unsigned long start, size_t len, unsigned long prot)
+/*
+ * Call holding the current->mm->mmap_sem for writing
+ */
+int do_mprotect(unsigned long start, size_t len, unsigned long prot)
 {
 	unsigned long vm_flags, nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
@@ -245,8 +247,6 @@ sys_mprotect(unsigned long start, size_t
 
 	vm_flags = calc_vm_prot_bits(prot);
 
-	down_write(&current->mm->mmap_sem);
-
 	vma = find_vma_prev(current->mm, start, &prev);
 	error = -ENOMEM;
 	if (!vma)
@@ -309,6 +309,16 @@ sys_mprotect(unsigned long start, size_t
 		}
 	}
 out:
-	up_write(&current->mm->mmap_sem);
 	return error;
 }
+
+asmlinkage long
+sys_mprotect(unsigned long start, size_t len, unsigned long prot)
+{
+	int ret;
+
+	down_write(&current->mm->mmap_sem);
+	ret = do_mprotect(start, len, prot);
+	up_write(&current->mm->mmap_sem);
+	return ret;
+}
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

use-menuconfig-objects-ii-tpm.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-identifiers.patch
integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch

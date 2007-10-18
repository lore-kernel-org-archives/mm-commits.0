From: akpm@linux-foundation.org
Subject: - i386-convert-mm_context_t-semaphore-to-a-mutex.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:37 -0700
Message-ID: <200710180707.l9I77bsk031715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067AbXJRHIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@mandriva.com.br, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: convert mm_context_t semaphore to a mutex
has been removed from the -mm tree.  Its filename was
     i386-convert-mm_context_t-semaphore-to-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: convert mm_context_t semaphore to a mutex
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/i386_ksyms_32.c |    1 +
 arch/x86/kernel/ldt_32.c        |   14 +++++++-------
 arch/x86/kernel/ptrace_32.c     |    4 ++--
 arch/x86/mm/fault_32.c          |    4 ++--
 include/asm-x86/mmu_32.h        |    4 ++--
 5 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/x86/kernel/i386_ksyms_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/x86/kernel/i386_ksyms_32.c
--- a/arch/x86/kernel/i386_ksyms_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/x86/kernel/i386_ksyms_32.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
 
diff -puN arch/x86/kernel/ldt_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/x86/kernel/ldt_32.c
--- a/arch/x86/kernel/ldt_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/x86/kernel/ldt_32.c
@@ -92,13 +92,13 @@ int init_new_context(struct task_struct 
 	struct mm_struct * old_mm;
 	int retval = 0;
 
-	init_MUTEX(&mm->context.sem);
+	mutex_init(&mm->context.lock);
 	mm->context.size = 0;
 	old_mm = current->mm;
 	if (old_mm && old_mm->context.size > 0) {
-		down(&old_mm->context.sem);
+		mutex_lock(&old_mm->context.lock);
 		retval = copy_ldt(&mm->context, &old_mm->context);
-		up(&old_mm->context.sem);
+		mutex_unlock(&old_mm->context.lock);
 	}
 	return retval;
 }
@@ -130,7 +130,7 @@ static int read_ldt(void __user * ptr, u
 	if (bytecount > LDT_ENTRY_SIZE*LDT_ENTRIES)
 		bytecount = LDT_ENTRY_SIZE*LDT_ENTRIES;
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	size = mm->context.size*LDT_ENTRY_SIZE;
 	if (size > bytecount)
 		size = bytecount;
@@ -138,7 +138,7 @@ static int read_ldt(void __user * ptr, u
 	err = 0;
 	if (copy_to_user(ptr, mm->context.ldt, size))
 		err = -EFAULT;
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 	if (err < 0)
 		goto error_return;
 	if (size != bytecount) {
@@ -194,7 +194,7 @@ static int write_ldt(void __user * ptr, 
 			goto out;
 	}
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	if (ldt_info.entry_number >= mm->context.size) {
 		error = alloc_ldt(&current->mm->context, ldt_info.entry_number+1, 1);
 		if (error < 0)
@@ -221,7 +221,7 @@ install:
 	error = 0;
 
 out_unlock:
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 out:
 	return error;
 }
diff -puN arch/x86/kernel/ptrace_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/x86/kernel/ptrace_32.c
--- a/arch/x86/kernel/ptrace_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/x86/kernel/ptrace_32.c
@@ -165,7 +165,7 @@ static unsigned long convert_eip_to_line
 
 		seg &= ~7UL;
 
-		down(&child->mm->context.sem);
+		mutex_lock(&child->mm->context.lock);
 		if (unlikely((seg >> 3) >= child->mm->context.size))
 			addr = -1L; /* bogus selector, access would fault */
 		else {
@@ -179,7 +179,7 @@ static unsigned long convert_eip_to_line
 				addr &= 0xffff;
 			addr += base;
 		}
-		up(&child->mm->context.sem);
+		mutex_unlock(&child->mm->context.lock);
 	}
 	return addr;
 }
diff -puN arch/x86/mm/fault_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/x86/mm/fault_32.c
--- a/arch/x86/mm/fault_32.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/x86/mm/fault_32.c
@@ -105,7 +105,7 @@ static inline unsigned long get_segment_
 	   LDT and other horrors are only used in user space. */
 	if (seg & (1<<2)) {
 		/* Must lock the LDT while reading it. */
-		down(&current->mm->context.sem);
+		mutex_lock(&current->mm->context.lock);
 		desc = current->mm->context.ldt;
 		desc = (void *)desc + (seg & ~7);
 	} else {
@@ -118,7 +118,7 @@ static inline unsigned long get_segment_
 	base = get_desc_base((unsigned long *)desc);
 
 	if (seg & (1<<2)) { 
-		up(&current->mm->context.sem);
+		mutex_unlock(&current->mm->context.lock);
 	} else
 		put_cpu();
 
diff -puN include/asm-x86/mmu_32.h~i386-convert-mm_context_t-semaphore-to-a-mutex include/asm-x86/mmu_32.h
--- a/include/asm-x86/mmu_32.h~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/include/asm-x86/mmu_32.h
@@ -1,7 +1,7 @@
 #ifndef __i386_MMU_H
 #define __i386_MMU_H
 
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 /*
  * The i386 doesn't have a mmu context, but
  * we put the segment information here.
@@ -10,7 +10,7 @@
  */
 typedef struct { 
 	int size;
-	struct semaphore sem;
+	struct mutex lock;
 	void *ldt;
 	void *vdso;
 } mm_context_t;
_

Patches currently in -mm which might be from lcapitulino@mandriva.com.br are

origin.patch

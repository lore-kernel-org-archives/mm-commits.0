From: akpm@linux-foundation.org
Subject: + i386-convert-mm_context_t-semaphore-to-a-mutex.patch added to -mm tree
Date: Tue, 07 Aug 2007 12:30:58 -0700
Message-ID: <200708071930.l77JUwUU000317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbXHGTb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 15:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lcapitulino@mandriva.com.br, ak@suse.de, mingo@elte.hu


The patch titled
     i386: convert mm_context_t semaphore to a mutex
has been added to the -mm tree.  Its filename is
     i386-convert-mm_context_t-semaphore-to-a-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: convert mm_context_t semaphore to a mutex
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i386_ksyms.c |    1 +
 arch/i386/kernel/ldt.c        |   14 +++++++-------
 arch/i386/kernel/ptrace.c     |    4 ++--
 arch/i386/mm/fault.c          |    4 ++--
 include/asm-i386/mmu.h        |    4 ++--
 5 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/i386/kernel/i386_ksyms.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/i386/kernel/i386_ksyms.c
--- a/arch/i386/kernel/i386_ksyms.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/i386/kernel/i386_ksyms.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
 
diff -puN arch/i386/kernel/ldt.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/i386/kernel/ldt.c
--- a/arch/i386/kernel/ldt.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/i386/kernel/ldt.c
@@ -94,13 +94,13 @@ int init_new_context(struct task_struct 
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
@@ -132,7 +132,7 @@ static int read_ldt(void __user * ptr, u
 	if (bytecount > LDT_ENTRY_SIZE*LDT_ENTRIES)
 		bytecount = LDT_ENTRY_SIZE*LDT_ENTRIES;
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	size = mm->context.size*LDT_ENTRY_SIZE;
 	if (size > bytecount)
 		size = bytecount;
@@ -140,7 +140,7 @@ static int read_ldt(void __user * ptr, u
 	err = 0;
 	if (copy_to_user(ptr, mm->context.ldt, size))
 		err = -EFAULT;
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 	if (err < 0)
 		goto error_return;
 	if (size != bytecount) {
@@ -196,7 +196,7 @@ static int write_ldt(void __user * ptr, 
 			goto out;
 	}
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	if (ldt_info.entry_number >= mm->context.size) {
 		error = alloc_ldt(&current->mm->context, ldt_info.entry_number+1, 1);
 		if (error < 0)
@@ -223,7 +223,7 @@ install:
 	error = 0;
 
 out_unlock:
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 out:
 	return error;
 }
diff -puN arch/i386/kernel/ptrace.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/i386/kernel/ptrace.c
@@ -166,7 +166,7 @@ static unsigned long convert_eip_to_line
 
 		seg &= ~7UL;
 
-		down(&child->mm->context.sem);
+		mutex_lock(&child->mm->context.lock);
 		if (unlikely((seg >> 3) >= child->mm->context.size))
 			addr = -1L; /* bogus selector, access would fault */
 		else {
@@ -180,7 +180,7 @@ static unsigned long convert_eip_to_line
 				addr &= 0xffff;
 			addr += base;
 		}
-		up(&child->mm->context.sem);
+		mutex_unlock(&child->mm->context.lock);
 	}
 	return addr;
 }
diff -puN arch/i386/mm/fault.c~i386-convert-mm_context_t-semaphore-to-a-mutex arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/arch/i386/mm/fault.c
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
 
diff -puN include/asm-i386/mmu.h~i386-convert-mm_context_t-semaphore-to-a-mutex include/asm-i386/mmu.h
--- a/include/asm-i386/mmu.h~i386-convert-mm_context_t-semaphore-to-a-mutex
+++ a/include/asm-i386/mmu.h
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

i386-convert-mm_context_t-semaphore-to-a-mutex.patch

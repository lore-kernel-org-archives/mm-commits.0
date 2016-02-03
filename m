From: akpm@linux-foundation.org
Subject: + s390-query-dynamic-debug_pagealloc-setting.patch added to -mm
 tree
Date: Wed, 03 Feb 2016 15:09:32 -0800
Message-ID: <56b288ac.xDl1pOnK7u+URgpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbcBCXJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, js1304@gmail.com, labbott@fedoraproject.org, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: query dynamic DEBUG_PAGEALLOC setting
has been added to the -mm tree.  Its filename is
     s390-query-dynamic-debug_pagealloc-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-query-dynamic-debug_pagealloc-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-query-dynamic-debug_pagealloc-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: s390: query dynamic DEBUG_PAGEALLOC setting

We can use debug_pagealloc_enabled() to check if we can map the identity
mapping with 1MB/2GB pages as well as to print the current setting in
dump_stack.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/dumpstack.c |    6 +++---
 arch/s390/mm/vmem.c          |   10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/s390/kernel/dumpstack.c~s390-query-dynamic-debug_pagealloc-setting arch/s390/kernel/dumpstack.c
--- a/arch/s390/kernel/dumpstack.c~s390-query-dynamic-debug_pagealloc-setting
+++ a/arch/s390/kernel/dumpstack.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/kdebug.h>
 #include <linux/ptrace.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <asm/processor.h>
@@ -184,9 +185,8 @@ void die(struct pt_regs *regs, const cha
 #ifdef CONFIG_SMP
 	printk("SMP ");
 #endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
+	if (debug_pagealloc_enabled())
+		printk("DEBUG_PAGEALLOC");
 	printk("\n");
 	notify_die(DIE_OOPS, str, regs, 0, regs->int_code & 0xffff, SIGSEGV);
 	print_modules();
diff -puN arch/s390/mm/vmem.c~s390-query-dynamic-debug_pagealloc-setting arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~s390-query-dynamic-debug_pagealloc-setting
+++ a/arch/s390/mm/vmem.c
@@ -94,16 +94,15 @@ static int vmem_add_mem(unsigned long st
 			pgd_populate(&init_mm, pg_dir, pu_dir);
 		}
 		pu_dir = pud_offset(pg_dir, address);
-#ifndef CONFIG_DEBUG_PAGEALLOC
 		if (MACHINE_HAS_EDAT2 && pud_none(*pu_dir) && address &&
-		    !(address & ~PUD_MASK) && (address + PUD_SIZE <= end)) {
+		    !(address & ~PUD_MASK) && (address + PUD_SIZE <= end) &&
+		     !debug_pagealloc_enabled()) {
 			pud_val(*pu_dir) = __pa(address) |
 				_REGION_ENTRY_TYPE_R3 | _REGION3_ENTRY_LARGE |
 				(ro ? _REGION_ENTRY_PROTECT : 0);
 			address += PUD_SIZE;
 			continue;
 		}
-#endif
 		if (pud_none(*pu_dir)) {
 			pm_dir = vmem_pmd_alloc();
 			if (!pm_dir)
@@ -111,9 +110,9 @@ static int vmem_add_mem(unsigned long st
 			pud_populate(&init_mm, pu_dir, pm_dir);
 		}
 		pm_dir = pmd_offset(pu_dir, address);
-#ifndef CONFIG_DEBUG_PAGEALLOC
 		if (MACHINE_HAS_EDAT1 && pmd_none(*pm_dir) && address &&
-		    !(address & ~PMD_MASK) && (address + PMD_SIZE <= end)) {
+		    !(address & ~PMD_MASK) && (address + PMD_SIZE <= end) &&
+		    !debug_pagealloc_enabled()) {
 			pmd_val(*pm_dir) = __pa(address) |
 				_SEGMENT_ENTRY | _SEGMENT_ENTRY_LARGE |
 				_SEGMENT_ENTRY_YOUNG |
@@ -121,7 +120,6 @@ static int vmem_add_mem(unsigned long st
 			address += PMD_SIZE;
 			continue;
 		}
-#endif
 		if (pmd_none(*pm_dir)) {
 			pt_dir = vmem_pte_alloc(address);
 			if (!pt_dir)
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch
x86-query-dynamic-debug_pagealloc-setting.patch
s390-query-dynamic-debug_pagealloc-setting.patch
x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch


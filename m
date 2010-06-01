From: akpm@linux-foundation.org
Subject: + mm-provide-init_mm-mm_context-initializer.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:25:05 -0700
Message-ID: <201006012125.o51LP5Pf019685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab0FAVZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:25:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, adobriyan@gmail.com, schwidefsky@de.ibm.com, suzuki@in.ibm.com


The patch titled
     From: Heiko Carstens <heiko.carstens@de.ibm.com>
has been added to the -mm tree.  Its filename is
     mm-provide-init_mm-mm_context-initializer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Heiko Carstens <heiko.carstens@de.ibm.com>


Provide an INIT_MM_CONTEXT intializer macro which can be used to
statically initialize mm_struct:mm_context of init_mm.  This way we
can get rid of code which will do the initialization at run time (on
s390).
In addition the current code can be found at a place where it is not
expected.  So let's have a common initializer which architectures
can use if needed.

This is based on a patch from Suzuki Poulose.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Suzuki Poulose <suzuki@in.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/mmu.h |    5 +++++
 arch/s390/mm/vmem.c         |    4 ----
 mm/init-mm.c                |    6 ++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/s390/include/asm/mmu.h~mm-provide-init_mm-mm_context-initializer arch/s390/include/asm/mmu.h
--- a/arch/s390/include/asm/mmu.h~mm-provide-init_mm-mm_context-initializer
+++ a/arch/s390/include/asm/mmu.h
@@ -13,4 +13,9 @@ typedef struct {
 	int alloc_pgste; /* cloned contexts will have extended page tables */
 } mm_context_t;
 
+#define INIT_MM_CONTEXT(name)						      \
+	.context.list_lock    = __SPIN_LOCK_UNLOCKED(name.context.list_lock), \
+	.context.crst_list    = LIST_HEAD_INIT(name.context.crst_list),	      \
+	.context.pgtable_list = LIST_HEAD_INIT(name.context.pgtable_list),
+
 #endif
diff -puN arch/s390/mm/vmem.c~mm-provide-init_mm-mm_context-initializer arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~mm-provide-init_mm-mm_context-initializer
+++ a/arch/s390/mm/vmem.c
@@ -332,10 +332,6 @@ void __init vmem_map_init(void)
 	unsigned long start, end;
 	int i;
 
-	spin_lock_init(&init_mm.context.list_lock);
-	INIT_LIST_HEAD(&init_mm.context.crst_list);
-	INIT_LIST_HEAD(&init_mm.context.pgtable_list);
-	init_mm.context.noexec = 0;
 	ro_start = ((unsigned long)&_stext) & PAGE_MASK;
 	ro_end = PFN_ALIGN((unsigned long)&_eshared);
 	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++) {
diff -puN mm/init-mm.c~mm-provide-init_mm-mm_context-initializer mm/init-mm.c
--- a/mm/init-mm.c~mm-provide-init_mm-mm_context-initializer
+++ a/mm/init-mm.c
@@ -7,6 +7,11 @@
 
 #include <asm/atomic.h>
 #include <asm/pgtable.h>
+#include <asm/mmu.h>
+
+#ifndef INIT_MM_CONTEXT
+#define INIT_MM_CONTEXT(name)
+#endif
 
 struct mm_struct init_mm = {
 	.mm_rb		= RB_ROOT,
@@ -17,4 +22,5 @@ struct mm_struct init_mm = {
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
 	.cpu_vm_mask	= CPU_MASK_ALL,
+	INIT_MM_CONTEXT(init_mm)
 };
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call.patch
ramoops-add-has_iomem-dependency.patch
linux-next.patch
drivers-s390-net-use-memdup_user.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-provide-init_mm-mm_context-initializer.patch


From: akpm@linux-foundation.org
Subject: - misc-removal-of-final-callers-using-fastcall.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:42 -0800
Message-ID: <200802082015.m18KFNFi010592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYBHUp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     misc: removal of final callers using fastcall
has been removed from the -mm tree.  Its filename was
     misc-removal-of-final-callers-using-fastcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: removal of final callers using fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/irq.c |    2 +-
 include/asm-arm/mutex.h   |    6 +++---
 mm/page_alloc.c           |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/sparc64/kernel/irq.c~misc-removal-of-final-callers-using-fastcall arch/sparc64/kernel/irq.c
--- a/arch/sparc64/kernel/irq.c~misc-removal-of-final-callers-using-fastcall
+++ a/arch/sparc64/kernel/irq.c
@@ -522,7 +522,7 @@ static struct irq_chip sun4v_virq = {
 	.set_affinity	= sun4v_virt_set_affinity,
 };
 
-static void fastcall pre_flow_handler(unsigned int virt_irq,
+static void pre_flow_handler(unsigned int virt_irq,
 				      struct irq_desc *desc)
 {
 	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
diff -puN include/asm-arm/mutex.h~misc-removal-of-final-callers-using-fastcall include/asm-arm/mutex.h
--- a/include/asm-arm/mutex.h~misc-removal-of-final-callers-using-fastcall
+++ a/include/asm-arm/mutex.h
@@ -24,7 +24,7 @@
  * reattempted until it succeeds.
  */
 static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	int __ex_flag, __res;
 
@@ -44,7 +44,7 @@ __mutex_fastpath_lock(atomic_t *count, f
 }
 
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	int __ex_flag, __res;
 
@@ -70,7 +70,7 @@ __mutex_fastpath_lock_retval(atomic_t *c
  * better generated assembly.
  */
 static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	int __ex_flag, __res, __orig;
 
diff -puN mm/page_alloc.c~misc-removal-of-final-callers-using-fastcall mm/page_alloc.c
--- a/mm/page_alloc.c~misc-removal-of-final-callers-using-fastcall
+++ a/mm/page_alloc.c
@@ -1451,7 +1451,7 @@ try_next_zone:
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page * fastcall
+struct page *
 __alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct zonelist *zonelist)
 {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch

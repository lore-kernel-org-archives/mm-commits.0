From: akpm@linux-foundation.org
Subject: + misc-removal-of-final-callers-using-fastcall.patch added to -mm tree
Date: Thu, 20 Dec 2007 18:28:03 -0800
Message-ID: <200712210228.lBL2S3hi025459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbXLUC2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 21:28:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     misc: removal of final callers using fastcall
has been added to the -mm tree.  Its filename is
     misc-removal-of-final-callers-using-fastcall.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: misc: removal of final callers using fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/uic.c |    2 +-
 arch/sparc64/kernel/irq.c |    2 +-
 include/asm-arm/mutex.h   |    6 +++---
 mm/page_alloc.c           |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/sysdev/uic.c~misc-removal-of-final-callers-using-fastcall arch/powerpc/sysdev/uic.c
--- a/arch/powerpc/sysdev/uic.c~misc-removal-of-final-callers-using-fastcall
+++ a/arch/powerpc/sysdev/uic.c
@@ -188,7 +188,7 @@ static struct irq_chip uic_irq_chip = {
  * instead of the end, to keep the window in which we can miss an
  * interrupt as small as possible.
  */
-void fastcall handle_uic_irq(unsigned int irq, struct irq_desc *desc)
+void handle_uic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
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

git-net.patch
git-sh.patch
git-x86.patch
mm-remove-fastcall-from-mm.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
asm-generic-remove-fastcall.patch
misc-removal-of-final-callers-using-fastcall.patch

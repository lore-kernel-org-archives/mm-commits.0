From: akpm@linux-foundation.org
Subject: - uml-fix-inlines.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:57 -0700
Message-ID: <200710162037.l9GKbvit015330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932477AbXJPVXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, bunk@kernel.org, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix inlines
has been removed from the -mm tree.  Its filename was
     uml-fix-inlines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix inlines
From: Jeff Dike <jdike@addtoit.com>

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgalloc.h          |    2 +-
 include/asm-um/pgtable-3level.h   |    2 +-
 include/asm-um/processor-x86_64.h |    2 +-
 include/asm-um/smp.h              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-um/pgalloc.h~uml-fix-inlines include/asm-um/pgalloc.h
--- a/include/asm-um/pgalloc.h~uml-fix-inlines
+++ a/include/asm-um/pgalloc.h
@@ -42,7 +42,7 @@ static inline void pte_free(struct page 
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
 
-extern __inline__ void pmd_free(pmd_t *pmd)
+static inline void pmd_free(pmd_t *pmd)
 {
 	free_page((unsigned long)pmd);
 }
diff -puN include/asm-um/pgtable-3level.h~uml-fix-inlines include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-fix-inlines
+++ a/include/asm-um/pgtable-3level.h
@@ -69,7 +69,7 @@ static inline pmd_t *pmd_alloc_one(struc
         return pmd;
 }
 
-extern inline void pud_clear (pud_t *pud)
+static inline void pud_clear (pud_t *pud)
 {
         set_pud(pud, __pud(0));
 }
diff -puN include/asm-um/processor-x86_64.h~uml-fix-inlines include/asm-um/processor-x86_64.h
--- a/include/asm-um/processor-x86_64.h~uml-fix-inlines
+++ a/include/asm-um/processor-x86_64.h
@@ -18,7 +18,7 @@ struct arch_thread {
 };
 
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
-extern inline void rep_nop(void)
+static inline void rep_nop(void)
 {
 	__asm__ __volatile__("rep;nop": : :"memory");
 }
diff -puN include/asm-um/smp.h~uml-fix-inlines include/asm-um/smp.h
--- a/include/asm-um/smp.h~uml-fix-inlines
+++ a/include/asm-um/smp.h
@@ -18,7 +18,7 @@ extern int hard_smp_processor_id(void);
 extern int ncpus;
 
 
-extern inline void smp_cpus_done(unsigned int maxcpus)
+static inline void smp_cpus_done(unsigned int maxcpus)
 {
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch

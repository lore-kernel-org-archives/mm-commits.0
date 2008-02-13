From: akpm@linux-foundation.org
Subject: - add-pgtable_t-to-nommu-architectures.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:20 -0800
Message-ID: <200802132015.m1DKFKjk011358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbYBMUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add pgtable_t to remaining nommu architectures
has been removed from the -mm tree.  Its filename was
     add-pgtable_t-to-nommu-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add pgtable_t to remaining nommu architectures
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The pte_fn_t in include/linux/mm.h make it necessary for all architectures
to define a pgtable_t type, even those that do not have an mmu.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/page.h |    1 +
 include/asm-h8300/page.h    |    1 +
 include/asm-v850/page.h     |    1 +
 3 files changed, 3 insertions(+)

diff -puN include/asm-blackfin/page.h~add-pgtable_t-to-nommu-architectures include/asm-blackfin/page.h
--- a/include/asm-blackfin/page.h~add-pgtable_t-to-nommu-architectures
+++ a/include/asm-blackfin/page.h
@@ -39,6 +39,7 @@ typedef struct {
 typedef struct {
 	unsigned long pgprot;
 } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])
diff -puN include/asm-h8300/page.h~add-pgtable_t-to-nommu-architectures include/asm-h8300/page.h
--- a/include/asm-h8300/page.h~add-pgtable_t-to-nommu-architectures
+++ a/include/asm-h8300/page.h
@@ -31,6 +31,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd[16]; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])
diff -puN include/asm-v850/page.h~add-pgtable_t-to-nommu-architectures include/asm-v850/page.h
--- a/include/asm-v850/page.h~add-pgtable_t-to-nommu-architectures
+++ a/include/asm-v850/page.h
@@ -57,6 +57,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

git-s390.patch
percpu-fix-debug_preempt-per_cpu-checking.patch

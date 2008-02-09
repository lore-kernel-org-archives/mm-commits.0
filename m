From: akpm@linux-foundation.org
Subject: + add-pgtable_t-to-nommu-architectures.patch added to -mm tree
Date: Sat, 09 Feb 2008 03:12:51 -0800
Message-ID: <200802091113.m19BDddY010571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbYBILPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 06:15:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com


The patch titled
     Add pgtable_t to remaining nommu architectures
has been added to the -mm tree.  Its filename is
     add-pgtable_t-to-nommu-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
x86-fix-pgtable_t-build-breakage.patch
m68knommu-compile-error.patch
add-pgtable_t-to-nommu-architectures.patch
git-s390.patch
git-sched.patch

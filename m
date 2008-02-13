From: akpm@linux-foundation.org
Subject: - m68knommu-compile-error.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:17 -0800
Message-ID: <200802132015.m1DKFHCW011355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042AbYBMUPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     m68knommu: add pgtable_t
has been removed from the -mm tree.  Its filename was
     m68knommu-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: add pgtable_t
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

  CC      init/main.o
In file included from include2/asm/uaccess.h:8,
                 from include/linux/poll.h:13,
                 from include/linux/rtc.h:113,
                 from include/linux/efi.h:19,
                 from linux-2.6/init/main.c:43:
include/linux/mm.h:1151:
error: expected declaration specifiers or '...' before 'pgtable_t'

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/page.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-m68knommu/page.h~m68knommu-compile-error include/asm-m68knommu/page.h
--- a/include/asm-m68knommu/page.h~m68knommu-compile-error
+++ a/include/asm-m68knommu/page.h
@@ -31,6 +31,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd[16]; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

git-s390.patch
percpu-fix-debug_preempt-per_cpu-checking.patch

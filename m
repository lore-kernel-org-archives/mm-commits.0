From: akpm@linux-foundation.org
Subject: + m68knommu-compile-error.patch added to -mm tree
Date: Sat, 09 Feb 2008 03:09:59 -0800
Message-ID: <200802091110.m19BAmre010442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbYBILRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 06:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com, bunk@stusta.de


The patch titled
     m68knommu: add pgtable_t
has been added to the -mm tree.  Its filename is
     m68knommu-compile-error.patch

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

origin.patch
x86-fix-pgtable_t-build-breakage.patch
m68knommu-compile-error.patch
git-s390.patch
git-sched.patch

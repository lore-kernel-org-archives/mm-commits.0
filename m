From: akpm@linux-foundation.org
Subject: + mm-x86-fix-native_pud_clear-build-error.patch added to -mm tree
Date: Tue, 14 Mar 2017 14:01:08 -0700
Message-ID: <58c85a14.6R8Dc1F0kdjeof7n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbdCNVBK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:01:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bp@suse.de, dave.hansen@linux.intel.com, dave.jiang@intel.com, hpa@zytor.com, hughd@google.com, keescook@chromium.org, mawilcox@microsoft.com, mingo@redhat.com, tglx@linutronix.de, thgarnie@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: fix native_pud_clear build error
has been added to the -mm tree.  Its filename is
     mm-x86-fix-native_pud_clear-build-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-fix-native_pud_clear-build-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-fix-native_pud_clear-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm, x86: fix native_pud_clear build error

We still get a build error in random configurations, after this has been
modified a few times:

In file included from include/linux/mm.h:68:0,
                 from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets.c:12:
arch/x86/include/asm/pgtable.h:66:26: error: redefinition of 'native_pud_clear'
 #define pud_clear(pud)   native_pud_clear(pud)

My interpretation is that the build error comes from a typo in __PAGETABLE_PUD_FOLDED,
so fix that typo now, and remove the incorrect #ifdef around the native_pud_clear
definition.

Fixes: 3e761a42e19c ("mm, x86: fix HIGHMEM64 && PARAVIRT build config for native_pud_clear()")
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Link: http://lkml.kernel.org/r/20170314121330.182155-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Ackedy-by: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    3 ---
 arch/x86/include/asm/pgtable.h        |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/x86/include/asm/pgtable-3level.h~mm-x86-fix-native_pud_clear-build-error arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~mm-x86-fix-native_pud_clear-build-error
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -121,12 +121,9 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
-#if !defined(CONFIG_SMP) || (defined(CONFIG_HIGHMEM64G) && \
-		defined(CONFIG_PARAVIRT))
 static inline void native_pud_clear(pud_t *pudp)
 {
 }
-#endif
 
 static inline void pud_clear(pud_t *pudp)
 {
diff -puN arch/x86/include/asm/pgtable.h~mm-x86-fix-native_pud_clear-build-error arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-x86-fix-native_pud_clear-build-error
+++ a/arch/x86/include/asm/pgtable.h
@@ -62,7 +62,7 @@ extern struct mm_struct *pgd_page_get_mm
 # define set_pud(pudp, pud)		native_set_pud(pudp, pud)
 #endif
 
-#ifndef __PAGETABLE_PMD_FOLDED
+#ifndef __PAGETABLE_PUD_FOLDED
 #define pud_clear(pud)			native_pud_clear(pud)
 #endif
 
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-x86-fix-native_pud_clear-build-error.patch


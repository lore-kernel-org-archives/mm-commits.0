From: akpm@linux-foundation.org
Subject: + x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache.patch added to -mm tree
Date: Tue, 25 Mar 2008 18:58:20 -0700
Message-ID: <200803260158.m2Q1wKvY024677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbYCZB7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 21:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, arjan@linux.intel.com, bug-track@fisher-privat.net, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     x86: revert to the UC- behavior for ioremap()/ioremap_nocache()
has been added to the -mm tree.  Its filename is
     x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache.patch

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
Subject: x86: revert to the UC- behavior for ioremap()/ioremap_nocache()
From: Suresh Siddha <suresh.b.siddha@intel.com>

fb drivers are using ioremap()/ioremap_nocache(), followed by mtrr_add with WC
attribute.  Recent changes in page attribute code made both
ioremap()/ioremap_nocache() mappings as UC (instead of previous UC-).  This
breaks the graphics performance, as the effective memory type is UC instead of
expected WC.

The correct way to fix this is to add ioremap_wc() (which uses UC- in the
absence of PAT kernel support and WC with PAT) and change all the fb drivers
to use this new ioremap_wc() API.

We can take this correct and longer route for post 2.6.25. For now,
revert back to the UC- behavior for ioremap/ioremap_nocache.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10328

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c     |    6 +++++-
 include/asm-x86/pgtable.h |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/ioremap.c~x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache
+++ a/arch/x86/mm/ioremap.c
@@ -137,7 +137,11 @@ static void __iomem *__ioremap(resource_
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		/*
+		 * FIXME: we will use UC MINUS for now, as video fb drivers
+		 * depend on it. Upcoming ioremap_wc() will fix this behavior.
+		 */
+		prot = PAGE_KERNEL_UC_MINUS;
 		break;
 	case IOR_MODE_CACHED:
 		prot = PAGE_KERNEL;
diff -puN include/asm-x86/pgtable.h~x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h~x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache
+++ a/include/asm-x86/pgtable.h
@@ -85,6 +85,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KE
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
@@ -101,6 +102,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KE
 #define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_UC_MINUS		MAKE_GLOBAL(__PAGE_KERNEL_UC_MINUS)
 #define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86-revert-to-the-uc-behavior-for-ioremap-ioremap_nocache.patch


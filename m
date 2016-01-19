From: akpm@linux-foundation.org
Subject: [merged] x86-mm-introduce-_page_devmap.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:13:38 -0800
Message-ID: <569e98f2.UBeG8J6JEWAiYsHJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: introduce _PAGE_DEVMAP
has been removed from the -mm tree.  Its filename was
     x86-mm-introduce-_page_devmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: x86, mm: introduce _PAGE_DEVMAP

_PAGE_DEVMAP is a hardware-unused pte bit that will later be used in the
get_user_pages() path to identify pfns backed by the dynamic allocation
established by devm_memremap_pages.  Upon seeing that bit the gup path
will lookup and pin the allocation while the pages are in use.

Since the _PAGE_DEVMAP bit is > 32 it must be cast to u64 instead of a
pteval_t to allow pmd_flags() usage in the realmode boot code to build.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_types.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable_types.h~x86-mm-introduce-_page_devmap arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~x86-mm-introduce-_page_devmap
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -24,7 +24,9 @@
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_HIDDEN	_PAGE_BIT_SOFTW3 /* hidden by kmemcheck */
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
-#define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
+#define _PAGE_BIT_SOFTW4	58	/* available for programmer */
+#define _PAGE_BIT_DEVMAP		_PAGE_BIT_SOFTW4
+#define _PAGE_BIT_NX		63	/* No execute: only valid after cpuid check */
 
 /* If _PAGE_BIT_PRESENT is clear, we use these: */
 /* - if the user mapped it with PROT_NONE; pte_present gives true */
@@ -83,8 +85,11 @@
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AT(pteval_t, 1) << _PAGE_BIT_NX)
+#define _PAGE_DEVMAP	(_AT(u64, 1) << _PAGE_BIT_DEVMAP)
+#define __HAVE_ARCH_PTE_DEVMAP
 #else
 #define _PAGE_NX	(_AT(pteval_t, 0))
+#define _PAGE_DEVMAP	(_AT(pteval_t, 0))
 #endif
 
 #define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch


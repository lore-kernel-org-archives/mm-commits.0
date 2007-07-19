From: akpm@linux-foundation.org
Subject: - i386-minor-nx-handling-adjustment.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:00 -0700
Message-ID: <200707192010.l6JKA0dn020626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761390AbXGSUQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     i386: minor nx handling adjustment
has been removed from the -mm tree.  Its filename was
     i386-minor-nx-handling-adjustment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: minor nx handling adjustment
From: "Jan Beulich" <jbeulich@novell.com>

Constrain __supported_pte_mask and NX handling to just the PAE kernel.

[jeremy@goop.org: add missing include]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/init.c     |    7 ++++---
 include/asm-i386/page.h |    1 -
 include/xen/page.h      |    1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/i386/mm/init.c~i386-minor-nx-handling-adjustment arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~i386-minor-nx-handling-adjustment
+++ a/arch/i386/mm/init.c
@@ -472,6 +472,10 @@ void zap_low_mappings (void)
 	flush_tlb_all();
 }
 
+int nx_enabled = 0;
+
+#ifdef CONFIG_X86_PAE
+
 static int disable_nx __initdata = 0;
 u64 __supported_pte_mask __read_mostly = ~_PAGE_NX;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
@@ -501,9 +505,6 @@ static int __init noexec_setup(char *str
 }
 early_param("noexec", noexec_setup);
 
-int nx_enabled = 0;
-#ifdef CONFIG_X86_PAE
-
 static void __init set_nx(void)
 {
 	unsigned int v[4], l, h;
diff -puN include/asm-i386/page.h~i386-minor-nx-handling-adjustment include/asm-i386/page.h
--- a/include/asm-i386/page.h~i386-minor-nx-handling-adjustment
+++ a/include/asm-i386/page.h
@@ -44,7 +44,6 @@
 extern int nx_enabled;
 
 #ifdef CONFIG_X86_PAE
-extern unsigned long long __supported_pte_mask;
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;
diff -puN include/xen/page.h~i386-minor-nx-handling-adjustment include/xen/page.h
--- a/include/xen/page.h~i386-minor-nx-handling-adjustment
+++ a/include/xen/page.h
@@ -4,6 +4,7 @@
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 #include <xen/features.h>
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-kbuild.patch

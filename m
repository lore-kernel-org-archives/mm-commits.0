From: akpm@linux-foundation.org
Subject: + x86-simplify-highmem-related-kconfig-entries.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:00:12 -0800
Message-ID: <200901160000.n0G00Cux027724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762955AbZAPAAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:00:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, andi@firstfloor.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: simplify HIGHMEM-related Kconfig entries
has been added to the -mm tree.  Its filename is
     x86-simplify-highmem-related-kconfig-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: simplify HIGHMEM-related Kconfig entries
From: "Jan Beulich" <jbeulich@novell.com>

Additionally remove the dependency of X86_PAE on !HIGHMEM4G - at least
I can't understand why that dependency existed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~x86-simplify-highmem-related-kconfig-entries arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-simplify-highmem-related-kconfig-entries
+++ a/arch/x86/Kconfig
@@ -896,8 +896,8 @@ config X86_CPUID
 
 choice
 	prompt "High Memory Support"
-	default HIGHMEM4G if !X86_NUMAQ
 	default HIGHMEM64G if X86_NUMAQ
+	default HIGHMEM4G
 	depends on X86_32
 
 config NOHIGHMEM
@@ -1004,7 +1004,7 @@ config HIGHMEM
 
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
-	depends on X86_32 && !HIGHMEM4G
+	depends on X86_32
 	help
 	  PAE is required for NX support, and furthermore enables
 	  larger swapspace support for non-overcommit purposes. It
@@ -1152,7 +1152,7 @@ source "mm/Kconfig"
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
-	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
+	depends on HIGHMEM
 	help
 	  The VM uses one page table entry for each page of physical memory.
 	  For systems with a lot of RAM, this can be wasteful of precious
_

Patches currently in -mm which might be from jbeulich@novell.com are

i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region.patch
x86-fully-honor-nolapic.patch
x86-avoid-early-crash-in-disable_local_apic.patch
x86-simplify-highmem-related-kconfig-entries.patch


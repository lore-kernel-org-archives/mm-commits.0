From: akpm@linux-foundation.org
Subject: [merged] mmx86um-move-cmpxchg_local-config-option.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:54 -0800
Message-ID: <20120113203155.239E75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56633 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab2AMUb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:57 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23612eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, cl@linux.com, hpa@zytor.com, mingo@elte.hu, penberg@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,x86,um: move CMPXCHG_LOCAL config option
has been removed from the -mm tree.  Its filename was
     mmx86um-move-cmpxchg_local-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm,x86,um: move CMPXCHG_LOCAL config option

Move CMPXCHG_LOCAL and rename it to HAVE_CMPXCHG_LOCAL so architectures
can simply select the option if it is supported.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig         |    3 +++
 arch/x86/Kconfig     |    1 +
 arch/x86/Kconfig.cpu |    3 ---
 arch/x86/um/Kconfig  |    4 ----
 mm/vmstat.c          |    2 +-
 5 files changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/Kconfig~mmx86um-move-cmpxchg_local-config-option arch/Kconfig
--- a/arch/Kconfig~mmx86um-move-cmpxchg_local-config-option
+++ a/arch/Kconfig
@@ -193,4 +193,7 @@ config HAVE_ALIGNED_STRUCT_PAGE
 	  on a struct page for better performance. However selecting this
 	  might increase the size of a struct page by a word.
 
+config HAVE_CMPXCHG_LOCAL
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/x86/Kconfig~mmx86um-move-cmpxchg_local-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~mmx86um-move-cmpxchg_local-config-option
+++ a/arch/x86/Kconfig
@@ -61,6 +61,7 @@ config X86
 	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
+	select HAVE_CMPXCHG_LOCAL if !M386
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
diff -puN arch/x86/Kconfig.cpu~mmx86um-move-cmpxchg_local-config-option arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu~mmx86um-move-cmpxchg_local-config-option
+++ a/arch/x86/Kconfig.cpu
@@ -309,9 +309,6 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
 
-config CMPXCHG_LOCAL
-	def_bool X86_64 || (X86_32 && !M386)
-
 config CMPXCHG_DOUBLE
 	def_bool y
 
diff -puN arch/x86/um/Kconfig~mmx86um-move-cmpxchg_local-config-option arch/x86/um/Kconfig
--- a/arch/x86/um/Kconfig~mmx86um-move-cmpxchg_local-config-option
+++ a/arch/x86/um/Kconfig
@@ -6,10 +6,6 @@ menu "UML-specific options"
 
 menu "Host processor type and features"
 
-config CMPXCHG_LOCAL
-	bool
-	default n

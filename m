From: akpm@linux-foundation.org
Subject: + mmx86um-move-cmpxchg_local-config-option.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:52:46 -0800
Message-ID: <201111102252.pAAMqkff002777@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wy0-f202.google.com ([74.125.82.202]:34226 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1KJWwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:52:49 -0500
Received: by mail-wy0-f202.google.com with SMTP id 8so79478wyg.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:52:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, cl@linux.com, hpa@zytor.com, mingo@elte.hu, penberg@kernel.org, tglx@linutronix.de


The patch titled
     Subject: mm,x86,um: move CMPXCHG_LOCAL config option
has been added to the -mm tree.  Its filename is
     mmx86um-move-cmpxchg_local-config-option.patch

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
@@ -77,6 +77,7 @@ config X86
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
+	select HAVE_CMPXCHG_LOCAL if !M386
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
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
-
 config CMPXCHG_DOUBLE
 	bool
 	default n
diff -puN mm/vmstat.c~mmx86um-move-cmpxchg_local-config-option mm/vmstat.c
--- a/mm/vmstat.c~mmx86um-move-cmpxchg_local-config-option
+++ a/mm/vmstat.c
@@ -295,7 +295,7 @@ void __dec_zone_page_state(struct page *
 }
 EXPORT_SYMBOL(__dec_zone_page_state);
 
-#ifdef CONFIG_CMPXCHG_LOCAL
+#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
 /*
  * If we have cmpxchg_local support then we do not need to incur the overhead
  * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
_
Subject: Subject: mm,x86,um: move CMPXCHG_LOCAL config option

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local.patch
mmx86um-move-cmpxchg_local-config-option.patch
mmx86um-move-cmpxchg_double-config-option.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
kdump-add-udev-events-for-memory-online-offline.patch


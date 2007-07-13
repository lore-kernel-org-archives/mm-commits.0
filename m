From: akpm@linux-foundation.org
Subject: + kprobes-on-select-architectures-no-longer-experimental.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:20:26 -0700
Message-ID: <200707130520.l6D5KQYB030343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbXGMFVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, ak@suse.de, benh@kernel.crashing.org, paulus@samba.org, tony.luck@intel.com


The patch titled
     Kprobes on select architectures no longer EXPERIMENTAL
has been added to the -mm tree.  Its filename is
     kprobes-on-select-architectures-no-longer-experimental.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kprobes on select architectures no longer EXPERIMENTAL
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Based on usage and testing over the past couple of years, kprobes on
i386, ia64, powerpc and x86_64 is no longer EXPERIMENTAL.

This is a follow-up to Robert P.J. Day's patch making "Instrumentation
support" non-EXPERIMENTAL:

	http://marc.info/?l=linux-kernel&m=118396955423812&w=2

Arch maintainers for sparc64, avr32 and s390 need to take a similar call.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig    |    4 ++--
 arch/ia64/Kconfig    |    4 ++--
 arch/powerpc/Kconfig |    4 ++--
 arch/x86_64/Kconfig  |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/i386/Kconfig~kprobes-on-select-architectures-no-longer-experimental arch/i386/Kconfig
--- a/arch/i386/Kconfig~kprobes-on-select-architectures-no-longer-experimental
+++ a/arch/i386/Kconfig
@@ -1251,8 +1251,8 @@ if INSTRUMENTATION
 source "arch/i386/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/ia64/Kconfig~kprobes-on-select-architectures-no-longer-experimental arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kprobes-on-select-architectures-no-longer-experimental
+++ a/arch/ia64/Kconfig
@@ -585,8 +585,8 @@ menu "Instrumentation Support"
 source "arch/ia64/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/powerpc/Kconfig~kprobes-on-select-architectures-no-longer-experimental arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kprobes-on-select-architectures-no-longer-experimental
+++ a/arch/powerpc/Kconfig
@@ -638,8 +638,8 @@ menu "Instrumentation Support"
 source "arch/powerpc/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on !BOOKE && !4xx && KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on !BOOKE && !4xx && KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/x86_64/Kconfig~kprobes-on-select-architectures-no-longer-experimental arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~kprobes-on-select-architectures-no-longer-experimental
+++ a/arch/x86_64/Kconfig
@@ -802,8 +802,8 @@ menu "Instrumentation Support"
 source "arch/x86_64/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-on-select-architectures-no-longer-experimental.patch
jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch

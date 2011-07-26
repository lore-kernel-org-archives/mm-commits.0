From: akpm@linux-foundation.org
Subject: [merged] um-fix-_fortify_source=2-support-for-kernel-modules.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:24 -0700
Message-ID: <201107260753.p6Q7rRqk003232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221Ab1GZHy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, florian@openwrt.org, geert@linux-m68k.org, vitalivanov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     um: fix _FORTIFY_SOURCE=2 support for kernel modules
has been removed from the -mm tree.  Its filename was
     um-fix-_fortify_source=2-support-for-kernel-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix _FORTIFY_SOURCE=2 support for kernel modules
From: Richard Weinberger <richard@nod.at>

When UML is compiled with _FORTIFY_SOURCE we have to export all _chk()
functions which are used in modules.  For now it's only the case for
__sprintf_chk().

Tested-by: Florian Fainelli <florian@openwrt.org>
Reported-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/user_syms.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/um/os-Linux/user_syms.c~um-fix-_fortify_source=2-support-for-kernel-modules arch/um/os-Linux/user_syms.c
--- a/arch/um/os-Linux/user_syms.c~um-fix-_fortify_source=2-support-for-kernel-modules
+++ a/arch/um/os-Linux/user_syms.c
@@ -113,3 +113,8 @@ EXPORT_SYMBOL(__stack_smash_handler);
 
 extern long __guard __attribute__((weak));
 EXPORT_SYMBOL(__guard);
+
+#ifdef _FORTIFY_SOURCE
+extern int __sprintf_chk(char *str, int flag, size_t strlen, const char *format);
+EXPORT_SYMBOL(__sprintf_chk);
+#endif
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch


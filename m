From: akpm@linux-foundation.org
Subject: + um-fix-_fortify_source=2-support-for-kernel-modules.patch added to -mm tree
Date: Tue, 28 Jun 2011 15:56:16 -0700
Message-ID: <201106282256.p5SMuGhL012524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab1F1W42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 18:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, florian@openwrt.org


The patch titled
     um: fix _FORTIFY_SOURCE=2 support for kernel modules
has been added to the -mm tree.  Its filename is
     um-fix-_fortify_source=2-support-for-kernel-modules.patch

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
Subject: um: fix _FORTIFY_SOURCE=2 support for kernel modules
From: Richard Weinberger <richard@nod.at>

When UML is compiled with _FORTIFY_SOURCE we have to export all _chk()
functions which are used in modules.  For now it's only the case for
__sprintf_chk().

Tested-by: Florian Fainelli <florian@openwrt.org>
Reported-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
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

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch


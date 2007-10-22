From: akpm@linux-foundation.org
Subject: + powerpc-switch-to-generic-warn_on-bug_on.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:59:48 -0700
Message-ID: <200710222259.l9MMxmIh020274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbXJVW74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, benh@kernel.crashing.org, linux-arch@vger.kernel.org, paulus@samba.org, scottwood@freescale.com


The patch titled
     powerpc: switch to generic WARN_ON()/BUG_ON()
has been added to the -mm tree.  Its filename is
     powerpc-switch-to-generic-warn_on-bug_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: switch to generic WARN_ON()/BUG_ON()
From: Olof Johansson <olof@lixom.net>

Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
4K text on a ppc64_defconfig.  The main reason seems to be that prepping
the arguments to the conditional trap instructions is more work than just
doing a compare and branch.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: <linux-arch@vger.kernel.org>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/bug.h |   37 ------------------------------------
 1 file changed, 37 deletions(-)

diff -puN include/asm-powerpc/bug.h~powerpc-switch-to-generic-warn_on-bug_on include/asm-powerpc/bug.h
--- a/include/asm-powerpc/bug.h~powerpc-switch-to-generic-warn_on-bug_on
+++ a/include/asm-powerpc/bug.h
@@ -54,12 +54,6 @@
 	".previous\n"
 #endif
 
-/*
- * BUG_ON() and WARN_ON() do their best to cooperate with compile-time
- * optimisations. However depending on the complexity of the condition
- * some compiler versions may not produce optimal results.
- */
-
 #define BUG() do {						\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
@@ -69,20 +63,6 @@
 	for(;;) ;						\
 } while (0)
 
-#define BUG_ON(x) do {						\
-	if (__builtin_constant_p(x)) {				\
-		if (x)						\
-			BUG();					\
-	} else {						\
-		__asm__ __volatile__(				\
-		"1:	"PPC_TLNEI"	%4,0\n"			\
-		_EMIT_BUG_ENTRY					\
-		: : "i" (__FILE__), "i" (__LINE__), "i" (0),	\
-		  "i" (sizeof(struct bug_entry)),		\
-		  "r" ((__force long)(x)));			\
-	}							\
-} while (0)
-
 #define __WARN() do {						\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
@@ -92,23 +72,6 @@
 		  "i" (sizeof(struct bug_entry)));		\
 } while (0)
 
-#define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
-	if (__builtin_constant_p(__ret_warn_on)) {		\
-		if (__ret_warn_on)				\
-			__WARN();				\
-	} else {						\
-		__asm__ __volatile__(				\
-		"1:	"PPC_TLNEI"	%4,0\n"			\
-		_EMIT_BUG_ENTRY					\
-		: : "i" (__FILE__), "i" (__LINE__),		\
-		  "i" (BUGFLAG_WARNING),			\
-		  "i" (sizeof(struct bug_entry)),		\
-		  "r" (__ret_warn_on));				\
-	}							\
-	unlikely(__ret_warn_on);				\
-})
-
 #endif /* __ASSEMBLY __ */
 #endif /* CONFIG_BUG */
 
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
bugh-remove-have_arch_bug--have_arch_warn.patch
powerpc-switch-to-generic-warn_on-bug_on.patch

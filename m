From: akpm@linux-foundation.org
Subject: + init-mainc-fix-symbol-shadows-noise.patch added to -mm tree
Date: Tue, 13 Oct 2009 15:06:11 -0700
Message-ID: <200910132206.n9DM6BOb027443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664AbZJMWGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 18:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     init/main.c: fix symbol shadows noise
has been added to the -mm tree.  Its filename is
     init-mainc-fix-symbol-shadows-noise.patch

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
Subject: init/main.c: fix symbol shadows noise
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

The symbol 'call' is a static symbol used for initcall_debug.  This same
symbol name is used locally by a couple functions and produces the
following sparse warnings:

	warning: symbol 'call' shadows an earlier one

Fix this noise by renaming the local symbols.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN init/main.c~init-mainc-fix-symbol-shadows-noise init/main.c
--- a/init/main.c~init-mainc-fix-symbol-shadows-noise
+++ a/init/main.c
@@ -696,10 +696,10 @@ asmlinkage void __init start_kernel(void
 static void __init do_ctors(void)
 {
 #ifdef CONFIG_CONSTRUCTORS
-	ctor_fn_t *call = (ctor_fn_t *) __ctors_start;
+	ctor_fn_t *fn = (ctor_fn_t *) __ctors_start;
 
-	for (; call < (ctor_fn_t *) __ctors_end; call++)
-		(*call)();
+	for (; fn < (ctor_fn_t *) __ctors_end; fn++)
+		(*fn)();
 #endif
 }
 
@@ -760,10 +760,10 @@ extern initcall_t __initcall_start[], __
 
 static void __init do_initcalls(void)
 {
-	initcall_t *call;
+	initcall_t *fn;
 
-	for (call = __early_initcall_end; call < __initcall_end; call++)
-		do_one_initcall(*call);
+	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
+		do_one_initcall(*fn);
 
 	/* Make sure there is no pending stuff from the initcall sequence */
 	flush_scheduled_work();
@@ -790,10 +790,10 @@ static void __init do_basic_setup(void)
 
 static void __init do_pre_smp_initcalls(void)
 {
-	initcall_t *call;
+	initcall_t *fn;
 
-	for (call = __initcall_start; call < __early_initcall_end; call++)
-		do_one_initcall(*call);
+	for (fn = __initcall_start; fn < __early_initcall_end; fn++)
+		do_one_initcall(*fn);
 }
 
 static void run_init_process(char *init_filename)
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch


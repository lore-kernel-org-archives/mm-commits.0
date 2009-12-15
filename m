From: akpm@linux-foundation.org
Subject: [merged] init-mainc-fix-symbol-shadows-noise.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:37 -0800
Message-ID: <200912152155.nBFLtbxg015500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933922AbZLOWGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:06:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     init/main.c: fix symbol shadows noise
has been removed from the -mm tree.  Its filename was
     init-mainc-fix-symbol-shadows-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 init/main.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN init/main.c~init-mainc-fix-symbol-shadows-noise init/main.c
--- a/init/main.c~init-mainc-fix-symbol-shadows-noise
+++ a/init/main.c
@@ -691,10 +691,10 @@ asmlinkage void __init start_kernel(void
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
 
@@ -755,10 +755,10 @@ extern initcall_t __initcall_start[], __
 
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
@@ -785,10 +785,10 @@ static void __init do_basic_setup(void)
 
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
linux-next.patch
drivers-block-mg_diskc-use-resource_size.patch
adx_wdtc-use-resource_size.patch
security-min_addrc-make-init_mmap_min_addr-static.patch


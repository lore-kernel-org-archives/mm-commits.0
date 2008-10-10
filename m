From: akpm@linux-foundation.org
Subject: + init-mainc-section-mismatch-warning-fix.patch added to -mm tree
Date: Fri, 10 Oct 2008 15:43:37 -0700
Message-ID: <200810102243.m9AMhbZx011874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYJJWnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 18:43:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mingo@elte.hu


The patch titled
     init/main.c: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     init-mainc-section-mismatch-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/main.c: fix section mismatch warning
From: "Rakib Mullick" <rakib.mullick@gmail.com>

 LD      init/built-in.o
WARNING: init/built-in.o(.text+0x207): Section mismatch in reference
from the function init_post() to the function
.init.text:prepare_namespace()
The function init_post() references
the function __init prepare_namespace().
This is often because init_post lacks a __init
annotation or the annotation of prepare_namespace is wrong.

init_post() has only one callsite and that is an __init function.

So by correctly marking init_post() as __init, we no longer care whether
or not it gets inlined into its __init caller.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN init/main.c~init-mainc-section-mismatch-warning-fix init/main.c
--- a/init/main.c~init-mainc-section-mismatch-warning-fix
+++ a/init/main.c
@@ -858,10 +858,7 @@ static void run_init_process(char *init_
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
-/* This is a non __init function. Force it to be noinline otherwise gcc
- * makes it inline to init() and it becomes part of init.text section
- */
-static int noinline init_post(void)
+static int __init init_post(void)
 {
 	int retry_count = 1;
 	free_initmem();
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

init-mainc-section-mismatch-warning-fix.patch
cpusetc-remove-extra-variable.patch


From: akpm@linux-foundation.org
Subject: + kernel-call-constructors-uml-fix-2.patch added to -mm tree
Date: Wed, 11 Jun 2008 17:23:21 -0700
Message-ID: <200806120023.m5C0NLfn025290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYFLAZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 20:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, jdike@addtoit.com, miklos@szeredi.hu, sam@ravnborg.org


The patch titled
     kernel-call-constructors-uml-fix-1
has been added to the -mm tree.  Its filename is
     kernel-call-constructors-uml-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-call-constructors-uml-fix-1
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>


Disable calling of constructor functions for uml as they are already
called by the host run-time environment.

Found-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c     |    4 ++++
 kernel/module.c |    4 ++++
 2 files changed, 8 insertions(+)

diff -puN init/main.c~kernel-call-constructors-uml-fix-2 init/main.c
--- a/init/main.c~kernel-call-constructors-uml-fix-2
+++ a/init/main.c
@@ -691,11 +691,15 @@ asmlinkage void __init start_kernel(void
 
 static void __init do_ctors(void)
 {
+#ifndef CONFIG_UML
+	/* Note: constructors on UML are called by the host run-time
+	 * environment. */
 	ctorcall_t *call;
 
 	for (call = (ctorcall_t *) __ctor_start;
 	     call < (ctorcall_t *) __ctor_end; call++)
 		(*call)();
+#endif /* !CONFIG_UML */
 }
 
 static int __initdata initcall_debug;
diff -puN kernel/module.c~kernel-call-constructors-uml-fix-2 kernel/module.c
--- a/kernel/module.c~kernel-call-constructors-uml-fix-2
+++ a/kernel/module.c
@@ -2194,10 +2194,14 @@ static struct module *load_module(void _
 
 static void do_mod_ctors(struct module *mod)
 {
+#ifndef CONFIG_UML
+	/* Note: constructors on UML are called by the host run-time
+	 * environment. */
 	unsigned long i;
 
 	for (i = 0; i < mod->num_ctors; i++)
 		mod->ctors[i]();
+#endif /* !CONFIG_UML */
 }
 
 /* This is where the real work happens */
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
s390-cio-use-memory_read_from_buffer.patch
kernel-call-constructors.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch


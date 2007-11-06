From: akpm@linux-foundation.org
Subject: + uml-clonec-tidying.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:29:18 -0800
Message-ID: <200711060229.lA62TI8c031854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582AbXKFC3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: clone.c tidying
has been added to the -mm tree.  Its filename is
     uml-clonec-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: clone.c tidying
From: Jeff Dike <jdike@addtoit.com>

clone.c needed some style attention -
	updated copyright
	include trimming
	coding style

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/clone.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN arch/um/kernel/skas/clone.c~uml-clonec-tidying arch/um/kernel/skas/clone.c
--- a/arch/um/kernel/skas/clone.c~uml-clonec-tidying
+++ a/arch/um/kernel/skas/clone.c
@@ -1,17 +1,20 @@
-#include <sched.h>
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
 #include <signal.h>
-#include <sys/mman.h>
-#include <sys/time.h>
+#include <sched.h>
 #include <asm/unistd.h>
+#include <sys/time.h>
 #include "as-layout.h"
+#include "kern_constants.h"
 #include "ptrace_user.h"
-#include "skas.h"
 #include "stub-data.h"
-#include "uml-config.h"
 #include "sysdep/stub.h"
-#include "kern_constants.h"
 
-/* This is in a separate file because it needs to be compiled with any
+/*
+ * This is in a separate file because it needs to be compiled with any
  * extraneous gcc flags (-pg, -fprofile-arcs, -ftest-coverage) disabled
  *
  * Use UM_KERN_PAGE_SIZE instead of PAGE_SIZE because that calls getpagesize
@@ -26,25 +29,26 @@ stub_clone_handler(void)
 
 	err = stub_syscall2(__NR_clone, CLONE_PARENT | CLONE_FILES | SIGCHLD,
 			    STUB_DATA + UM_KERN_PAGE_SIZE / 2 - sizeof(void *));
-	if(err != 0)
+	if (err != 0)
 		goto out;
 
 	err = stub_syscall4(__NR_ptrace, PTRACE_TRACEME, 0, 0, 0);
-	if(err)
+	if (err)
 		goto out;
 
-	err = stub_syscall3(__NR_setitimer, ITIMER_VIRTUAL, 
+	err = stub_syscall3(__NR_setitimer, ITIMER_VIRTUAL,
 			    (long) &data->timer, 0);
-	if(err)
+	if (err)
 		goto out;
 
 	remap_stack(data->fd, data->offset);
 	goto done;
 
  out:
-	/* save current result. 
-	 * Parent: pid; 
-	 * child: retcode of mmap already saved and it jumps around this 
+	/*
+	 * save current result.
+	 * Parent: pid;
+	 * child: retcode of mmap already saved and it jumps around this
 	 * assignment
 	 */
 	data->err = err;
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch

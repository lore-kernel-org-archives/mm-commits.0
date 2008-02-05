From: akpm@linux-foundation.org
Subject: - uml-clonec-tidying.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:51 -0800
Message-ID: <200802052235.m15MZWwZ012620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760694AbYBEWla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: clone.c tidying
has been removed from the -mm tree.  Its filename was
     uml-clonec-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch

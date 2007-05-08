From: akpm@linux-foundation.org
Subject: - uml-kernel_thread-shouldnt-panic.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:45 -0700
Message-ID: <200705080006.l4806jGl009221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967473AbXEHAKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: kernel_thread shouldn't panic
has been removed from the -mm tree.  Its filename was
     uml-kernel_thread-shouldnt-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: kernel_thread shouldn't panic
From: Jeff Dike <jdike@addtoit.com>

kernel_thread() should just return an error value on do_fork failure, not
panic.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/um/kernel/process.c~uml-kernel_thread-shouldnt-panic arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-kernel_thread-shouldnt-panic
+++ a/arch/um/kernel/process.c
@@ -97,8 +97,6 @@ int kernel_thread(int (*fn)(void *), voi
 	current->thread.request.u.thread.arg = arg;
 	pid = do_fork(CLONE_VM | CLONE_UNTRACED | flags, 0,
 		      &current->thread.regs, 0, NULL, NULL);
-	if(pid < 0)
-		panic("do_fork failed in kernel_thread, errno = %d", pid);
 	return pid;
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch

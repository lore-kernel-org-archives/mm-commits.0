From: akpm@linux-foundation.org
Subject: + uml-physical-memory-shouldnt-include-initial-stack.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:37 -0700
Message-ID: <200805062049.m46KnbC9026597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759236AbYEFUuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, caker@theshore.net, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: physical memory shouldn't include initial stack
has been added to the -mm tree.  Its filename is
     uml-physical-memory-shouldnt-include-initial-stack.patch

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
Subject: uml: physical memory shouldn't include initial stack
From: Jeff Dike <jdike@addtoit.com>

The top of physical memory should be below the initial process stack, not the
top of the address space, at least for as long as the stack isn't known to the
kernel VM system and appropriately reserved.

Cc: "Christopher S. Aker" <caker@theshore.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/um_arch.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/um_arch.c~uml-physical-memory-shouldnt-include-initial-stack arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-physical-memory-shouldnt-include-initial-stack
+++ a/arch/um/kernel/um_arch.c
@@ -258,6 +258,7 @@ int __init linux_main(int argc, char **a
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
+	unsigned long stack;
 	unsigned int i;
 	int add;
 	char * mode;
@@ -348,7 +349,9 @@ int __init linux_main(int argc, char **a
 	}
 
 	virtmem_size = physmem_size;
-	avail = TASK_SIZE - start_vm;
+	stack = (unsigned long) argv;
+	stack &= ~(1024 * 1024 - 1);
+	avail = stack - start_vm;
 	if (physmem_size > avail)
 		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch


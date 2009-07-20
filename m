From: akpm@linux-foundation.org
Subject: + fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch added to -mm tree
Date: Mon, 20 Jul 2009 15:46:14 -0700
Message-ID: <200907202246.n6KMkE8D006964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbZGTWqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 18:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, lethal@linux-sh.org, pavel@ucw.cz, vapier@gentoo.org


The patch titled
     fdpic: ignore the loader's PT_GNU_STACK when calculating the stack size
has been added to the -mm tree.  Its filename is
     fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch

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
Subject: fdpic: ignore the loader's PT_GNU_STACK when calculating the stack size
From: David Howells <dhowells@redhat.com>

Ignore the loader's PT_GNU_STACK when calculating the stack size, and only
consider the executable's PT_GNU_STACK, assuming the executable has one.

Currently the behaviour is to take the largest stack size and use that,
but that means you can't reduce the stack size in the executable.  The
loader's stack size should probably only be used when executing the loader
directly.

WARNING: This patch is slightly dangerous - it may render a system
inoperable if the loader's stack size is larger than that of important
executables, and the system relies unknowingly on this increasing the size
of the stack.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size
+++ a/fs/binfmt_elf_fdpic.c
@@ -283,20 +283,23 @@ static int load_elf_fdpic_binary(struct 
 	}
 
 	stack_size = exec_params.stack_size;
-	if (stack_size < interp_params.stack_size)
-		stack_size = interp_params.stack_size;
-
 	if (exec_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
 		executable_stack = EXSTACK_ENABLE_X;
 	else if (exec_params.flags & ELF_FDPIC_FLAG_NOEXEC_STACK)
 		executable_stack = EXSTACK_DISABLE_X;
-	else if (interp_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
-		executable_stack = EXSTACK_ENABLE_X;
-	else if (interp_params.flags & ELF_FDPIC_FLAG_NOEXEC_STACK)
-		executable_stack = EXSTACK_DISABLE_X;
 	else
 		executable_stack = EXSTACK_DEFAULT;
 
+	if (stack_size == 0) {
+		stack_size = interp_params.stack_size;
+		if (interp_params.flags & ELF_FDPIC_FLAG_EXEC_STACK)
+			executable_stack = EXSTACK_ENABLE_X;
+		else if (interp_params.flags & ELF_FDPIC_FLAG_NOEXEC_STACK)
+			executable_stack = EXSTACK_DISABLE_X;
+		else
+			executable_stack = EXSTACK_DEFAULT;
+	}
+
 	retval = -ENOEXEC;
 	if (stack_size == 0)
 		goto error;
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
flat-fix-uninitialized-ptr-with-shared-libs.patch
mm-count-only-reclaimable-lru-pages-v2.patch
include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch
frv-duplicate-output_buffer-of-e03.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
mutex-subsystem-synchro-test-module.patch


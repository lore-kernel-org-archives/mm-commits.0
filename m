From: akpm@linux-foundation.org
Subject: - restore-call_usermodehelper_pipe-behaviour.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:02 -0700
Message-ID: <200709160926.l8G9Q2U4009157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbXIPJ0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Restore call_usermodehelper_pipe() behaviour
has been removed from the -mm tree.  Its filename was
     restore-call_usermodehelper_pipe-behaviour.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Restore call_usermodehelper_pipe() behaviour
From: Michael Ellerman <michael@ellerman.id.au>

The semantics of call_usermodehelper_pipe() used to be that it would fork
the helper, and wait for the kernel thread to be started.  This was
implemented by setting sub_info.wait to 0 (implicitly), and doing a
wait_for_completion().

As part of the cleanup done in 0ab4dc92278a0f3816e486d6350c6652a72e06c8,
call_usermodehelper_pipe() was changed to pass 1 as the value for wait to
call_usermodehelper_exec().

This is equivalent to setting sub_info.wait to 1, which is a change from
the previous behaviour.  Using 1 instead of 0 causes
__call_usermodehelper() to start the kernel thread running
wait_for_helper(), rather than directly calling ____call_usermodehelper().

The end result is that the calling kernel code blocks until the user mode
helper finishes.  As the helper is expecting input on stdin, and now no one
is writing anything, everything locks up (observed in do_coredump).

The fix is to change the 1 to UMH_WAIT_EXEC (aka 0), indicating that we
want to wait for the kernel thread to be started, but not for the helper to
finish.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kmod.c~restore-call_usermodehelper_pipe-behaviour kernel/kmod.c
--- a/kernel/kmod.c~restore-call_usermodehelper_pipe-behaviour
+++ a/kernel/kmod.c
@@ -505,7 +505,7 @@ int call_usermodehelper_pipe(char *path,
 	if (ret < 0)
 		goto out;
 
-	return call_usermodehelper_exec(sub_info, 1);
+	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
git-powerpc.patch

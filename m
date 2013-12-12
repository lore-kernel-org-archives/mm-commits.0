From: akpm@linux-foundation.org
Subject: + test-check-copy_to-from_user-boundary-validation-fix.patch
 added to -mm tree
Date: Wed, 11 Dec 2013 16:43:44 -0800
Message-ID: <52a906c0.4PXRUA8JF4B7de0R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLAnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:43:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, joe@perches.com, keescook@chromium.org

Subject: + test-check-copy_to-from_user-boundary-validation-fix.patch added to -mm tree
To: keescook@chromium.org,joe@perches.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:43:44 -0800


The patch titled
     Subject: test: fix sparse warnings in user_copy tests
has been added to the -mm tree.  Its filename is
     test-check-copy_to-from_user-boundary-validation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test-check-copy_to-from_user-boundary-validation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test-check-copy_to-from_user-boundary-validation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: test: fix sparse warnings in user_copy tests

Sparse fix for "test: check copy_to/from_user boundary validation":

To keep sparse happy with the horrible things being done with the user
memory pointers, declare both __user and non-__user cases ahead of time to
avoid needing to do the casts later.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/test_user_copy.c~test-check-copy_to-from_user-boundary-validation-fix lib/test_user_copy.c
--- a/lib/test_user_copy.c~test-check-copy_to-from_user-boundary-validation-fix
+++ a/lib/test_user_copy.c
@@ -38,6 +38,7 @@ static int __init test_user_copy_init(vo
 	int ret = 0;
 	char *kmem;
 	char __user *usermem;
+	char *bad_usermem;
 	unsigned long user_addr;
 	unsigned long value = 0x5A;
 
@@ -55,6 +56,7 @@ static int __init test_user_copy_init(vo
 	}
 
 	usermem = (char __user *)user_addr;
+	bad_usermem = (char *)user_addr;
 
 	/* Legitimate usage: none of these should fail. */
 	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
@@ -70,13 +72,13 @@ static int __init test_user_copy_init(vo
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
 				    PAGE_SIZE),
 		    "illegal all-kernel copy_from_user passed");
-	ret |= test(!copy_from_user((char *)usermem, (char __user *)kmem,
+	ret |= test(!copy_from_user(bad_usermem, (char __user *)kmem,
 				    PAGE_SIZE),
 		    "illegal reversed copy_from_user passed");
 	ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				  PAGE_SIZE),
 		    "illegal all-kernel copy_to_user passed");
-	ret |= test(!copy_to_user((char __user *)kmem, (char *)usermem,
+	ret |= test(!copy_to_user((char __user *)kmem, bad_usermem,
 				  PAGE_SIZE),
 		    "illegal reversed copy_to_user passed");
 	ret |= test(!get_user(value, (unsigned long __user *)kmem),
_

Patches currently in -mm which might be from keescook@chromium.org are

test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch


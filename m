From: akpm@linux-foundation.org
Subject: + frv-fix-kernel-user-segment-handling-in-nommu-mode.patch added to -mm tree
Date: Fri, 26 Mar 2010 15:56:41 -0700
Message-ID: <201003262256.o2QMufA5025885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab0CZW4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 18:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     frv: fix kernel/user segment handling in NOMMU mode
has been added to the -mm tree.  Its filename is
     frv-fix-kernel-user-segment-handling-in-nommu-mode.patch

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
Subject: frv: fix kernel/user segment handling in NOMMU mode
From: David Howells <dhowells@redhat.com>

In NOMMU mode, the FRV segment handling is broken because KERNEL_DS ==
USER_DS.  This causes tests of the following sort:

	/* don't pin down non-user-based iovecs */
	if (segment_eq(get_fs(), KERNEL_DS))
		return NULL;

to malfunction.

To fix this, make USER_DS the top of RAM instead of the top of the non-IO
address space, and make KERNEL_DS one more than the top of the non-IO
address space.

Also get rid of FRV's __addr_ok() as nothing uses it.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/segment.h |    6 +++---
 arch/frv/include/asm/uaccess.h |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/frv/include/asm/segment.h~frv-fix-kernel-user-segment-handling-in-nommu-mode arch/frv/include/asm/segment.h
--- a/arch/frv/include/asm/segment.h~frv-fix-kernel-user-segment-handling-in-nommu-mode
+++ a/arch/frv/include/asm/segment.h
@@ -21,12 +21,12 @@ typedef struct {
 
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
 
-#define KERNEL_DS		MAKE_MM_SEG(0xdfffffffUL)
-
 #ifdef CONFIG_MMU
 #define USER_DS			MAKE_MM_SEG(TASK_SIZE - 1)
+#define KERNEL_DS		MAKE_MM_SEG(0xdfffffffUL)
 #else
-#define USER_DS			KERNEL_DS
+#define USER_DS			MAKE_MM_SEG(memory_end)
+#define KERNEL_DS		MAKE_MM_SEG(0xe0000000UL)
 #endif
 
 #define get_ds()		(KERNEL_DS)
diff -puN arch/frv/include/asm/uaccess.h~frv-fix-kernel-user-segment-handling-in-nommu-mode arch/frv/include/asm/uaccess.h
--- a/arch/frv/include/asm/uaccess.h~frv-fix-kernel-user-segment-handling-in-nommu-mode
+++ a/arch/frv/include/asm/uaccess.h
@@ -27,8 +27,6 @@
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
 
-#define __addr_ok(addr) ((unsigned long)(addr) < get_addr_limit())
-
 /*
  * check that a range of addresses falls within the current address limit
  */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
patch-b26b2d49-added-lines-with-a-missing-semicolons.patch
linux-next.patch
frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch
frv-fix-kernel-user-segment-handling-in-nommu-mode.patch
keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


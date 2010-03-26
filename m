From: akpm@linux-foundation.org
Subject: + frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch added to -mm tree
Date: Fri, 26 Mar 2010 15:55:41 -0700
Message-ID: <201003262255.o2QMtfuY025852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575Ab0CZWzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 18:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     frv: hide uncached_access() when pgprot_noncached is not #defined
has been added to the -mm tree.  Its filename is
     frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch

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
Subject: frv: hide uncached_access() when pgprot_noncached is not #defined
From: David Howells <dhowells@redhat.com>

Hide uncached_access() when pgprot_noncached is not #defined.  This prevents
the following warning:

	  CC      drivers/char/mem.o
	drivers/char/mem.c:229: warning: 'uncached_access' defined but not used

Repairs d7d4d849b4e3acc405ec222884936800ffb26d48 ("drivers/char/mem.c:
cleanups").

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/mem.c~frv-hide-uncached_access-when-pgprot_noncached-is-not-defined drivers/char/mem.c
--- a/drivers/char/mem.c~frv-hide-uncached_access-when-pgprot_noncached-is-not-defined
+++ a/drivers/char/mem.c
@@ -225,6 +225,7 @@ int __weak phys_mem_access_prot_allowed(
  * outside of main memory.
  *
  */
+#ifdef pgprot_noncached
 static int uncached_access(struct file *file, unsigned long addr)
 {
 #if defined(CONFIG_IA64)
@@ -251,6 +252,7 @@ static int uncached_access(struct file *
 	return addr >= __pa(high_memory);
 #endif
 }
+#endif
 
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
patch-b26b2d49-added-lines-with-a-missing-semicolons.patch
linux-next.patch
frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch
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


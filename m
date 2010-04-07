From: akpm@linux-foundation.org
Subject: [merged] frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:44 -0400
Message-ID: <201004071852.o37IqBhP001355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab0DGSwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: hide uncached_access() when pgprot_noncached is not #defined
has been removed from the -mm tree.  Its filename was
     frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
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
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


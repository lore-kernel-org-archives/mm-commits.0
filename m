From: akpm@linux-foundation.org
Subject: + fs-cache-order-the-debugfs-stats-correctly.patch added to -mm tree
Date: Tue, 30 Mar 2010 12:45:26 -0700
Message-ID: <201003301945.o2UJjRmX001026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab0C3TqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 15:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     fs-cache: order the debugfs stats correctly
has been added to the -mm tree.  Its filename is
     fs-cache-order-the-debugfs-stats-correctly.patch

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
Subject: fs-cache: order the debugfs stats correctly
From: David Howells <dhowells@redhat.com>

Order the debugfs statistics correctly.  The values displayed through a
seq_printf() statement should be in the same order as the names in the
format string.

In the 'Lookups' line, objects created ('crt=') and lookups timed out
('tmo=') have their values transposed.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fscache/stats.c~fs-cache-order-the-debugfs-stats-correctly fs/fscache/stats.c
--- a/fs/fscache/stats.c~fs-cache-order-the-debugfs-stats-correctly
+++ a/fs/fscache/stats.c
@@ -165,8 +165,8 @@ static int fscache_stats_show(struct seq
 		   atomic_read(&fscache_n_object_lookups),
 		   atomic_read(&fscache_n_object_lookups_negative),
 		   atomic_read(&fscache_n_object_lookups_positive),
-		   atomic_read(&fscache_n_object_lookups_timed_out),
-		   atomic_read(&fscache_n_object_created));
+		   atomic_read(&fscache_n_object_created),
+		   atomic_read(&fscache_n_object_lookups_timed_out));
 
 	seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
 		   atomic_read(&fscache_n_updates),
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch
frv-fix-kernel-user-segment-handling-in-nommu-mode.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
fs-cache-order-the-debugfs-stats-correctly.patch
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


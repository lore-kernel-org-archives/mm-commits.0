From: akpm@linux-foundation.org
Subject: [merged] fs-cache-order-the-debugfs-stats-correctly.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:58 -0400
Message-ID: <201004071852.o37IqO4L001365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab0DGSwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs-cache: order the debugfs stats correctly
has been removed from the -mm tree.  Its filename was
     fs-cache-order-the-debugfs-stats-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


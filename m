From: akpm@linux-foundation.org
Subject: [merged] nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:14 -0400
Message-ID: <201003261937.o2QJbDab016590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZThU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, uclinux@blueteddy.net, mm-commits@vger.kernel.org


The patch titled
     nommu: fix an incorrect comment in the do_mmap_shared_file()
has been removed from the -mm tree.  Its filename was
     nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix an incorrect comment in the do_mmap_shared_file()
From: David Howells <dhowells@redhat.com>

Fix an incorrect comment in the do_mmap_shared_file().  If a mapping is
requested MAP_SHARED, then a private copy cannot be made and still provide
correct semantics.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Dave Hudson <uclinux@blueteddy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file mm/nommu.c
--- a/mm/nommu.c~nommu-fix-an-incorrect-comment-in-the-do_mmap_shared_file
+++ a/mm/nommu.c
@@ -1040,10 +1040,9 @@ static int do_mmap_shared_file(struct vm
 	if (ret != -ENOSYS)
 		return ret;
 
-	/* getting an ENOSYS error indicates that direct mmap isn't
-	 * possible (as opposed to tried but failed) so we'll fall
-	 * through to making a private copy of the data and mapping
-	 * that if we can */
+	/* getting -ENOSYS indicates that direct mmap isn't possible (as
+	 * opposed to tried but failed) so we can only give a suitable error as
+	 * it's not possible to make a private copy if MAP_SHARED was given */
 	return -ENODEV;
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
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


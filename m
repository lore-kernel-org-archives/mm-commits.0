From: akpm@linux-foundation.org
Subject: + ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch added to -mm tree
Date: Wed, 15 Oct 2014 15:04:35 -0700
Message-ID: <543eef73.O8gVinhkXUe3Z+yM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaJOWEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 18:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix
has been added to the -mm tree.  Its filename is
     ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix

update sem_lock() comment, from Davidlohr

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix ipc/sem.c
--- a/ipc/sem.c~ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix
+++ a/ipc/sem.c
@@ -327,10 +327,11 @@ static inline int sem_lock(struct sem_ar
 		/* Then check that the global lock is free */
 		if (!spin_is_locked(&sma->sem_perm.lock)) {
 			/*
-			 * The next test must happen after the test for
-			 * sem_perm.lock, otherwise we can race with another
-			 * thread that does
-			 *	complex_count++;spin_unlock(sem_perm.lock);
+			 * The ipc object lock check must be visible on all
+			 * cores before rechecking the complex count.  Otherwise
+			 * we can race with  another thread that does:
+			 * 	complex_count++++;
+			 * 	spin_unlock(sem_perm.lock);
 			 */
 			smp_rmb();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


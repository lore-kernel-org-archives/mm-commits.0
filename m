From: akpm@linux-foundation.org
Subject: + ocfs2-remove-__mlog_cpu_guess.patch added to -mm tree
Date: Thu, 23 Apr 2015 14:55:46 -0700
Message-ID: <55396a62.tiSzb6FUP0NQmAXF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbbDWVzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 17:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joe@perches.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove __mlog_cpu_guess
has been added to the -mm tree.  Its filename is
     ocfs2-remove-__mlog_cpu_guess.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-__mlog_cpu_guess.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-__mlog_cpu_guess.patch

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
Subject: ocfs2: remove __mlog_cpu_guess

raw_smp_processor_id() is the means of avoiding the runtime preemptibility
check.

Cc: Joe Perches <joe@perches.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/cluster/masklog.c~ocfs2-remove-__mlog_cpu_guess fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~ocfs2-remove-__mlog_cpu_guess
+++ a/fs/ocfs2/cluster/masklog.c
@@ -64,19 +64,6 @@ static ssize_t mlog_mask_store(u64 mask,
 	return count;
 }
 
-/*
- * smp_processor_id() "helpfully" screams when called outside preemptible
- * regions in current kernels.  sles doesn't have the variants that don't
- * scream.  just do this instead of trying to guess which we're building
- * against.. *sigh*.
- */
-#define __mlog_cpu_guess						\
-({									\
-	unsigned long _cpu = get_cpu();					\
-	put_cpu();							\
-	_cpu;								\
-})
-
 void __mlog_printk(const u64 *mask, const char *func, int line,
 		   const char *fmt, ...)
 {
@@ -104,8 +91,8 @@ void __mlog_printk(const u64 *mask, cons
 	vaf.va = &args;
 
 	printk("%s(%s,%u,%lu):%s:%d %s%pV",
-	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
-	       func, line, prefix, &vaf);
+	       level, current->comm, task_pid_nr(current),
+	       raw_smp_processor_id(), func, line, prefix, &vaf);
 
 	va_end(args);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
ocfs2-remove-__mlog_cpu_guess.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


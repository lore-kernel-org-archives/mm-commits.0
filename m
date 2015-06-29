From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-__mlog_cpu_guess.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:36:27 -0700
Message-ID: <5591ac4b.SI71eBJOsacEG5ig%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbbF2Ug2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joe@perches.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove __mlog_cpu_guess
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-__mlog_cpu_guess.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2: remove __mlog_cpu_guess

raw_smp_processor_id() is the means of avoiding the runtime preemptibility
check.

[akpm@linux-foundation.org: fix printk warning]
Cc: Joe Perches <joe@perches.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

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
@@ -103,9 +90,9 @@ void __mlog_printk(const u64 *mask, cons
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%s(%s,%u,%lu):%s:%d %s%pV",
-	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
-	       func, line, prefix, &vaf);
+	printk("%s(%s,%u,%u):%s:%d %s%pV",
+	       level, current->comm, task_pid_nr(current),
+	       raw_smp_processor_id(), func, line, prefix, &vaf);
 
 	va_end(args);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


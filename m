From: akpm@linux-foundation.org
Subject: + cpumask-make-cpumask_size-return-unsigned-int.patch added to
 -mm tree
Date: Tue, 05 Dec 2017 16:42:41 -0800
Message-ID: <5a273d01.C2nM5GZFul5HQw3n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753249AbdLFAmm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 19:42:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: make cpumask_size() return "unsigned int"
has been added to the -mm tree.  Its filename is
     cpumask-make-cpumask_size-return-unsigned-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-make-cpumask_size-return-unsigned-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-make-cpumask_size-return-unsigned-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: cpumask: make cpumask_size() return "unsigned int"

CPUmasks are never big enough to warrant 64-bit code.

Space savings:

	add/remove: 0/0 grow/shrink: 1/4 up/down: 3/-17 (-14)
	Function                                     old     new   delta
	sched_init_numa                             1530    1533      +3
	compat_sys_sched_setaffinity                 160     159      -1
	sys_sched_getaffinity                        197     195      -2
	sys_sched_setaffinity                        183     176      -7
	compat_sys_sched_getaffinity                 179     172      -7

Link: http://lkml.kernel.org/r/20171204165531.GA8221@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 +-
 kernel/compat.c         |    2 +-
 kernel/sched/core.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-make-cpumask_size-return-unsigned-int include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-make-cpumask_size-return-unsigned-int
+++ a/include/linux/cpumask.h
@@ -640,7 +640,7 @@ static inline int cpulist_parse(const ch
 /**
  * cpumask_size - size to allocate for a 'struct cpumask' in bytes
  */
-static inline size_t cpumask_size(void)
+static inline unsigned int cpumask_size(void)
 {
 	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
 }
diff -puN kernel/compat.c~cpumask-make-cpumask_size-return-unsigned-int kernel/compat.c
--- a/kernel/compat.c~cpumask-make-cpumask_size-return-unsigned-int
+++ a/kernel/compat.c
@@ -355,7 +355,7 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		size_t retlen = min_t(size_t, len, cpumask_size());
+		unsigned int retlen = min(len, cpumask_size());
 
 		if (compat_put_bitmap(user_mask_ptr, cpumask_bits(mask), retlen * 8))
 			ret = -EFAULT;
diff -puN kernel/sched/core.c~cpumask-make-cpumask_size-return-unsigned-int kernel/sched/core.c
--- a/kernel/sched/core.c~cpumask-make-cpumask_size-return-unsigned-int
+++ a/kernel/sched/core.c
@@ -4799,7 +4799,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		size_t retlen = min_t(size_t, len, cpumask_size());
+		unsigned int retlen = min(len, cpumask_size());
 
 		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
proc-less-memory-for-proc-map_files-readdir.patch
proc-delete-children_seq_release.patch
seq_file-delete-small-value-optimization.patch
cpumask-make-cpumask_size-return-unsigned-int.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
 removed from -mm tree
Date: Wed, 10 Jun 2020 18:24:05 -0700
Message-ID: <20200611012405.NqMKhqsCC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, minchan@kernel.org, mm-commits@vger.kernel.org, natechancellor@gmail.com


The patch titled
     Subject: mm: fix s390 compat build error
has been removed from the -mm tree.  Its filename was
     mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-support-vector-address-ranges-for-process_madvise.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix s390 compat build error

Nathan reported build error with sys_compat_process_madvise.
This patch should fix it.

Link: http://lkml.kernel.org/r/20200429012421.GA132200@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>	[build]
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    5 +++--
 mm/madvise.c           |    9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/compat.h~mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix
+++ a/include/linux/compat.h
@@ -827,9 +827,10 @@ asmlinkage long compat_sys_pwritev64v2(u
 		unsigned long vlen, loff_t pos, rwf_t flags);
 #endif
 
-asmlinkage ssize_t compat_sys_process_madvise(int which,
+asmlinkage ssize_t compat_sys_process_madvise(compat_int_t which,
 		compat_pid_t upid, const struct compat_iovec __user *vec,
-		unsigned long vlen, int behavior, unsigned long flags);
+		compat_ulong_t vlen, compat_int_t behavior,
+		compat_ulong_t flags);
 
 /*
  * Deprecated system calls which are still defined in
--- a/mm/madvise.c~mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -1311,9 +1311,12 @@ SYSCALL_DEFINE6(process_madvise, int, wh
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE6(process_madvise, int, which, compat_pid_t, upid,
-		const struct compat_iovec __user *, vec, unsigned long, vlen,
-		int, behavior, unsigned long, flags)
+COMPAT_SYSCALL_DEFINE6(process_madvise, compat_int_t, which,
+			compat_pid_t, upid,
+			const struct compat_iovec __user *, vec,
+			compat_ulong_t, vlen,
+			compat_int_t, behavior,
+			compat_ulong_t, flags)
 
 {
 	ssize_t ret;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-use-only-pidfd-for-process_madvise-syscall.patch
mm-use-only-pidfd-for-process_madvise-syscall-fix.patch

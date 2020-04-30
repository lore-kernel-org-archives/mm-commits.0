From: akpm@linux-foundation.org
Subject: +
 mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
 added to -mm tree
Date: Wed, 29 Apr 2020 18:56:00 -0700
Message-ID: <20200430015600.3ZaJEU0f4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3B4B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, natechancellor@gmail.com


The patch titled
     Subject: mm: fix s390 compat build error
has been added to the -mm tree.  Its filename is
     mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix s390 compat build error

Nathan reported build error with sys_compat_process_madvise.
This patch should fix it.

Link: http://lkml.kernel.org/r/20200429012421.GA132200@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>	[build]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    5 +++--
 mm/madvise.c           |    9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/compat.h~mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix
+++ a/include/linux/compat.h
@@ -820,9 +820,10 @@ asmlinkage long compat_sys_pwritev64v2(u
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
mm-introduce-external-memory-hinting-api-fix.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch

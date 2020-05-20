From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-only-pidfd-for-process_madvise-syscall-fix.patch
 added to -mm tree
Date: Tue, 19 May 2020 19:43:35 -0700
Message-ID: <20200520024335.ZWuzc3OQc%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgETCng (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 May 2020 22:43:36 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, minchan@kernel.org, mm-commits@vger.kernel.org, surenb@google.com


The patch titled
     Subject: mm: return EBADF if pidfd is invalid
has been added to the -mm tree.  Its filename is
     mm-use-only-pidfd-for-process_madvise-syscall-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-only-pidfd-for-process_madvise-syscall-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-only-pidfd-for-process_madvise-syscall-fix.patch

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
Subject: mm: return EBADF if pidfd is invalid

This patch makes returning of EBADF when the fd passed as argument is
invalid. The implementaion relies on pidfd_get_pid's error return.

This patch also fixes syscall declare part since we removed pid support.

Link: http://lkml.kernel.org/r/20200519181447.GA220547@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    6 +++---
 include/linux/syscalls.h |    5 ++---
 mm/madvise.c             |    3 ---
 3 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/compat.h~mm-use-only-pidfd-for-process_madvise-syscall-fix
+++ a/include/linux/compat.h
@@ -827,10 +827,10 @@ asmlinkage long compat_sys_pwritev64v2(u
 		unsigned long vlen, loff_t pos, rwf_t flags);
 #endif
 
-asmlinkage ssize_t compat_sys_process_madvise(compat_int_t which,
-		compat_pid_t upid, const struct compat_iovec __user *vec,
+asmlinkage ssize_t compat_sys_process_madvise(compat_int_t pidfd,
+		const struct compat_iovec __user *vec,
 		compat_ulong_t vlen, compat_int_t behavior,
-		compat_ulong_t flags);
+		compat_int_t flags);
 
 /*
  * Deprecated system calls which are still defined in
--- a/include/linux/syscalls.h~mm-use-only-pidfd-for-process_madvise-syscall-fix
+++ a/include/linux/syscalls.h
@@ -879,9 +879,8 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
-asmlinkage long sys_process_madvise(int which, pid_t upid,
-		const struct iovec __user *vec, unsigned long vlen,
-		int behavior, unsigned long flags);
+asmlinkage long sys_process_madvise(int pidfd, const struct iovec __user *vec,
+		unsigned long vlen, int behavior, unsigned int flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
--- a/mm/madvise.c~mm-use-only-pidfd-for-process_madvise-syscall-fix
+++ a/mm/madvise.c
@@ -1242,9 +1242,6 @@ static ssize_t do_process_madvise(int pi
 	if (flags != 0)
 		return -EINVAL;
 
-	if (pidfd < 0)
-		return -EINVAL;

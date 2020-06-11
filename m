From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 24/25] mm: use only pidfd for process_madvise
 syscall
Date: Wed, 10 Jun 2020 18:42:41 -0700
Message-ID: <20200611014241.11iF_RJqJ%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFKBmo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:42:44 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy@google.com, bgeffon@google.com, christian.brauner@ubuntu.com, dancol@google.com, hannes@cmpxchg.org, joaodias@google.com, joel@joelfernandes.org, linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com, sj38.park@gmail.com, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: use only pidfd for process_madvise syscall

Based on discussion[1], people didn't feel we need to support both
pid and pidfd for every new coming API[2] so this patch keeps only
pidfd. This patch also changes flags's type with "unsigned int".

[1] https://lore.kernel.org/linux-mm/20200509124817.xmrvsrq3mla6b76k@wittgenstein/
[2] https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509@virtuozzo.com/

[minchan@kernel.org: return EBADF if pidfd is invalid]
  Link: http://lkml.kernel.org/r/20200519181447.GA220547@google.com
Link: http://lkml.kernel.org/r/20200518211350.GA50295@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: John Dias <joaodias@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    6 ++---
 include/linux/syscalls.h |    5 +---
 mm/madvise.c             |   41 +++++++++----------------------------
 3 files changed, 16 insertions(+), 36 deletions(-)

--- a/include/linux/compat.h~mm-use-only-pidfd-for-process_madvise-syscall
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
--- a/include/linux/syscalls.h~mm-use-only-pidfd-for-process_madvise-syscall
+++ a/include/linux/syscalls.h
@@ -878,9 +878,8 @@ asmlinkage long sys_munlockall(void);
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
--- a/mm/madvise.c~mm-use-only-pidfd-for-process_madvise-syscall
+++ a/mm/madvise.c
@@ -1230,8 +1230,8 @@ static int process_madvise_vec(struct ta
 	return ret;
 }
 
-static ssize_t do_process_madvise(int which, pid_t upid, struct iov_iter *iter,
-				       int behavior, unsigned long flags)
+static ssize_t do_process_madvise(int pidfd, struct iov_iter *iter,
+				int behavior, unsigned int flags)
 {
 	ssize_t ret;
 	struct pid *pid;
@@ -1242,26 +1242,9 @@ static ssize_t do_process_madvise(int wh
 	if (flags != 0)
 		return -EINVAL;
 
-	switch (which) {
-	case P_PID:
-		if (upid <= 0)
-			return -EINVAL;
-
-		pid = find_get_pid(upid);
-		if (!pid)
-			return -ESRCH;
-		break;
-	case P_PIDFD:
-		if (upid < 0)
-			return -EINVAL;
-
-		pid = pidfd_get_pid(upid);
-		if (IS_ERR(pid))
-			return PTR_ERR(pid);
-		break;
-	default:
-		return -EINVAL;
-	}
+	pid = pidfd_get_pid(pidfd);
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
 
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task) {
@@ -1293,9 +1276,8 @@ put_pid:
 	return ret;
 }
 
-SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid,
-		const struct iovec __user *, vec, unsigned long, vlen,
-		int, behavior, unsigned long, flags)
+SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
+		unsigned long, vlen, int, behavior, unsigned int, flags)
 {
 	ssize_t ret;
 	struct iovec iovstack[UIO_FASTIOV];
@@ -1304,19 +1286,18 @@ SYSCALL_DEFINE6(process_madvise, int, wh
 
 	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
 	if (ret >= 0) {
-		ret = do_process_madvise(which, upid, &iter, behavior, flags);
+		ret = do_process_madvise(pidfd, &iter, behavior, flags);
 		kfree(iov);
 	}
 	return ret;
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE6(process_madvise, compat_int_t, which,
-			compat_pid_t, upid,
+COMPAT_SYSCALL_DEFINE5(process_madvise, compat_int_t, pidfd,
 			const struct compat_iovec __user *, vec,
 			compat_ulong_t, vlen,
 			compat_int_t, behavior,
-			compat_ulong_t, flags)
+			compat_int_t, flags)
 
 {
 	ssize_t ret;
@@ -1327,7 +1308,7 @@ COMPAT_SYSCALL_DEFINE6(process_madvise,
 	ret = compat_import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack),
 				&iov, &iter);
 	if (ret >= 0) {
-		ret = do_process_madvise(which, upid, &iter, behavior, flags);
+		ret = do_process_madvise(pidfd, &iter, behavior, flags);
 		kfree(iov);
 	}
 	return ret;
_

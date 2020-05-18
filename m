From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-only-pidfd-for-process_madvise-syscall.patch
 added to -mm tree
Date: Mon, 18 May 2020 16:07:04 -0700
Message-ID: <20200518230704.ZVf6L_tad%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgERXHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 19:07:06 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, bgeffon@google.com, dancol@google.com, hannes@cmpxchg.org, joaodias@google.com, joel@joelfernandes.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com, sj38.park@gmail.com, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: use only pidfd for process_madvise syscall
has been added to the -mm tree.  Its filename is
     mm-use-only-pidfd-for-process_madvise-syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-only-pidfd-for-process_madvise-syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-only-pidfd-for-process_madvise-syscall.patch

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
Subject: mm: use only pidfd for process_madvise syscall

Based on discussion[1], people didn't feel we need to support both
pid and pidfd for every new coming API[2] so this patch keeps only
pidfd. This patch also changes flags's type with "unsigned int".

[1] https://lore.kernel.org/linux-mm/20200509124817.xmrvsrq3mla6b76k@wittgenstein/
[2] https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509@virtuozzo.com/

Link: http://lkml.kernel.org/r/20200518211350.GA50295@google.com
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   42 +++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

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
@@ -1242,26 +1242,12 @@ static ssize_t do_process_madvise(int wh
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
+	if (pidfd < 0)
 		return -EINVAL;
-	}
+
+	pid = pidfd_get_pid(pidfd);
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
 
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task) {
@@ -1293,9 +1279,8 @@ put_pid:
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
@@ -1304,19 +1289,18 @@ SYSCALL_DEFINE6(process_madvise, int, wh
 
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
@@ -1327,7 +1311,7 @@ COMPAT_SYSCALL_DEFINE6(process_madvise,
 	ret = compat_import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack),
 				&iov, &iter);
 	if (ret >= 0) {
-		ret = do_process_madvise(which, upid, &iter, behavior, flags);
+		ret = do_process_madvise(pidfd, &iter, behavior, flags);
 		kfree(iov);
 	}
 	return ret;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-introduce-external-memory-hinting-api-fix.patch
mm-introduce-external-memory-hinting-api-fix-2.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
mm-use-only-pidfd-for-process_madvise-syscall.patch

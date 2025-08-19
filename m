Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638F526C3A0
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 20:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755635080; cv=none; b=quKlG69//GLqATPm4/YnpSnm+dsgoGBOMbAfFaKxECO1F/8uBE6waZOyUtIJr9CohMASati2F6/3DcugPk2mXVueIBsG074Fl/hP86HWgjGBGsW9w8bkVGjO7BGaCDqjEwOz1ghe4mCubZU9jOKAH6hdywQ9J5y4souazQT1zWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755635080; c=relaxed/simple;
	bh=XUFsKBs/sc3DZaNW79qWTuQF2dzqhdyybwE5Gnc+Ns8=;
	h=Date:To:From:Subject:Message-Id; b=oRv8xElSGNYEOfFg1lval69LbaAlucF/2849ovArihmsUGN3mykWWl9CdgGSa3R6fTFuwbveRTdWLI0WPdDbVsWTPypvrVf7yd6D3Pv4E9Hb6glMdkwA1XRTLKdlKukTiz1ZJpKkbxW3fZfB8OQAmbpZge4gNoZae2gDN0aGwoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0KHyID+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0KHyID+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34F4C4CEF1;
	Tue, 19 Aug 2025 20:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755635079;
	bh=XUFsKBs/sc3DZaNW79qWTuQF2dzqhdyybwE5Gnc+Ns8=;
	h=Date:To:From:Subject:From;
	b=0KHyID+72k8cqqEbn1jjZbWWvwktkj5CEubQQ5WGFmUEPX69W1NoRB151vFuFXX2f
	 kQyTtzo/qYi89wnp8w558m21R4SN6A/pwe/pPC//WirQA++zykLjF1imxrj+xLd1o7
	 UfkT4btgguvoNGojxr/DYefl+YKHuSrG/rj6RCaU=
Date: Tue, 19 Aug 2025 13:24:39 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shakeel.butt@linux.dev,rientjes@google.com,peterz@infradead.org,npache@redhat.com,mingo@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,jsavitz@redhat.com,dvhart@infradead.org,dave@stgolabs.net,andrealmeid@igalia.com,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] futex-introduce-function-process_has_robust_futex.patch removed from -mm tree
Message-Id: <20250819202439.D34F4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: futex: introduce function process_has_robust_futex()
has been removed from the -mm tree.  Its filename was
     futex-introduce-function-process_has_robust_futex.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: zhongjinji <zhongjinji@honor.com>
Subject: futex: introduce function process_has_robust_futex()
Date: Thu, 14 Aug 2025 21:55:53 +0800

Patch series "mm/oom_kill: Only delay OOM reaper for processes using
robust futexes", v4.

The OOM reaper quickly reclaims a process's memory when the system hits
OOM, helping the system recover.  Without the OOM reaper, if a process
frozen by cgroup v1 is OOM killed, the victim's memory cannot be freed,
leaving the system in a poor state.  Even if the process is not frozen by
cgroup v1, reclaiming victims' memory remains important, as having one
more process working speeds up memory release.

When processes holding robust futexes are OOM killed but waiters on those
futexes remain alive, the robust futexes might be reaped before
futex_cleanup() runs.  This can cause the waiters to block indefinitely
[1].

To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1]. 
Since many killed processes exit within 2 seconds, the OOM reaper rarely
runs after this delay.  However, robust futex users are few, so delaying
OOM reap for all victims is unnecessary.

If each thread's robust_list in a process is NULL, the process holds no
robust futexes.  For such processes, the OOM reaper should not be delayed.
For processes holding robust futexes, to avoid issue [1], the OOM reaper
must still be delayed.

Patch 1 introduces process_has_robust_futex() to detect whether a process
uses robust futexes.  Patch 2 delays the OOM reaper only for processes
holding robust futexes, improving OOM reaper performance.  Patch 3 makes
the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
to reduce PTE lock contention caused by unmapping the same vma.


This patch (of 3):

When the holders of robust futexes are OOM killed but the waiters on
robust futexes are still alive, the robust futexes might be reaped before
futex_cleanup() runs.  This can cause the waiters to block indefinitely
[1].  To prevent this issue, the OOM reaper's work is delayed by 2 seconds
[1].  However, the OOM reaper now rarely runs since many killed processes
exit within 2 seconds.

Because robust futex users are few, delay the reaper's execution only for
processes holding robust futexes to improve the performance of the OOM
reaper.

Introduce the function process_has_robust_futex() to detect whether a
process uses robust futexes.  If each thread's robust_list in a process is
NULL, it means the process holds no robust futexes.  Conversely, it means
the process holds robust futexes.

Link: https://lkml.kernel.org/r/20250814135555.17493-1-zhongjinji@honor.com
Link: https://lkml.kernel.org/r/20250814135555.17493-2-zhongjinji@honor.com
Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]
Signed-off-by: zhongjinji <zhongjinji@honor.com>
Cc: Andre Almeida <andrealmeid@igalia.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |    5 +++++
 kernel/futex/core.c   |   30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

--- a/include/linux/futex.h~futex-introduce-function-process_has_robust_futex
+++ a/include/linux/futex.h
@@ -81,6 +81,7 @@ void futex_exec_release(struct task_stru
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4);
+bool process_has_robust_futex(struct task_struct *tsk);
 
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
 int futex_hash_allocate_default(void);
@@ -108,6 +109,10 @@ static inline int futex_hash_prctl(unsig
 {
 	return -EINVAL;
 }
+static inline bool process_has_robust_futex(struct task_struct *tsk)
+{
+	return false;
+}
 static inline int futex_hash_allocate_default(void)
 {
 	return 0;
--- a/kernel/futex/core.c~futex-introduce-function-process_has_robust_futex
+++ a/kernel/futex/core.c
@@ -1961,6 +1961,36 @@ int futex_hash_prctl(unsigned long arg2,
 	return ret;
 }
 
+/*
+ * process_has_robust_futex() - check whether the given task hold robust futexes.
+ * @p: task struct of which task to consider
+ *
+ * If any thread in the task has a non-NULL robust_list or compat_robust_list,
+ * it indicates that the task holds robust futexes.
+ */
+bool process_has_robust_futex(struct task_struct *tsk)
+{
+	struct task_struct *t;
+	bool ret = false;
+
+	rcu_read_lock();
+	for_each_thread(tsk, t) {
+		if (unlikely(t->robust_list)) {
+			ret = true;
+			break;
+		}
+#ifdef CONFIG_COMPAT
+		if (unlikely(t->compat_robust_list)) {
+			ret = true;
+			break;
+		}
+#endif
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int __init futex_init(void)
 {
 	unsigned long hashsize, i;
_

Patches currently in -mm which might be from zhongjinji@honor.com are

mm-oom_kill-only-delay-oom-reaper-for-processes-using-robust-futexes.patch


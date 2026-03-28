Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560B33557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671918; cv=none; b=f3JFbicbJAdVog2Kh3KOYoxQoKwVxF6rbId2hxuQkMUXlBburZ2ZEoviYza8gRruGpNn1CHzt4iEr9rz1JCRUiHXqcLI5z9SGQI0JuQ0FcxFyTh4CyskQgRfbGV1BE2FO6y6YTfZIWZbuKDm7z0BkiW8a3v7TGECn1XZT/JvC7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671918; c=relaxed/simple;
	bh=rdLVDSh4ZzKkawY+Pxx9BXjSQzr/NH19mWVTyV8eh+0=;
	h=Date:To:From:Subject:Message-Id; b=UkKzo2jlpz0I71PJ2Qu1zc6nBAxHJihfKqVmw1GQAZn0f6MIuYv4LVKdER+pmk4tdX99Nvkkh1LoCjkAtAstJjJod3DoXJ/lAx4paaPsUeOx59ybTISqLUPsfngKbDXvpb4xXluHPmAOrlhz45+mS60Yljl6mpif4WmsSPNWyUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rpJU+VLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rpJU+VLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A83C4CEF7;
	Sat, 28 Mar 2026 04:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671917;
	bh=rdLVDSh4ZzKkawY+Pxx9BXjSQzr/NH19mWVTyV8eh+0=;
	h=Date:To:From:Subject:From;
	b=rpJU+VLdXRLWFs+gnpS/5BXoJ/35wCuHfOA+EprlZsheXwSId30xgTyOeOBqnLgYj
	 HVV9ErbT0prtqNoTNfJjWe4ndUBVQ480+HSqZSFX4lJV3tx4IYlPRZO9Gq83HPL2hp
	 21ZMwlrIKBC+5950tkY1KW2S5m0GypPVZpfwUq/A=
Date: Fri, 27 Mar 2026 21:25:17 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-enable-runtime-reset-of-hung_task_detect_count.patch removed from -mm tree
Message-Id: <20260328042517.85A83C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: enable runtime reset of hung_task_detect_count
has been removed from the -mm tree.  Its filename was
     hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: enable runtime reset of hung_task_detect_count
Date: Tue, 3 Mar 2026 15:30:30 -0500

Currently, the hung_task_detect_count sysctl provides a cumulative count
of hung tasks since boot.  In long-running, high-availability
environments, this counter may lose its utility if it cannot be reset once
an incident has been resolved.  Furthermore, the previous implementation
relied upon implicit ordering, which could not strictly guarantee that
diagnostic metadata published by one CPU was visible to the panic logic on
another.

This patch introduces the capability to reset the detection count by
writing "0" to the hung_task_detect_count sysctl.  The proc_handler logic
has been updated to validate this input and atomically reset the counter.

The synchronisation of sysctl_hung_task_detect_count relies upon a
transactional model to ensure the integrity of the detection counter
against concurrent resets from userspace.  The application of
atomic_long_read_acquire() and atomic_long_cmpxchg_release() is correct
and provides the following guarantees:

    1. Prevention of Load-Store Reordering via Acquire Semantics By
       utilising atomic_long_read_acquire() to snapshot the counter
       before initiating the task traversal, we establish a strict
       memory barrier. This prevents the compiler or hardware from
       reordering the initial load to a point later in the scan. Without
       this "acquire" barrier, a delayed load could potentially read a
       "0" value resulting from a userspace reset that occurred
       mid-scan. This would lead to the subsequent cmpxchg succeeding
       erroneously, thereby overwriting the user's reset with stale
       increment data.

    2. Atomicity of the "Commit" Phase via Release Semantics The
       atomic_long_cmpxchg_release() serves as the transaction's commit
       point. The "release" barrier ensures that all diagnostic
       recordings and task-state observations made during the scan are
       globally visible before the counter is incremented.

    3. Race Condition Resolution This pairing effectively detects any
       "out-of-band" reset of the counter. If
       sysctl_hung_task_detect_count is modified via the procfs
       interface during the scan, the final cmpxchg will detect the
       discrepancy between the current value and the "acquire" snapshot.
       Consequently, the update will fail, ensuring that a reset command
       from the administrator is prioritised over a scan that may have
       been invalidated by that very reset.

Link: https://lkml.kernel.org/r/20260303203031.4097316-3-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    3 
 kernel/hung_task.c                          |   58 +++++++++++++++---
 2 files changed, 53 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-enable-runtime-reset-of-hung_task_detect_count
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -418,7 +418,8 @@ hung_task_detect_count
 ======================
 
 Indicates the total number of tasks that have been detected as hung since
-the system boot.
+the system boot or since the counter was reset. The counter is zeroed when
+a value of 0 is written.
 
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
--- a/kernel/hung_task.c~hung_task-enable-runtime-reset-of-hung_task_detect_count
+++ a/kernel/hung_task.c
@@ -306,7 +306,11 @@ static void check_hung_uninterruptible_t
 	int need_warning = sysctl_hung_task_warnings;
 	unsigned long si_mask = hung_task_si_mask;
 
-	total_count = atomic_long_read(&sysctl_hung_task_detect_count);
+	/*
+	 * The counter might get reset. Remember the initial value.
+	 * Acquire prevents reordering task checks before this point.
+	 */
+	total_count = atomic_long_read_acquire(&sysctl_hung_task_detect_count);
 	/*
 	 * If the system crashed already then all bets are off,
 	 * do not report extra hung tasks:
@@ -337,10 +341,11 @@ static void check_hung_uninterruptible_t
 		return;
 
 	/*
-	 * This counter tracks the total number of tasks detected as hung
-	 * since boot.
+	 * Do not count this round when the global counter has been reset
+	 * during this check. Release ensures we see all hang details
+	 * recorded during the scan.
 	 */
-	atomic_long_cmpxchg_relaxed(&sysctl_hung_task_detect_count,
+	atomic_long_cmpxchg_release(&sysctl_hung_task_detect_count,
 				    total_count, total_count +
 				    this_round_count);
 
@@ -366,6 +371,46 @@ static long hung_timeout_jiffies(unsigne
 }
 
 #ifdef CONFIG_SYSCTL
+
+/**
+ * proc_dohung_task_detect_count - proc handler for hung_task_detect_count
+ * @table: Pointer to the struct ctl_table definition for this proc entry
+ * @dir: Flag indicating the operation
+ * @buffer: User space buffer for data transfer
+ * @lenp: Pointer to the length of the data being transferred
+ * @ppos: Pointer to the current file offset
+ *
+ * This handler is used for reading the current hung task detection count
+ * and for resetting it to zero when a write operation is performed using a
+ * zero value only.
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int proc_dohung_task_detect_count(const struct ctl_table *table, int dir,
+					 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	unsigned long detect_count;
+	struct ctl_table proxy_table;
+	int err;
+
+	proxy_table = *table;
+	proxy_table.data = &detect_count;
+
+	if (SYSCTL_KERN_TO_USER(dir))
+		detect_count = atomic_long_read(&sysctl_hung_task_detect_count);
+
+	err = proc_doulongvec_minmax(&proxy_table, dir, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (SYSCTL_USER_TO_KERN(dir)) {
+		if (detect_count)
+			return -EINVAL;
+		atomic_long_set(&sysctl_hung_task_detect_count, 0);
+	}
+
+	return 0;
+}
+
 /*
  * Process updating of timeout sysctl
  */
@@ -446,10 +491,9 @@ static const struct ctl_table hung_task_
 	},
 	{
 		.procname	= "hung_task_detect_count",
-		.data		= &sysctl_hung_task_detect_count,
 		.maxlen		= sizeof(unsigned long),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
+		.mode		= 0644,
+		.proc_handler	= proc_dohung_task_detect_count,
 	},
 	{
 		.procname	= "hung_task_sys_info",
_

Patches currently in -mm which might be from atomlin@atomlin.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD01A2DE6FC
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766101916; cv=none; b=T76JOjlL/40Tz6OzJ9BLVcXNTFTn5L6+trdgGbozExx91R6cKiBT7H0lIU5sXcP/YoaWq1PfZnC8kA+b5uJwSgvAM1pFKKgtO/R4UEqslxsB5YYYayCatZ8O9E4QDYjSUIhvqbNP2lqb+7HjUIOdmt6H4tivvzC8nM26wrc+aIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766101916; c=relaxed/simple;
	bh=XxgcVe1TgTgE6BHetxFwzQxLWI5s4yh5ROT4GBWuFz8=;
	h=Date:To:From:Subject:Message-Id; b=WVEo1v413rLhKGWc9ITvlkDD8WWs7XheSwmB5J4A5YHTiOtu8Qlxuy1pA0ok2lADMRw3fiDLOrd4NVtSGGUtKHRxMlvE3JK+QoUjj1Zmi3azwlT7YPthnpip3vWbi1Yk4wSkhw9cKYFy6Z6DdjRUywtbF0y1hKncRMwewCc10fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/QQvGPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/QQvGPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F93DC16AAE;
	Thu, 18 Dec 2025 23:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766101916;
	bh=XxgcVe1TgTgE6BHetxFwzQxLWI5s4yh5ROT4GBWuFz8=;
	h=Date:To:From:Subject:From;
	b=o/QQvGPRXS6J1m8KzSLE4hz/ukT9Hww2IXez/WqZOgrSj3JrCZoOGrn7ud0o6EDUI
	 F/PWmByRuE6f7QoM1h/UmMQBxIpGBDvAE0EiLsVVLBuImTGXe+V5d+BkZuzaohLt+c
	 HoJZj4937Z9PGheW5gTu22HVhAPU7tjNekwzpB00=
Date: Thu, 18 Dec 2025 15:51:55 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hung_task-enable-runtime-reset-of-hung_task_detect_count.patch removed from -mm tree
Message-Id: <20251218235156.3F93DC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: enable runtime reset of hung_task_detect_count
has been removed from the -mm tree.  Its filename was
     hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: enable runtime reset of hung_task_detect_count
Date: Mon, 15 Dec 2025 22:00:36 -0500

Introduce support for writing to /proc/sys/kernel/hung_task_detect_count.

Writing any value to this file atomically resets the counter of detected
hung tasks to zero.  This grants system administrators the ability to
clear the cumulative diagnostic history after resolving an incident,
simplifying monitoring without requiring a system restart.

Link: https://lkml.kernel.org/r/20251216030036.1822217-3-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-enable-runtime-reset-of-hung_task_detect_count
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -418,7 +418,7 @@ hung_task_detect_count
 ======================
 
 Indicates the total number of tasks that have been detected as hung since
-the system boot.
+the system boot. The counter can be reset to zero when written to.
 
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
--- a/kernel/hung_task.c~hung_task-enable-runtime-reset-of-hung_task_detect_count
+++ a/kernel/hung_task.c
@@ -375,6 +375,31 @@ static long hung_timeout_jiffies(unsigne
 }
 
 #ifdef CONFIG_SYSCTL
+
+/**
+ * proc_dohung_task_detect_count - proc handler for hung_task_detect_count
+ * @table: Pointer to the struct ctl_table definition for this proc entry
+ * @write: Flag indicating the operation
+ * @buffer: User space buffer for data transfer
+ * @lenp: Pointer to the length of the data being transferred
+ * @ppos: Pointer to the current file offset
+ *
+ * This handler is used for reading the current hung task detection count
+ * and for resetting it to zero when a write operation is performed.
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int proc_dohung_task_detect_count(const struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!write)
+		return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+
+	WRITE_ONCE(sysctl_hung_task_detect_count, 0);
+	*ppos += *lenp;
+
+	return 0;
+}
+
 /*
  * Process updating of timeout sysctl
  */
@@ -457,8 +482,8 @@ static const struct ctl_table hung_task_
 		.procname	= "hung_task_detect_count",
 		.data		= &sysctl_hung_task_detect_count,
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



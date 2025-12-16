Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FF521E08D
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765856290; cv=none; b=BD1JAoY6/ilZU7wdL+VngVRjCAxpldqmlupIp6LI4mAwF9L+0qNOwgzZqdWIvWsu5+SSg9odcOUB3YZHwBJhkton7c012mymnZf1CZfIZFiBmhUSUajA2ktp/FsT9wbQPP1iRB7jG+IGVRLVMa7+unq8HB/F2gtmdqNFB3Nc0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765856290; c=relaxed/simple;
	bh=NwNqfXEYgLRsQfZP99zzh7Vf28ssTVwA0SS3CAGqGy8=;
	h=Date:To:From:Subject:Message-Id; b=Xn1ClAeXLJMA2hAg19p4hGQ2j8cg+iSin6c1yI5y4BH97S/SVzKHELGZrv6M622RxMXVO+tGjOTx7niOuIMfra871hSLYo4Ebms6DWuqpFgieIH9uVLLh+wOzDM0hmkdP7oFCLKGlc2+9VJVk1nmLmKttmnRvWx/t5v/i1w3alI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c2TLosf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c2TLosf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B31AC4CEF5;
	Tue, 16 Dec 2025 03:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765856289;
	bh=NwNqfXEYgLRsQfZP99zzh7Vf28ssTVwA0SS3CAGqGy8=;
	h=Date:To:From:Subject:From;
	b=c2TLosf4n8a7dTKaKEZA8Q2KFGj6NaKU1hKe6JB5Nt62hVLaUmGrFkhU3uy1TDgFG
	 /l5p74BUHMCYwvwhcy9FE+a7cw3JW8/3tQlGi4nkOdDKEa6X/C1m3bjNjDbhjm2sFZ
	 vLHNEsSbIJG8VuXbub4EbeyFXhMdqD+0DuUWJR0Y=
Date: Mon, 15 Dec 2025 19:38:09 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-enable-runtime-reset-of-hung_task_detect_count.patch added to mm-nonmm-unstable branch
Message-Id: <20251216033809.8B31AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: enable runtime reset of hung_task_detect_count
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    2 -
 kernel/hung_task.c                          |   29 ++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

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

hung_task-introduce-helper-for-hung-task-warning.patch
hung_task-enable-runtime-reset-of-hung_task_detect_count.patch


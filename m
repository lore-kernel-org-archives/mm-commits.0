Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F179A3191C0
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 22:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768515096; cv=none; b=KS7sRFNdsJ1eyXsEiG23tXcHo2KAepoC5pQKSPpm/T+Jb1sVem2vuPEZ8MRdY3an6G2TZdBgiBL0PTXiQF5FRNqjuc23kHgenVizgZy38B1j//UluaQUEhjm6WVaRnRbvrdGz9AXgru7g2prnwrL0NTXw8oVppmdxkXBC88d8h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768515096; c=relaxed/simple;
	bh=3P8DiBn8DQhEUl/7hXFnNB6e9RRBI1U0Dw0mNaSaB/A=;
	h=Date:To:From:Subject:Message-Id; b=YNxMDyBNybxacsCtbaSY5UWVtjlSDHIGYR5BW22VDwBnWxHzq/7LDOHZAHOzUrcBugO/bRlqSHd7WgFCPMsR6qY10kRB6J9aCTR8C3xkRU7x3es0r/kYmJmI8MErktNtZvdoorZsgq4dDtvgDP8T/QpYCwhD+7jBcAglC7ExmnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rq7pdsQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rq7pdsQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF4DC116D0;
	Thu, 15 Jan 2026 22:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768515095;
	bh=3P8DiBn8DQhEUl/7hXFnNB6e9RRBI1U0Dw0mNaSaB/A=;
	h=Date:To:From:Subject:From;
	b=Rq7pdsQkBhrAlXtQIX1gdAVnGWPOtC4omql+qsFCrfMAjRagZ0xlZjj/7I9IgH8D3
	 Wsutc6bOfC0BgsvwPP0Xgcnt9gBsnJ3sCTqiRpdhlo8OKazHVoxJDMsQw4KWf5EdQ7
	 9rCJJilnZSjjICwIq5sNuDwhcyiRxUVR3JUI20M0=
Date: Thu, 15 Jan 2026 14:11:34 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch added to mm-new branch
Message-Id: <20260115221135.7DF4DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix rw permission issue when handling boot parameter
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: alloc_tag: fix rw permission issue when handling boot parameter
Date: Thu, 15 Jan 2026 03:15:36 +0000

Boot parameters prefixed with "sysctl." are processed during the final
stage of system initialization via kernel_init()-> do_sysctl_args().  When
CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the sysctl.vm.mem_profiling
entry is not writable and will cause a warning.

Before run_init_process(), system initialization executes in kernel thread
context.  Use current->mm to distinguish sysctl writes during
do_sysctl_args() from user-space triggered ones.

And when the proc_handler is from do_sysctl_args(), always return success
because the same value was already set by setup_early_mem_profiling() and
this eliminates a permission denied warning.

Link: https://lkml.kernel.org/r/20260115031536.164254-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter
+++ a/lib/alloc_tag.c
@@ -776,8 +776,22 @@ EXPORT_SYMBOL(page_alloc_tagging_ops);
 static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
 				      void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (!mem_profiling_support && write)
-		return -EINVAL;
+	if (write) {
+		/*
+		 * Call from do_sysctl_args() which is a no-op since the same
+		 * value was already set by setup_early_mem_profiling.
+		 * Return success to avoid warnings from do_sysctl_args().
+		 */
+		if (!current->mm)
+			return 0;
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+		/* User can't toggle profiling while debugging */
+		return -EACCES;
+#endif
+		if (!mem_profiling_support)
+			return -EINVAL;
+	}
 
 	return proc_do_static_key(table, write, buffer, lenp, ppos);
 }
@@ -787,11 +801,7 @@ static const struct ctl_table memory_all
 	{
 		.procname	= "mem_profiling",
 		.data		= &mem_alloc_profiling_key,
-#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
-		.mode		= 0444,
-#else
 		.mode		= 0644,
-#endif
 		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch
alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch


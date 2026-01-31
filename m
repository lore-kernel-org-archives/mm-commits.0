Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0594220CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898285; cv=none; b=nlUFqKG84cs0JzjnzQt2ZUligwulE2tDcXtqQL0FEs2i1dT0sbIpuRLdH2YIwz8nInUFIQE58Gm6PqvF2x5SROisCivGVrWT6Oh4WdtW0OUZth4eNIs0ZNBt3/ejq0lP4GOlRba32bV9XrPECfX1DVVBOUPPjmeRHPRKK2kKwT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898285; c=relaxed/simple;
	bh=dNrcS2fxeJD8LDIS+dWIojIG3s/l/75Ao+xJCNI2xvs=;
	h=Date:To:From:Subject:Message-Id; b=VFdAYTtDKgSeC9GMOMJXBqfMEmaQpJ1lxU2R/Gr+MK16togt01lE+yNkC6Jj3SMN12J9diAF8Sg5asciNrgtVOBZWSMQMcpJjmRsAUTx/O3O78mzLT5KIY1qIErzxJLNvtRquN8K/BxH38X17K6F/J5JPgRGsJgEgOd4iuEbJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vflzxg7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vflzxg7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D090CC4CEF1;
	Sat, 31 Jan 2026 22:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898284;
	bh=dNrcS2fxeJD8LDIS+dWIojIG3s/l/75Ao+xJCNI2xvs=;
	h=Date:To:From:Subject:From;
	b=vflzxg7VrmQpbGrLjvjWSwHMwLlk/nISbWRIeQMCYxWp2Mw2UnQB0TitSui2gwpIk
	 6hWrYo1Zw4vDOqteoHn7SqELRLs3kkV1+pXmYGdyCqMYu28QyFHydjhnEIvbYLRJ3Z
	 AhY7sEyeZKGpfswJTzvlJSgnStt88eAQ6DDTnHaA=
Date: Sat, 31 Jan 2026 14:24:44 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch removed from -mm tree
Message-Id: <20260131222444.D090CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix rw permission issue when handling boot parameter
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



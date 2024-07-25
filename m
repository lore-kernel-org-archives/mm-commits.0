Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910636FB8
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 19:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721936030; cv=none; b=l4nerimXywToZVkNE9md3RnukhmhRD7tQdJEWumVStwytoXPVoWAt/iW5g9Sg9kVJWOPFUzntr9Q0jnrZDiksjfeg2zEbbIVSeQCRzTeDivXnMUcEVNLS5tdNvVV3mkQLl9LDk46U4mw9IxpE2yuRfs9yAz3DBEmnE/y1kGYX2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721936030; c=relaxed/simple;
	bh=1YmfCCjNBpY7aL61Km08EixWRIUsbXMTcuAM+DfrtgQ=;
	h=Date:To:From:Subject:Message-Id; b=T29funQBhepkpXPhjik0By6/mo7U5Jvaybs6OBlN782bQXKhX7hhevHXd0sk/f/7WlV7F1kbBIsQFRJSbHGdR/8r1ZvAC/w8SbeYTY3WYWOmUwLwgrXjewFrETK0qA04cuN4bFKePIdyDknIjQvOyTA7K67CVQ7zr0fhrXtSOIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p4gFHSpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p4gFHSpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABD5C116B1;
	Thu, 25 Jul 2024 19:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721936030;
	bh=1YmfCCjNBpY7aL61Km08EixWRIUsbXMTcuAM+DfrtgQ=;
	h=Date:To:From:Subject:From;
	b=p4gFHSpBsYNi5vBkWqXU7rm6Ws6MeGcMPdXA+JKMAhEHCuOli61DsIbOlM1/kFrpO
	 KoZlwF0Nycq+kzdHNWdNOyzLAcZZhQ88EJjTO1SLyW85NMKZH50SCXsTRXKg74hmB8
	 L6Hd7K67hMaJ4RjVWu1K4j6RqZDoyOPYoxk6oiLk=
Date: Thu, 25 Jul 2024 12:33:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,peterz@infradead.org,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + task_stack-uninline-stack_not_used.patch added to mm-unstable branch
Message-Id: <20240725193350.0ABD5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: task_stack: uninline stack_not_used
has been added to the -mm mm-unstable branch.  Its filename is
     task_stack-uninline-stack_not_used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_stack-uninline-stack_not_used.patch

This patch will later appear in the mm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: task_stack: uninline stack_not_used
Date: Wed, 24 Jul 2024 20:33:22 +0000

Given that stack_not_used() is not performance critical function
uninline it.

Link: https://lkml.kernel.org/r/20240724203322.2765486-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task_stack.h |   18 +++---------------
 kernel/exit.c                    |   19 +++++++++++++++++++
 kernel/sched/core.c              |    4 +---
 3 files changed, 23 insertions(+), 18 deletions(-)

--- a/include/linux/sched/task_stack.h~task_stack-uninline-stack_not_used
+++ a/include/linux/sched/task_stack.h
@@ -95,23 +95,11 @@ static inline int object_is_on_stack(con
 extern void thread_stack_cache_init(void);
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
+unsigned long stack_not_used(struct task_struct *p);
+#else
 static inline unsigned long stack_not_used(struct task_struct *p)
 {
-	unsigned long *n = end_of_stack(p);
-
-	do { 	/* Skip over canary */
-# ifdef CONFIG_STACK_GROWSUP
-		n--;
-# else
-		n++;
-# endif
-	} while (!*n);
-
-# ifdef CONFIG_STACK_GROWSUP
-	return (unsigned long)end_of_stack(p) - (unsigned long)n;
-# else
-	return (unsigned long)n - (unsigned long)end_of_stack(p);
-# endif
+	return 0;
 }
 #endif
 extern void set_task_stack_end_magic(struct task_struct *tsk);
--- a/kernel/exit.c~task_stack-uninline-stack_not_used
+++ a/kernel/exit.c
@@ -778,6 +778,25 @@ static void exit_notify(struct task_stru
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
+unsigned long stack_not_used(struct task_struct *p)
+{
+	unsigned long *n = end_of_stack(p);
+
+	do {	/* Skip over canary */
+# ifdef CONFIG_STACK_GROWSUP
+		n--;
+# else
+		n++;
+# endif
+	} while (!*n);
+
+# ifdef CONFIG_STACK_GROWSUP
+	return (unsigned long)end_of_stack(p) - (unsigned long)n;
+# else
+	return (unsigned long)n - (unsigned long)end_of_stack(p);
+# endif
+}
+
 /* Count the maximum pages reached in kernel stacks */
 static inline void kstack_histogram(unsigned long used_stack)
 {
--- a/kernel/sched/core.c~task_stack-uninline-stack_not_used
+++ a/kernel/sched/core.c
@@ -7405,7 +7405,7 @@ EXPORT_SYMBOL(io_schedule);
 
 void sched_show_task(struct task_struct *p)
 {
-	unsigned long free = 0;
+	unsigned long free;
 	int ppid;
 
 	if (!try_get_task_stack(p))
@@ -7415,9 +7415,7 @@ void sched_show_task(struct task_struct
 
 	if (task_is_running(p))
 		pr_cont("  running task    ");
-#ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
-#endif
 	ppid = 0;
 	rcu_read_lock();
 	if (pid_alive(p))
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch


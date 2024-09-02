Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705C83EA76
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247688; cv=none; b=u/D4+hSvjExnB3qxrgzHk/GkPE5DQ/RrjBGAA/Zt543KirxmtnXsO+JQ4K6LNoqfiZK2C+FVZkvE5Z3bNpHMsOpiCbyfc9DYEy1hY+lwvPNzagNrquZ2gV7Hf4PEOMHmkx9NLFxJs6AOzZTXlAnVZ+twqPXQDpyiwJ9Xc7UQja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247688; c=relaxed/simple;
	bh=F63Gx1bUA22I6nXxcxs0xV4pHDzp6fof/rA7L61SLzM=;
	h=Date:To:From:Subject:Message-Id; b=LOj+IvOXZM/Rd8xacPBx0Td5Fl1NEd0LeKCuqoJz96k2DgTN6Lqspw1qMoF1Yf88ZT0Bd0puAsxplh+SKRWBQguw/Rh9ZEbS5J+TBmUZ+qW0vzkDPfhffcq+c7vurmzpb0fnkObuwt3Hcv1Pd1I6MPv1lDUxIs9UtLC9LkumJug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJb9rWHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJb9rWHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45461C4CEC2;
	Mon,  2 Sep 2024 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247688;
	bh=F63Gx1bUA22I6nXxcxs0xV4pHDzp6fof/rA7L61SLzM=;
	h=Date:To:From:Subject:From;
	b=sJb9rWHrXS1rpZct0FzEY57LSCHO+2QRXG5aX/BD0stI5+p12zYB4KBTOBoBHM4fC
	 6db2HAuwq4G+qsTFRvwaVLoykuebYnVyQklZn++4EhtTlZG+lYf6migOMJjpPF9vC2
	 E74XhKMU2IrT0Z5UfQxudZqTEZZs9d+5wVmKtbDc=
Date: Sun, 01 Sep 2024 20:28:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,peterz@infradead.org,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] task_stack-uninline-stack_not_used.patch removed from -mm tree
Message-Id: <20240902032808.45461C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: task_stack: uninline stack_not_used
has been removed from the -mm tree.  Its filename was
     task_stack-uninline-stack_not_used.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: task_stack: uninline stack_not_used
Date: Wed, 24 Jul 2024 20:33:22 +0000

Given that stack_not_used() is not performance critical function
uninline it.

Link: https://lkml.kernel.org/r/20240730150158.832783-4-pasha.tatashin@soleen.com
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACDD2837A
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741887; cv=none; b=IgV6v1LlXZt5rv/Neyi/hOTb5yT8Rw0RTvAKGQ6yqC1JQiYOZpHXACdJ/6qQBbJ3MARpPiHB2gkTSO9j0r1NGsXuiYoZb2q+QHIcXudPqtF2AWaukrWKW0M5OovxSxsdY0mdPaHc6YZj2xQI529nBOHKjkFY7ApniCmemHNU/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741887; c=relaxed/simple;
	bh=pEzdSQAM0w9upf3AhHeu3WpouRwFHebtKw7U0kpXdkk=;
	h=Date:To:From:Subject:Message-Id; b=V4atOOcm3Q840csiQkivSp04kJsoTjkPztCmW0Kw63MeAVT7oyozUFgYW7kI7P9jj3UpPrMYE5nSFTmOYdl82SJ+Tsf/mqjokrtgLfzcXh72rJhsMxPzfOb4fMsBVGDaO5SsqacgElwls7+ZNFLSne7SbNSPN0VbepCzgyXhX94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1dwMQ3rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1dwMQ3rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8019C4CED6;
	Mon, 13 Jan 2025 04:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741886;
	bh=pEzdSQAM0w9upf3AhHeu3WpouRwFHebtKw7U0kpXdkk=;
	h=Date:To:From:Subject:From;
	b=1dwMQ3rq6c13uRYcR65vrg2Kfd6iVU7ngJWkezGP8bwavZuRdhPk0nIPW0Vhoi+uo
	 +/a0fEO/46gcWWfGs3IPFbL02edcrH0hU+0AEEhgTUmb8ql75jnD+zPHIm/uuC4MXA
	 UfPHRgqU5Ad5t8sw1xjIX+TCODroMzF8GyPJ8zoo=
Date: Sun, 12 Jan 2025 20:18:06 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,rostedt@goodmis.org,peterz@infradead.org,oxana@cloudflare.com,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,jack@suse.cz,dietmar.eggemann@arm.com,bsegall@google.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hung_task-add-task-flags-blocked-by-coredump-to-log-fix.patch removed from -mm tree
Message-Id: <20250113041806.B8019C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task-add-task-flags-blocked-by-coredump-to-log-fix
has been removed from the -mm tree.  Its filename was
     hung_task-add-task-flags-blocked-by-coredump-to-log-fix.patch

This patch was dropped because it was folded into hung_task-add-task-flags-blocked-by-coredump-to-log.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hung_task-add-task-flags-blocked-by-coredump-to-log-fix
Date: Fri Jan 10 07:51:53 PM PST 2025

fix printk control string

In file included from ./include/asm-generic/bug.h:22,
                 from ./arch/x86/include/asm/bug.h:99,
                 from ./include/linux/bug.h:5,
                 from ./arch/x86/include/asm/paravirt.h:19,
                 from ./arch/x86/include/asm/irqflags.h:80,
                 from ./include/linux/irqflags.h:18,
                 from ./include/linux/spinlock.h:59,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from ./include/linux/highmem.h:5,
                 from kernel/sched/core.c:10:
kernel/sched/core.c: In function 'sched_show_task':
./include/linux/kern_levels.h:5:25: error: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]
    5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
      |                         ^~~~~~
./include/linux/printk.h:473:25: note: in definition of macro 'printk_index_wrap'
  473 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
      |                         ^~~~
./include/linux/printk.h:586:9: note: in expansion of macro 'printk'
  586 |         printk(KERN_CONT fmt, ##__VA_ARGS__)
      |         ^~~~~~
./include/linux/kern_levels.h:24:25: note: in expansion of macro 'KERN_SOH'
   24 | #define KERN_CONT       KERN_SOH "c"
      |                         ^~~~~~~~
./include/linux/printk.h:586:16: note: in expansion of macro 'KERN_CONT'
  586 |         printk(KERN_CONT fmt, ##__VA_ARGS__)
      |                ^~~~~~~~~
kernel/sched/core.c:7704:9: note: in expansion of macro 'pr_cont'
 7704 |         pr_cont(" stack:%-5lu pid:%-5d tgid:%-5d ppid:%-6d task_flags:0x%08lx flags:0x%08lx\n",
      |         ^~~~~~~
cc1: all warnings being treated as errors

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oxana Kharitonova <oxana@cloudflare.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c~hung_task-add-task-flags-blocked-by-coredump-to-log-fix
+++ a/kernel/sched/core.c
@@ -7701,7 +7701,7 @@ void sched_show_task(struct task_struct
 	if (pid_alive(p))
 		ppid = task_pid_nr(rcu_dereference(p->real_parent));
 	rcu_read_unlock();
-	pr_cont(" stack:%-5lu pid:%-5d tgid:%-5d ppid:%-6d task_flags:0x%08lx flags:0x%08lx\n",
+	pr_cont(" stack:%-5lu pid:%-5d tgid:%-5d ppid:%-6d task_flags:0x%04x flags:0x%08lx\n",
 		free, task_pid_nr(p), task_tgid_nr(p),
 		ppid, p->flags, read_task_thread_flags(p));
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch
hung_task-add-task-flags-blocked-by-coredump-to-log.patch


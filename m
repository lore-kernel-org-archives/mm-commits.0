Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84C63A2E07;
	Wed, 13 May 2026 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693233; cv=none; b=RhZNnlovKrXMAT2K6ogN05X66TvdTIWYvoMSRLnJSZMLgn9/gki2CO1goD/BHI6mxllm8AaTz+zTjKGgower32OI+fbCESWIZAQkQhEwwLhDckBalAX00EIgx208CkIv4Qb9L52Et77x4lcPuv+yxv/hCQ2UQNjQJuBKAIUazxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693233; c=relaxed/simple;
	bh=xbNqFRfEPLDvfnXWBGOb0+DeiVRfeyxliAUWgIwEAjg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=M7gF0RwEXou1baubtNL4PC80z9cHToLo8hvJNXTFUnfZVyazzz9KwfY+s/ZP7eaLJU+GsdaTlkwEkBJyvGjgCaBeoli++MLwnSrTgD4lSJXoyIDN6XjYICiLgCQXLZo4MITh/Lxpvo7zePNv2hrYxUc+47ZBj71a0nWFUU782w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQE06z6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQE06z6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7413DC2BCB7;
	Wed, 13 May 2026 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778693232;
	bh=xbNqFRfEPLDvfnXWBGOb0+DeiVRfeyxliAUWgIwEAjg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eQE06z6gjM3bpDzZDm5424CoAuAbjQ4g/r3MVc8E6oBphcGLkKpJkYplWwSeixdEv
	 YAIVBz8nUCiLXEJu0wNFZATFBujKfKZUtt/AJSL6eZZcG08a5uEpQvxWUaWmzesVhJ
	 dbdVPUleVowZaPXXcNEHPb+ZvoKfzKVQfcgHLG60=
Date: Wed, 13 May 2026 10:27:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Minchan Kim <minchan@kernel.org>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new 301/315] mm/oom_kill.c:922:12: warning:
 'kill_all_shared_mm' defined but not used
Message-Id: <20260513102711.323fed51b7dbb1dfe6217b44@linux-foundation.org>
In-Reply-To: <202605131940.kEzvUaiR-lkp@intel.com>
References: <202605131940.kEzvUaiR-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 May 2026 19:48:25 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   2c3f468717231305523ddcd94d91c0d5e4a72419
> commit: def36547cd98fa3f7ecac1bf860479f500bc6b1e [301/315] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]
>      922 | static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)

Thanks. I  did this:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
Date: Wed May 13 10:22:14 AM PDT 2026

move kill_all_shared_mm() inside CONFIG_MMU

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   66 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

--- a/mm/oom_kill.c~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
+++ a/mm/oom_kill.c
@@ -676,6 +676,39 @@ static void wake_oom_reaper(struct timer
 }
 
 /*
+ * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
+ * @victim: the targeted OOM process group leader
+ * @mm:     the virtual memory space being reaped
+ *
+ * Traverse all threads globally and signal any user processes sharing the
+ * identical mm footprints, ensuring no concurrent users pin the memory. Skips
+ * the system global init and kernel worker threads.
+ */
+static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
+{
+	struct task_struct *p;
+	bool failed = false;
+
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (is_global_init(p)) {
+			failed = true;
+			continue;
+		}
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+
+		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
+			failed = true;
+	}
+	rcu_read_unlock();
+
+	return failed ? -EBUSY : 0;
+}
+
+/*
  * Give the OOM victim time to exit naturally before invoking the oom_reaping.
  * The timers timeout is arbitrary... the longer it is, the longer the worst
  * case scenario for the OOM can take. If it is too small, the oom_reaper can
@@ -910,39 +943,6 @@ static bool task_will_free_mem(struct ta
 	return ret;
 }
 
-/*
- * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
- * @victim: the targeted OOM process group leader
- * @mm:     the virtual memory space being reaped
- *
- * Traverse all threads globally and signal any user processes sharing the identical
- * mm footprints, ensuring no concurrent users pin the memory. Skips the system
- * global init and kernel worker threads.
- */
-static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
-{
-	struct task_struct *p;
-	bool failed = false;
-
-	rcu_read_lock();
-	for_each_process(p) {
-		if (!process_shares_mm(p, mm))
-			continue;
-		if (is_global_init(p)) {
-			failed = true;
-			continue;
-		}
-		if (unlikely(p->flags & PF_KTHREAD))
-			continue;
-
-		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
-			failed = true;
-	}
-	rcu_read_unlock();
-
-	return failed ? -EBUSY : 0;
-}
-
 static void __oom_kill_process(struct task_struct *victim, const char *message)
 {
 	struct task_struct *p;
_


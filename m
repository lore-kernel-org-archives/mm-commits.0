Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7B0171BB
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779146023; cv=none; b=YQtmM31Sw9AT4AwlqBrk1oclnnJ8zJhLCISCcy7Iw2ajHHXRN/DdAdGV/FSAOcznoej0YCAhQ+j/cOPAANP3GGohLl9hRgHprkJlnEKWzpeyNCKFNmM1Q1mtCMUessmO9Wk2pFvKpI8gbXW6qPIMxHxnYyA4BEhCMwF58YMLF9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779146023; c=relaxed/simple;
	bh=eAMC8OS1cqQ/pinLwJSztjZBrjtUWSeOcI0dwtcpb/g=;
	h=Date:To:From:Subject:Message-Id; b=MsUTNcJoJxLK9gmaMdWgtWL6F/LDkbHuWtgpL+nwr4DsdRIKIP4uJBTJCyLHLV4rXY5zgE/R3UN8DapxqfqnGfp+ZkSp8bwyQ7KJyHxfc3/bi6oTQFf6zj51S2HYU975+nuoN0brTHh7a7ifpC/hWzR1oa9XM7RIxO4k1tvPA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gFOHPg1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gFOHPg1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74554C2BCB7;
	Mon, 18 May 2026 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779146023;
	bh=eAMC8OS1cqQ/pinLwJSztjZBrjtUWSeOcI0dwtcpb/g=;
	h=Date:To:From:Subject:From;
	b=gFOHPg1VenddGo76M4M3Qt//gyA3azC1KH1OlUBjWyCs6DWV50GP+DWUJn9Sd0nXk
	 Khmg4T0436bx0zx6pKRgZWcQKC5hyQAr/wf+pRdbuM/LZvUAFs/kd81hoZcpj4HM8I
	 0e/vksqypiPpdFE2M6JnSUR/IUyhmOjG0YQlHOGI=
Date: Mon, 18 May 2026 16:13:42 -0700
To: mm-commits@vger.kernel.org,timmurray@google.com,surenb@google.com,minchan@kernel.org,mhocko@suse.com,lkp@intel.com,hca@linux.ibm.com,david@kernel.org,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch removed from -mm tree
Message-Id: <20260518231343.74554C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch

This patch was dropped because it was folded into mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch

------------------------------------------------------
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch


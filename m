Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE3E7346F;
	Thu, 16 Jan 2025 05:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006240; cv=none; b=VnWtlMFSyTSYttZ66eTXqAXeNQIumoFVCiS2bnxb2nPbYi97bCic2Phh154PRRtOVjTNzh0GtO43CH9IlPMEQT+1GhgLmNO+dZKmt+lF+Sl3UIF17On2JOZuw9ppTELFzqThsij5MwwQunAmrdIggYRAIrVaVPGDmY3obTkD7V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006240; c=relaxed/simple;
	bh=sKPLjQHoglkW6ceUFpnkVoQIURajNn1Ecl+60kbmeMQ=;
	h=Date:To:From:Subject:Message-Id; b=cZisaIkrZ614RJk9x/02GBxSAN+g33JyvsR9XZMC4Hsbha/wpYqHH/WndhN9cCRqPlC59VHIuR5MMQ+2adcZqBtWEaWikX1BBOgp1e388r4NYli/1uPw9YlBM1GaMtzx+la5R4WyugdZRzYKrIkBKCAQuSAjETadvt0/C9NWDXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBIzyWaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBIzyWaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED134C4CED6;
	Thu, 16 Jan 2025 05:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006240;
	bh=sKPLjQHoglkW6ceUFpnkVoQIURajNn1Ecl+60kbmeMQ=;
	h=Date:To:From:Subject:From;
	b=pBIzyWaqBka9GddGfXOlw0NP56yaZPBCgtfHSaJK7PqE7TaGMQvfoErkIiZV9bcJL
	 6uaZKkGbRbWaz1EgnvZZTXVFJvbf/q/EvbL03C4207ctoc6ZHwOZvXHWqiFe9zVbGl
	 g85UjRg/IOZ1qE6wSOCWdTP/nJVxaK50wBQkJhWQ=
Date: Wed, 15 Jan 2025 21:43:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-fix-soft-lockup-in-the-oom-process.patch removed from -mm tree
Message-Id: <20250116054359.ED134C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: fix soft lockup in the OOM process
has been removed from the -mm tree.  Its filename was
     memcg-fix-soft-lockup-in-the-oom-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: fix soft lockup in the OOM process
Date: Tue, 24 Dec 2024 02:52:38 +0000

A soft lockup issue was found in the product with about 56,000 tasks were
in the OOM cgroup, it was traversing them when the soft lockup was
triggered.

watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [VM Thread:1503066]
CPU: 2 PID: 1503066 Comm: VM Thread Kdump: loaded Tainted: G
Hardware name: Huawei Cloud OpenStack Nova, BIOS
RIP: 0010:console_unlock+0x343/0x540
RSP: 0000:ffffb751447db9a0 EFLAGS: 00000247 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000247
RBP: ffffffffafc71f90 R08: 0000000000000000 R09: 0000000000000040
R10: 0000000000000080 R11: 0000000000000000 R12: ffffffffafc74bd0
R13: ffffffffaf60a220 R14: 0000000000000247 R15: 0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2fe6ad91f0 CR3: 00000004b2076003 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vprintk_emit+0x193/0x280
 printk+0x52/0x6e
 dump_task+0x114/0x130
 mem_cgroup_scan_tasks+0x76/0x100
 dump_header+0x1fe/0x210
 oom_kill_process+0xd1/0x100
 out_of_memory+0x125/0x570
 mem_cgroup_out_of_memory+0xb5/0xd0
 try_charge+0x720/0x770
 mem_cgroup_try_charge+0x86/0x180
 mem_cgroup_try_charge_delay+0x1c/0x40
 do_anonymous_page+0xb5/0x390
 handle_mm_fault+0xc4/0x1f0

This is because thousands of processes are in the OOM cgroup, it takes a
long time to traverse all of them.  As a result, this lead to soft lockup
in the OOM process.

To fix this issue, call 'cond_resched' in the 'mem_cgroup_scan_tasks'
function per 1000 iterations.  For global OOM, call
'touch_softlockup_watchdog' per 1000 iterations to avoid this issue.

Link: https://lkml.kernel.org/r/20241224025238.3768787-1-chenridong@huaweicloud.com
Fixes: 9cbb78bb3143 ("mm, memcg: introduce own oom handler to iterate only over its own threads")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 mm/oom_kill.c   |    8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-fix-soft-lockup-in-the-oom-process
+++ a/mm/memcontrol.c
@@ -1161,6 +1161,7 @@ void mem_cgroup_scan_tasks(struct mem_cg
 {
 	struct mem_cgroup *iter;
 	int ret = 0;
+	int i = 0;
 
 	BUG_ON(mem_cgroup_is_root(memcg));
 
@@ -1169,8 +1170,12 @@ void mem_cgroup_scan_tasks(struct mem_cg
 		struct task_struct *task;
 
 		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
-		while (!ret && (task = css_task_iter_next(&it)))
+		while (!ret && (task = css_task_iter_next(&it))) {
+			/* Avoid potential softlockup warning */
+			if ((++i & 1023) == 0)
+				cond_resched();
 			ret = fn(task, arg);
+		}
 		css_task_iter_end(&it);
 		if (ret) {
 			mem_cgroup_iter_break(memcg, iter);
--- a/mm/oom_kill.c~memcg-fix-soft-lockup-in-the-oom-process
+++ a/mm/oom_kill.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/mmu_notifier.h>
 #include <linux/cred.h>
+#include <linux/nmi.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -430,10 +431,15 @@ static void dump_tasks(struct oom_contro
 		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
 	else {
 		struct task_struct *p;
+		int i = 0;
 
 		rcu_read_lock();
-		for_each_process(p)
+		for_each_process(p) {
+			/* Avoid potential softlockup warning */
+			if ((++i & 1023) == 0)
+				touch_softlockup_watchdog();
 			dump_task(p, oc);
+		}
 		rcu_read_unlock();
 	}
 }
_

Patches currently in -mm which might be from chenridong@huawei.com are



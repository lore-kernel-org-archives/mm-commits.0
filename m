Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E6C27291F
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739317488; cv=none; b=b7ps9wt5vOA4XRcvzUMOfNYPlkG1tq5rpgCEULVWV9t1c+1fbi9NpRmpS7GB4DoZAKoH5lwD8mdESkDFGkZvORSYKwdQ0xVbJjNbhhsPz+FNSctYPlxS7+ho5/pesPT9T/qfzBpeMtTW7/dtCDoDcIvLbFAJ6nt1cU02DvCz+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739317488; c=relaxed/simple;
	bh=u4YzsTXaJC46WlAhXHLWQCGPSkzKJ9RUlxBJOLABMMw=;
	h=Date:To:From:Subject:Message-Id; b=LQwGMJ34g4jeFh/k0rD9FMCFa9a2omW6NcLpbIgoptNdV43H+WwcMhLo3desVvQPBGrrenkmEebE6XAMlfpqyN1rE4IKRcLCOEMce+8N/0Q6wcSk+wVdc/zDa7E+CaYfcGgQW+7bIFFO2BtoUvnzA2JC3sWl1vVzhjyiigQ5tMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZuS9pfoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZuS9pfoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F5AC4CEDD;
	Tue, 11 Feb 2025 23:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739317487;
	bh=u4YzsTXaJC46WlAhXHLWQCGPSkzKJ9RUlxBJOLABMMw=;
	h=Date:To:From:Subject:From;
	b=ZuS9pfoXQYh9qdYNvfLZASdkgkL4gvfHLoiT/3+FxOoV0lf//8nT7O+LrOix0rVLp
	 uBZ7PUbBkHQ/HZJYmgkYWNb+Wb0mgUyGNWpEXsXjM6RfiVdyjc4T2ICmVF/M3I4i5h
	 vLXnJwX3JzumegITmPUa9VZ3gya5cgq1OcIwotug=
Date: Tue, 11 Feb 2025 15:44:46 -0800
To: mm-commits@vger.kernel.org,wangweiyang2@huawei.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-avoid-dead-loop-when-setting-memorymax.patch added to mm-hotfixes-unstable branch
Message-Id: <20250211234447.33F5AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: avoid dead loop when setting memory.max
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-avoid-dead-loop-when-setting-memorymax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-avoid-dead-loop-when-setting-memorymax.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: avoid dead loop when setting memory.max
Date: Tue, 11 Feb 2025 08:18:19 +0000

A softlockup issue was found with stress test:
 watchdog: BUG: soft lockup - CPU#27 stuck for 26s! [migration/27:181]
 CPU: 27 UID: 0 PID: 181 Comm: migration/27 6.14.0-rc2-next-20250210 #1
 Stopper: multi_cpu_stop <- stop_machine_from_inactive_cpu
 RIP: 0010:stop_machine_yield+0x2/0x10
 RSP: 0000:ff4a0dcecd19be48 EFLAGS: 00000246
 RAX: ffffffff89c0108f RBX: ff4a0dcec03afe44 RCX: 0000000000000000
 RDX: ff1cdaaf6eba5808 RSI: 0000000000000282 RDI: ff1cda80c1775a40
 RBP: 0000000000000001 R08: 00000011620096c6 R09: 7fffffffffffffff
 R10: 0000000000000001 R11: 0000000000000100 R12: ff1cda80c1775a40
 R13: 0000000000000000 R14: 0000000000000001 R15: ff4a0dcec03afe20
 FS:  0000000000000000(0000) GS:ff1cdaaf6eb80000(0000)
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 00000025e2c2a001 CR4: 0000000000773ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  multi_cpu_stop+0x8f/0x100
  cpu_stopper_thread+0x90/0x140
  smpboot_thread_fn+0xad/0x150
  kthread+0xc2/0x100
  ret_from_fork+0x2d/0x50

The stress test involves CPU hotplug operations and memory control group
(memcg) operations. The scenario can be described as follows:

 echo xx > memory.max 	cache_ap_online			oom_reaper
 (CPU23)						(CPU50)
 xx < usage		stop_machine_from_inactive_cpu
 for(;;)			// all active cpus
 trigger OOM		queue_stop_cpus_work
 // waiting oom_reaper
 			multi_cpu_stop(migration/xx)
 			// sync all active cpus ack
 			// waiting cpu23 ack
 			// CPU50 loops in multi_cpu_stop
 							waiting cpu50

Detailed explanation:
1. When the usage is larger than xx, an OOM may be triggered. If the
   process does not handle with ths kill signal immediately, it will loop
   in the memory_max_write.
2. When cache_ap_online is triggered, the multi_cpu_stop is queued to the
   active cpus. Within the multi_cpu_stop function,  it attempts to
   synchronize the CPU states. However, the CPU23 didn't acknowledge
   because it is stuck in a loop within the for(;;).
3. The oom_reaper process is blocked because CPU50 is in a loop, waiting
   for CPU23 to acknowledge the synchronization request.
4. Finally, it formed cyclic dependency and lead to softlockup and dead
   loop.

To fix this issue, add cond_resched() in the memory_max_write, so that it
will not block migration task.

Link: https://lkml.kernel.org/r/20250211081819.33307-1-chenridong@huaweicloud.com
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~memcg-avoid-dead-loop-when-setting-memorymax
+++ a/mm/memcontrol.c
@@ -4166,6 +4166,7 @@ static ssize_t memory_max_write(struct k
 		memcg_memory_event(memcg, MEMCG_OOM);
 		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
 			break;
+		cond_resched();
 	}
 
 	memcg_wb_domain_size_changed(memcg);
_

Patches currently in -mm which might be from chenridong@huawei.com are

memcg-avoid-dead-loop-when-setting-memorymax.patch
memcg-use-ofp_peak_unset-instead-of-1.patch
memcg-call-the-free-function-when-allocation-of-pn-fails.patch
memcg-factor-out-the-replace_stock_objcg-function.patch
memcg-add-config_memcg_v1-for-local-functions.patch


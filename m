From: akpm@linux-foundation.org
Subject: + oom-kill-init-lead-panic.patch added to -mm tree
Date: Wed, 02 Dec 2015 15:30:48 -0800
Message-ID: <565f7f28.vFfWwxT5w8sh9tjK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbbLBXat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 18:30:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenjie6@huawei.com, lizefan@huawei.com, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: avoid attempting to kill init sharing same memory
has been added to the -mm tree.  Its filename is
     oom-kill-init-lead-panic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-kill-init-lead-panic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-kill-init-lead-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Jie <chenjie6@huawei.com>
Subject: mm/oom_kill.c: avoid attempting to kill init sharing same memory

It's possible that an oom killed victim shares an ->mm with the init
process and thus oom_kill_process() would end up trying to kill init as
well.

This has been shown in practice:

	Out of memory: Kill process 9134 (init) score 3 or sacrifice child
	Killed process 9134 (init) total-vm:1868kB, anon-rss:84kB, file-rss:572kB
	Kill process 1 (init) sharing same memory
	...
	Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009

And this will result in a kernel panic.

If a process is forked by init and selected for oom kill while still
sharing init_mm, then it's likely this system is in a recoverable state. 
However, it's better not to try to kill init and allow the machine to
panic due to unkillable processes.

[rientjes@google.com: rewrote changelog]
Signed-off-by: Chen Jie <chenjie6@huawei.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-kill-init-lead-panic mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-init-lead-panic
+++ a/mm/oom_kill.c
@@ -608,6 +608,8 @@ void oom_kill_process(struct oom_control
 			continue;
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
+		if (!is_global_init(p))
+			continue;
 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 			continue;
 
_

Patches currently in -mm which might be from chenjie6@huawei.com are

oom-kill-init-lead-panic.patch


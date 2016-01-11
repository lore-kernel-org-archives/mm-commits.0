From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom-introduce-oom-reaper-fix-5.patch removed
 from -mm tree
Date: Mon, 11 Jan 2016 14:47:52 -0800
Message-ID: <56943118.stVUhOXIimlsmJJQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbcAKWrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:47:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: mm, oom: introduce oom reaper
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-fix-5.patch

This patch was dropped because it was folded into mm-oom-introduce-oom-reaper.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: mm, oom: introduce oom reaper

On Thu 17-12-15 16:15:21, Andrew Morton wrote:
> On Tue, 15 Dec 2015 19:36:15 +0100 Michal Hocko <mhocko@kernel.org> wrote:
>
> > This patch reduces the probability of such a lockup by introducing a
> > specialized kernel thread (oom_reaper)
>
> CONFIG_MMU=n:
>
> slub.c:(.text+0x4184): undefined reference to `tlb_gather_mmu'
> slub.c:(.text+0x41bc): undefined reference to `unmap_page_range'
> slub.c:(.text+0x41d8): undefined reference to `tlb_finish_mmu'
>
> I did the below so I can get an mmotm out the door, but hopefully
> there's a cleaner way.

Sorry about that and thanks for your fixup! I am not very familiar with
!MMU world and haven't heard about issues with the OOM deadlocks yet. So
I guess making this MMU only makes some sense. I would just get rid of
ifdefs in oom_kill_process and provide an empty wake_oom_reaper for
!CONFIG_MMU.  The following on top of yours:


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-5 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-5
+++ a/mm/oom_kill.c
@@ -536,6 +536,10 @@ static int __init oom_init(void)
 	return 0;
 }
 module_init(oom_init)
+#else
+static void wake_oom_reaper(struct mm_struct *mm)
+{
+}
 #endif
 
 /**
@@ -647,9 +651,7 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
-#ifdef CONFIG_MMU
 	bool can_oom_reap = true;
-#endif
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -742,7 +744,6 @@ void oom_kill_process(struct oom_control
 			continue;
 		if (is_global_init(p))
 			continue;
-#ifdef CONFIG_MMU
 		if (unlikely(p->flags & PF_KTHREAD) ||
 		    p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
 			/*
@@ -753,15 +754,12 @@ void oom_kill_process(struct oom_control
 			can_oom_reap = false;
 			continue;
 		}
-#endif
 		do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 	}
 	rcu_read_unlock();
 
-#ifdef CONFIG_MMU
 	if (can_oom_reap)
 		wake_oom_reaper(mm);
-#endif
 
 	mmdrop(mm);
 	put_task_struct(victim);
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
mm-oom-introduce-oom-reaper.patch


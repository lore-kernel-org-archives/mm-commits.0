From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-oom-reaper-fix-5.patch added to -mm tree
Date: Fri, 18 Dec 2015 13:22:12 -0800
Message-ID: <56747904.zZsjNpZCLwRC2ZSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992AbbLRVWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 16:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: mm, oom: introduce oom reaper
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-oom-reaper-fix-5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-oom-reaper-fix-5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-oom-reaper-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -537,6 +537,10 @@ static int __init oom_init(void)
 	return 0;
 }
 module_init(oom_init)
+#else
+static void wake_oom_reaper(struct mm_struct *mm)
+{
+}
 #endif
 
 /**
@@ -648,9 +652,7 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
-#ifdef CONFIG_MMU
 	bool can_oom_reap = true;
-#endif
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -743,7 +745,6 @@ void oom_kill_process(struct oom_control
 			continue;
 		if (is_global_init(p))
 			continue;
-#ifdef CONFIG_MMU
 		if (unlikely(p->flags & PF_KTHREAD) ||
 		    p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
 			/*
@@ -754,15 +755,12 @@ void oom_kill_process(struct oom_control
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
mm-oom-introduce-oom-reaper-fix.patch
mm-oom-introduce-oom-reaper-fix-4.patch
mm-oom-introduce-oom-reaper-fix-5.patch


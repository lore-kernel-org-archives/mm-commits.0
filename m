From: akpm@linux-foundation.org
Subject: [folded-merged]
 oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch removed from -mm tree
Date: Thu, 19 May 2016 16:49:54 -0700
Message-ID: <573e5122.UKzzG3pUH1YcmMn7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbcESXtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix
has been removed from the -mm tree.  Its filename was
     oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch

This patch was dropped because it was folded into oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix

fix nommu build

mm/oom_kill.c:644: error: redefinition of 'try_oom_reaper'
include/linux/oom.h:78: note: previous definition of 'try_oom_reaper' was here

Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/oom_kill.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix
+++ a/mm/oom_kill.c
@@ -641,10 +641,6 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static void try_oom_reaper(struct task_struct *tsk)
-{
-}

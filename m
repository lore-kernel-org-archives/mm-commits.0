From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-oom-reaper-fix-4.patch added to -mm tree
Date: Fri, 18 Dec 2015 13:06:09 -0800
Message-ID: <56747541.QA4zQk/+CFnSxjZS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965135AbbLRVGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 16:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-fix-4
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-oom-reaper-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-oom-reaper-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-oom-reaper-fix-4.patch

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
Subject: mm-oom-introduce-oom-reaper-fix-4



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-4 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-4
+++ a/mm/oom_kill.c
@@ -472,8 +472,10 @@ static void oom_reap_vmas(struct mm_stru
 	int attempts = 0;
 
 	/* Retry the down_read_trylock(mmap_sem) a few times */
-	while (attempts++ < 10 && !__oom_reap_vmas(mm))
-		msleep_interruptible(100);
+	while (attempts++ < 10 && !__oom_reap_vmas(mm)) {
+		__set_task_state(current, TASK_IDLE);
+		schedule_timeout(HZ/10);
+	}
 
 	/* Drop a reference taken by wake_oom_reaper */
 	mmdrop(mm);
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
mm-oom-introduce-oom-reaper-fix.patch
mm-oom-introduce-oom-reaper-fix-4.patch


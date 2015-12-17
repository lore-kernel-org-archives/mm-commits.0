From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-oom-reaper-fix.patch added to -mm tree
Date: Thu, 17 Dec 2015 13:14:22 -0800
Message-ID: <567325ae.tYlyc1ZakHUOAfRU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbbLQVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 16:14:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-fix
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-oom-reaper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-oom-reaper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-oom-reaper-fix.patch

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
Subject: mm-oom-introduce-oom-reaper-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix
+++ a/mm/oom_kill.c
@@ -470,7 +470,7 @@ static void oom_reap_vmas(struct mm_stru
 	int attempts = 0;
 
 	while (attempts++ < 10 && !__oom_reap_vmas(mm))
-		schedule_timeout(HZ/10);
+		msleep_interruptible(100);
 
 	/* Drop a reference taken by wake_oom_reaper */
 	mmdrop(mm);
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
mm-oom-introduce-oom-reaper-fix.patch


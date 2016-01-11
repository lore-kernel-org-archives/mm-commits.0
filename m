From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom-introduce-oom-reaper-fix-4.patch removed
 from -mm tree
Date: Mon, 11 Jan 2016 14:47:47 -0800
Message-ID: <56943113.A/S9UYPJlM2G8MSi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbcAKWrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-fix-4
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-fix-4.patch

This patch was dropped because it was folded into mm-oom-introduce-oom-reaper.patch

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
@@ -471,8 +471,10 @@ static void oom_reap_vmas(struct mm_stru
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
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-fix-5.patch


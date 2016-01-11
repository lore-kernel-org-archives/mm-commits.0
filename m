From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom-introduce-oom-reaper-fix.patch removed
 from -mm tree
Date: Mon, 11 Jan 2016 14:47:34 -0800
Message-ID: <56943106.w3JxBxAC6GVs0/xH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbcAKWrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-fix.patch

This patch was dropped because it was folded into mm-oom-introduce-oom-reaper.patch

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
@@ -469,7 +469,7 @@ static void oom_reap_vmas(struct mm_stru
 	int attempts = 0;
 
 	while (attempts++ < 10 && !__oom_reap_vmas(mm))
-		schedule_timeout(HZ/10);
+		msleep_interruptible(100);
 
 	/* Drop a reference taken by wake_oom_reaper */
 	mmdrop(mm);
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-fix-4.patch
mm-oom-introduce-oom-reaper-fix-5.patch


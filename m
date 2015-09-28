From: akpm@linux-foundation.org
Subject: [merged] vmscan-build-fix.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:13 -0700
Message-ID: <560983ed.gH6Vi8bGWoVWmg+B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan build fix
has been removed from the -mm tree.  Its filename was
     vmscan-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: vmscan build fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-build-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-build-fix
+++ a/mm/vmscan.c
@@ -175,7 +175,7 @@ static bool sane_reclaim(struct scan_con
 	if (!memcg)
 		return true;
 #ifdef CONFIG_CGROUP_WRITEBACK
-	if (cgroup_on_dfl(memcg->css.cgroup))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 #endif
 	return false;
_

Patches currently in -mm which might be from mhocko@kernel.org are



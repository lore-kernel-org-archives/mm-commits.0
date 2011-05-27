From: akpm@linux-foundation.org
Subject: [merged] memcg-move-page-freeing-code-out-of-lock.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:06 -0700
Message-ID: <201105271956.p4RJuBNB017527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0T4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: move page-freeing code out of lock
has been removed from the -mm tree.  Its filename was
     memcg-move-page-freeing-code-out-of-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move page-freeing code out of lock
From: Namhyung Kim <namhyung@gmail.com>

Move page-freeing code out of swap_cgroup_mutex in the hope that it could
reduce few of theoretical contentions between swapons and/or swapoffs.

This is just a cleanup, no functional changes.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/page_cgroup.c~memcg-move-page-freeing-code-out-of-lock mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-move-page-freeing-code-out-of-lock
+++ a/mm/page_cgroup.c
@@ -492,8 +492,8 @@ int swap_cgroup_swapon(int type, unsigne
 		/* memory shortage */
 		ctrl->map = NULL;
 		ctrl->length = 0;
-		vfree(array);
 		mutex_unlock(&swap_cgroup_mutex);
+		vfree(array);
 		goto nomem;
 	}
 	mutex_unlock(&swap_cgroup_mutex);
@@ -508,7 +508,8 @@ nomem:
 
 void swap_cgroup_swapoff(int type)
 {
-	int i;
+	struct page **map;
+	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
 	if (!do_swap_account)
@@ -516,17 +517,20 @@ void swap_cgroup_swapoff(int type)
 
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl = &swap_cgroup_ctrl[type];
-	if (ctrl->map) {
-		for (i = 0; i < ctrl->length; i++) {
-			struct page *page = ctrl->map[i];
+	map = ctrl->map;
+	length = ctrl->length;
+	ctrl->map = NULL;
+	ctrl->length = 0;
+	mutex_unlock(&swap_cgroup_mutex);
+
+	if (map) {
+		for (i = 0; i < length; i++) {
+			struct page *page = map[i];
 			if (page)
 				__free_page(page);
 		}
-		vfree(ctrl->map);
-		ctrl->map = NULL;
-		ctrl->length = 0;
+		vfree(map);
 	}
-	mutex_unlock(&swap_cgroup_mutex);
 }
 
 #endif
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch


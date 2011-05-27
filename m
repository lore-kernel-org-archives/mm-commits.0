From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:04 -0700
Message-ID: <201105271956.p4RJu9PA017523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0T4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix off-by-one when calculating swap cgroup map length
has been removed from the -mm tree.  Its filename was
     memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix off-by-one when calculating swap cgroup map length
From: Namhyung Kim <namhyung@gmail.com>

It allocated one more page than necessary if @max_pages was a multiple of
SC_PER_PAGE.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length
+++ a/mm/page_cgroup.c
@@ -475,7 +475,7 @@ int swap_cgroup_swapon(int type, unsigne
 	if (!do_swap_account)
 		return 0;
 
-	length = ((max_pages/SC_PER_PAGE) + 1);
+	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
 	array = vmalloc(array_size);
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch


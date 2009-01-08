From: akpm@linux-foundation.org
Subject: - memcg-dont-trigger-oom-at-page-migration.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:35 -0800
Message-ID: <200901082249.n08MnZTm028860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763043AbZAHWuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: don't trigger oom at page migration
has been removed from the -mm tree.  Its filename was
     memcg-dont-trigger-oom-at-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: don't trigger oom at page migration
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

I think triggering OOM at mem_cgroup_prepare_migration would be just a bit
overkill.  Returning -ENOMEM would be enough for
mem_cgroup_prepare_migration.  The caller would handle the case anyway.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-dont-trigger-oom-at-page-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-trigger-oom-at-page-migration
+++ a/mm/memcontrol.c
@@ -1361,7 +1361,7 @@ int mem_cgroup_prepare_migration(struct 
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch


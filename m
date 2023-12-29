Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A942C63BD
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 04:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pl5VgQ4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0395C433C7;
	Fri, 29 Dec 2023 04:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703824005;
	bh=pqw4Uy4Gl4lRr0wzeCcU8/xXPt5n6y3m2Ls9s5GAtNg=;
	h=Date:To:From:Subject:From;
	b=pl5VgQ4TJ4omTTx0oCfA8Dn3s+tpLRErUOCt9SfI/l9F/w25A295SoEreffbMDQwr
	 a+B61wp+9yDhEZ1PFsLiEgz/DkGpMFMgNslS3zdWhak5O86zY1AKs2ELRkJ7wbrfpX
	 wBBjvp2Tao/wJHAsdkMuTDYlzHulj2pgAdJAK4fI=
Date: Thu, 28 Dec 2023 20:26:44 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,rafael@kernel.org,gregkh@linuxfoundation.org,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-move-pgdemote_-out-of-config_numa_balancing.patch added to mm-unstable branch
Message-Id: <20231229042644.F0395C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: move pgdemote_* out of CONFIG_NUMA_BALANCING
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-move-pgdemote_-out-of-config_numa_balancing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-move-pgdemote_-out-of-config_numa_balancing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmstat: move pgdemote_* out of CONFIG_NUMA_BALANCING
Date: Fri, 29 Dec 2023 10:26:51 +0800

Demotion can work well without CONFIG_NUMA_BALANCING.  But the commit
23e9f0138963 ("mm/vmstat: move pgdemote_* to per-node stats") wrongly hid
it behind CONFIG_NUMA_BALANCING.

Fix it by moving them out of CONFIG_NUMA_BALANCING.

Link: https://lkml.kernel.org/r/20231229022651.3229174-1-lizhijian@fujitsu.com
Fixes: 23e9f0138963 ("mm/vmstat: move pgdemote_* to per-node stats")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |    5 +----
 mm/vmstat.c            |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~mm-vmstat-move-pgdemote_-out-of-config_numa_balancing
+++ a/include/linux/mmzone.h
@@ -209,11 +209,11 @@ enum node_stat_item {
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+#endif
 	/* PGDEMOTE_*: pages demoted */
 	PGDEMOTE_KSWAPD,
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
-#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/vmscan.c~mm-vmstat-move-pgdemote_-out-of-config_numa_balancing
+++ a/mm/vmscan.c
@@ -409,12 +409,10 @@ void drop_slab(void)
 
 static int reclaimer_offset(void)
 {
-#ifdef CONFIG_NUMA_BALANCING
 	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
 			PGDEMOTE_DIRECT - PGDEMOTE_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
 			PGDEMOTE_KHUGEPAGED - PGDEMOTE_KSWAPD);
-#endif
 	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
 			PGSCAN_DIRECT - PGSCAN_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
@@ -978,10 +976,9 @@ static unsigned int demote_folio_list(st
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
-#ifdef CONFIG_NUMA_BALANCING
+
 	mod_node_page_state(pgdat, PGDEMOTE_KSWAPD + reclaimer_offset(),
 			    nr_succeeded);
-#endif
 
 	return nr_succeeded;
 }
--- a/mm/vmstat.c~mm-vmstat-move-pgdemote_-out-of-config_numa_balancing
+++ a/mm/vmstat.c
@@ -1248,10 +1248,10 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
 	"pgpromote_candidate",
+#endif
 	"pgdemote_kswapd",
 	"pgdemote_direct",
 	"pgdemote_khugepaged",
-#endif
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmstat-move-pgdemote_-out-of-config_numa_balancing.patch


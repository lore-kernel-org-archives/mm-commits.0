From: akpm@linux-foundation.org
Subject: + memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch added to -mm tree
Date: Fri, 11 Mar 2011 17:23:06 -0800
Message-ID: <201103120123.p2C1N7YV007045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab1CLBXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 20:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, teravest@google.com


The patch titled
     memcg: add page_cgroup flags for dirty page tracking
has been added to the -mm tree.  Its filename is
     memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add page_cgroup flags for dirty page tracking
From: Greg Thelen <gthelen@google.com>

Add additional flags to page_cgroup to track dirty pages within a
mem_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN include/linux/page_cgroup.h~memcg-add-page_cgroup-flags-for-dirty-page-tracking include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-add-page_cgroup-flags-for-dirty-page-tracking
+++ a/include/linux/page_cgroup.h
@@ -10,6 +10,9 @@ enum {
 	/* flags for mem_cgroup and file and I/O status */
 	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
+	PCG_FILE_DIRTY, /* page is dirty */
+	PCG_FILE_WRITEBACK, /* page is under writeback */
+	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
 	/* No lock in page_cgroup */
 	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 	__NR_PCG_FLAGS,
@@ -67,6 +70,10 @@ static inline void ClearPageCgroup##unam
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
+#define TESTSETPCGFLAG(uname, lname)			\
+static inline int TestSetPageCgroup##uname(struct page_cgroup *pc)	\
+	{ return test_and_set_bit(PCG_##lname, &pc->flags);  }
+
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
 CLEARPCGFLAG(Cache, CACHE)
@@ -86,6 +93,22 @@ SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 TESTPCGFLAG(FileMapped, FILE_MAPPED)
 
+SETPCGFLAG(FileDirty, FILE_DIRTY)
+CLEARPCGFLAG(FileDirty, FILE_DIRTY)
+TESTPCGFLAG(FileDirty, FILE_DIRTY)
+TESTCLEARPCGFLAG(FileDirty, FILE_DIRTY)
+TESTSETPCGFLAG(FileDirty, FILE_DIRTY)
+
+SETPCGFLAG(FileWriteback, FILE_WRITEBACK)
+CLEARPCGFLAG(FileWriteback, FILE_WRITEBACK)
+TESTPCGFLAG(FileWriteback, FILE_WRITEBACK)
+
+SETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+CLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTCLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTSETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+
 SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch


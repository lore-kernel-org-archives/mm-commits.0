From: akpm@linux-foundation.org
Subject: - inactive_anon_is_low-move-to-vmscan.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:02 -0800
Message-ID: <200901082249.n08Mn2o9028339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759420AbZAHXAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 18:00:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     inactive_anon_is_low: move to vmscan
has been removed from the -mm tree.  Its filename was
     inactive_anon_is_low-move-to-vmscan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inactive_anon_is_low: move to vmscan
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The inactive_anon_is_low() is called only vmscan.  Then it can move to
vmscan.c

This patch doesn't have any functional change.

Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   19 -------------------
 mm/vmscan.c               |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 19 deletions(-)

diff -puN include/linux/mm_inline.h~inactive_anon_is_low-move-to-vmscan include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~inactive_anon_is_low-move-to-vmscan
+++ a/include/linux/mm_inline.h
@@ -81,23 +81,4 @@ static inline enum lru_list page_lru(str
 	return lru;
 }
 
-/**
- * inactive_anon_is_low - check if anonymous pages need to be deactivated
- * @zone: zone to check
- *
- * Returns true if the zone does not have enough inactive anon pages,
- * meaning some active anon pages need to be deactivated.
- */
-static inline int inactive_anon_is_low(struct zone *zone)
-{
-	unsigned long active, inactive;
-
-	active = zone_page_state(zone, NR_ACTIVE_ANON);
-	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
-
-	if (inactive * zone->inactive_ratio < active)
-		return 1;
-
-	return 0;
-}
 #endif
diff -puN mm/vmscan.c~inactive_anon_is_low-move-to-vmscan mm/vmscan.c
--- a/mm/vmscan.c~inactive_anon_is_low-move-to-vmscan
+++ a/mm/vmscan.c
@@ -1291,6 +1291,26 @@ static void shrink_active_list(unsigned 
 	pagevec_release(&pvec);
 }
 
+/**
+ * inactive_anon_is_low - check if anonymous pages need to be deactivated
+ * @zone: zone to check
+ *
+ * Returns true if the zone does not have enough inactive anon pages,
+ * meaning some active anon pages need to be deactivated.
+ */
+static int inactive_anon_is_low(struct zone *zone)
+{
+	unsigned long active, inactive;
+
+	active = zone_page_state(zone, NR_ACTIVE_ANON);
+	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
+
+	if (inactive * zone->inactive_ratio < active)
+		return 1;
+
+	return 0;
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


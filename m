From: akpm@linux-foundation.org
Subject: [folded] memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:57:05 -0800
Message-ID: <201003102257.o2AMv5bR008884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414Ab0CJW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg-implement-memory-thresholds-check-if-first-threshold-crossed
has been removed from the -mm tree.  Its filename was
     memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch

This patch was dropped because it was folded into memcg-implement-memory-thresholds.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-implement-memory-thresholds-check-if-first-threshold-crossed
From: "Kirill A. Shutemov" <kirill@shutemov.name>

There is a bug in memory thresholds code.  We don't check if first
threshold (array index 0) was crossed down.  This patch fixes it.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-implement-memory-thresholds-check-if-first-threshold-crossed mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-implement-memory-thresholds-check-if-first-threshold-crossed
+++ a/mm/memcontrol.c
@@ -3315,7 +3315,7 @@ static void __mem_cgroup_threshold(struc
 	 * If none of thresholds below usage is crossed, we read
 	 * only one element of the array here.
 	 */
-	for (; i > 0 && unlikely(t->entries[i].threshold > usage); i--)
+	for (; i >= 0 && unlikely(t->entries[i].threshold > usage); i--)
 		eventfd_signal(t->entries[i].eventfd, 1);
 
 	/* i = current_threshold + 1 */
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroups-fix-contents-in-cgroups-documentation.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-typos-in-memcg_testtxt.patch


From: akpm@linux-foundation.org
Subject: + memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch added to -mm tree
Date: Thu, 11 Feb 2010 13:54:48 -0800
Message-ID: <201002112154.o1BLsmJc030834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258Ab0BKVzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 16:55:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org


The patch titled
     memcg-implement-memory-thresholds-check-if-first-threshold-crossed
has been added to the -mm tree.  Its filename is
     memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch

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
@@ -3314,7 +3314,7 @@ static void __mem_cgroup_threshold(struc
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
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch


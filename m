From: akpm@linux-foundation.org
Subject: [folded-merged] mm-compact-fix-zoneindex-in-compact-fix.patch
 removed from -mm tree
Date: Fri, 20 May 2016 16:38:31 -0700
Message-ID: <573f9ff7.RbrJpJZ6cncXHzzn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbcETXic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, puck.chen@hisilicon.com, suzhuangluan@hisilicon.com, tj@kernel.org, vbabka@suse.cz, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compact-fix-zoneindex-in-compact-fix
has been removed from the -mm tree.  Its filename was
     mm-compact-fix-zoneindex-in-compact-fix.patch

This patch was dropped because it was folded into mm-compact-fix-zoneindex-in-compact.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compact-fix-zoneindex-in-compact-fix

fix kcompactd_do_work() as well, per Hugh

Cc: Chen Feng <puck.chen@hisilicon.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yiping Xu <xuyiping@hisilicon.com>
Cc: Zhuangluan Su <suzhuangluan@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compact-fix-zoneindex-in-compact-fix mm/compaction.c
--- a/mm/compaction.c~mm-compact-fix-zoneindex-in-compact-fix
+++ a/mm/compaction.c
@@ -1897,7 +1897,7 @@ static void kcompactd_do_work(pg_data_t
 							cc.classzone_idx);
 	count_vm_event(KCOMPACTD_WAKE);
 
-	for (zoneid = 0; zoneid < cc.classzone_idx; zoneid++) {
+	for (zoneid = 0; zoneid <= cc.classzone_idx; zoneid++) {
 		int status;
 
 		zone = &pgdat->node_zones[zoneid];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compact-fix-zoneindex-in-compact.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch


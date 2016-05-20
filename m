From: akpm@linux-foundation.org
Subject: [patch 054/162] mm/compaction.c: fix zoneindex in kcompactd()
Date: Fri, 20 May 2016 16:59:02 -0700
Message-ID: <573fa4c6.J9Z0R+stDsdkroxO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbcETX7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, puck.chen@hisilicon.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, stable@vger.kernel.org, suzhuangluan@hisilicon.com, tj@kernel.org, vbabka@suse.cz, xuyiping@hisilicon.com

From: Chen Feng <puck.chen@hisilicon.com>
Subject: mm/compaction.c: fix zoneindex in kcompactd()

While testing the kcompactd in my platform 3G MEM only DMA ZONE.  I found
the kcompactd never wakeup.  It seems the zoneindex has already minus 1
before.  So the traverse here should be <=.

It fixes a regression where kswapd could previously compact, but
kcompactd not.  Not a crash fix though.

[akpm@linux-foundation.org: fix kcompactd_do_work() as well, per Hugh]
Link: http://lkml.kernel.org/r/1463659121-84124-1-git-send-email-puck.chen@hisilicon.com
Fixes: accf62422b3a ("mm, kswapd: replace kswapd compaction with waking up kcompactd")
Signed-off-by: Chen Feng <puck.chen@hisilicon.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhuangluan Su <suzhuangluan@hisilicon.com>
Cc: Yiping Xu <xuyiping@hisilicon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compact-fix-zoneindex-in-compact mm/compaction.c
--- a/mm/compaction.c~mm-compact-fix-zoneindex-in-compact
+++ a/mm/compaction.c
@@ -1862,7 +1862,7 @@ static bool kcompactd_node_suitable(pg_d
 	struct zone *zone;
 	enum zone_type classzone_idx = pgdat->kcompactd_classzone_idx;
 
-	for (zoneid = 0; zoneid < classzone_idx; zoneid++) {
+	for (zoneid = 0; zoneid <= classzone_idx; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
 
 		if (!populated_zone(zone))
@@ -1897,7 +1897,7 @@ static void kcompactd_do_work(pg_data_t
 							cc.classzone_idx);
 	count_vm_event(KCOMPACTD_WAKE);
 
-	for (zoneid = 0; zoneid < cc.classzone_idx; zoneid++) {
+	for (zoneid = 0; zoneid <= cc.classzone_idx; zoneid++) {
 		int status;
 
 		zone = &pgdat->node_zones[zoneid];
_

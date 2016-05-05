From: akpm@linux-foundation.org
Subject: [patch 12/14] mm: fix kcompactd hang during memory offlining
Date: Thu, 05 May 2016 16:22:32 -0700
Message-ID: <572bd5b8.IuLRVfaszriYSN6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbcEEXWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 19:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, aarcange@redhat.com, arbab@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: fix kcompactd hang during memory offlining

Assume memory47 is the last online block left in node1. This will hang:

# echo offline > /sys/devices/system/node/node1/memory47/state

After a couple of minutes, the following pops up in dmesg:

INFO: task bash:957 blocked for more than 120 seconds.
       Not tainted 4.6.0-rc6+ #6
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bash            D ffff8800b7adbaf8     0   957    951 0x00000000
  ffff8800b7adbaf8 ffff880034d5b880 ffff8800b698d4c0 ffff8800b7adc000
  7fffffffffffffff ffff88003381ff10 ffff8800b698d4c0 0000000000180000
  ffff8800b7adbb10 ffffffff817be0b5 ffff88003381ff08 ffff8800b7adbbc0
Call Trace:
  [<ffffffff817be0b5>] schedule+0x35/0x80
  [<ffffffff817c100c>] schedule_timeout+0x1ac/0x270
  [<ffffffff810d9750>] ? check_preempt_wakeup+0x100/0x220
  [<ffffffff810ce0a0>] ? check_preempt_curr+0x80/0x90
  [<ffffffff817bf501>] wait_for_completion+0xe1/0x120
  [<ffffffff810cefc0>] ? wake_up_q+0x70/0x70
  [<ffffffff810c42ff>] kthread_stop+0x4f/0x110
  [<ffffffff811e1046>] kcompactd_stop+0x26/0x40
  [<ffffffff817b7a16>] __offline_pages.constprop.28+0x7e6/0x840
  [<ffffffff8121ee61>] offline_pages+0x11/0x20
  [<ffffffff8151a073>] memory_block_action+0x73/0x1d0
  [<ffffffff8151a217>] memory_subsys_offline+0x47/0x60
  [<ffffffff81502dc6>] device_offline+0x86/0xb0
  [<ffffffff8151a8fa>] store_mem_state+0xda/0xf0
  [<ffffffff814ffea8>] dev_attr_store+0x18/0x30
  [<ffffffff812c1097>] sysfs_kf_write+0x37/0x40
  [<ffffffff812c062d>] kernfs_fop_write+0x11d/0x170
  [<ffffffff8123e797>] __vfs_write+0x37/0x120
  [<ffffffff8134d1ad>] ? security_file_permission+0x3d/0xc0
  [<ffffffff810eed32>] ? percpu_down_read+0x12/0x50
  [<ffffffff8123f969>] vfs_write+0xa9/0x1a0
  [<ffffffff8134d543>] ? security_file_fcntl+0x43/0x60
  [<ffffffff81240dc5>] SyS_write+0x55/0xc0
  [<ffffffff817c21b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4

kcompactd is waiting for kcompactd_max_order > 0 when it's woken up to
actually exit.  Check kthread_should_stop() to break out of the wait.

Fixes: 698b1b306 ("mm, compaction: introduce kcompactd").
Reported-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Tested-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~kcompactd-hang-during-memory-offlining mm/compaction.c
--- a/mm/compaction.c~kcompactd-hang-during-memory-offlining
+++ a/mm/compaction.c
@@ -1733,7 +1733,7 @@ void compaction_unregister_node(struct n
 
 static inline bool kcompactd_work_requested(pg_data_t *pgdat)
 {
-	return pgdat->kcompactd_max_order > 0;
+	return pgdat->kcompactd_max_order > 0 || kthread_should_stop();
 }
 
 static bool kcompactd_node_suitable(pg_data_t *pgdat)
@@ -1797,6 +1797,8 @@ static void kcompactd_do_work(pg_data_t
 		INIT_LIST_HEAD(&cc.freepages);
 		INIT_LIST_HEAD(&cc.migratepages);
 
+		if (kthread_should_stop())
+			return;
 		status = compact_zone(zone, &cc);
 
 		if (zone_watermark_ok(zone, cc.order, low_wmark_pages(zone),
_

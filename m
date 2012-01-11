From: akpm@linux-foundation.org
Subject: [merged] vmscan-add-task-name-to-warn_scan_unevictable-messages.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:14 -0800
Message-ID: <20120111212715.22D8520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:36671 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977Ab2AKV1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:17 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt14so42866wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: add task name to warn_scan_unevictable() messages
has been removed from the -mm tree.  Its filename was
     vmscan-add-task-name-to-warn_scan_unevictable-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: vmscan: add task name to warn_scan_unevictable() messages

If we need to know a usecase, caller program name is critical important. 
Show it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
David Rientjes <rientjes@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-add-task-name-to-warn_scan_unevictable-messages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-add-task-name-to-warn_scan_unevictable-messages
+++ a/mm/vmscan.c
@@ -3436,9 +3436,10 @@ void scan_mapping_unevictable_pages(stru
 static void warn_scan_unevictable_pages(void)
 {
 	printk_once(KERN_WARNING
-		    "The scan_unevictable_pages sysctl/node-interface has been "
+		    "%s: The scan_unevictable_pages sysctl/node-interface has been "
 		    "disabled for lack of a legitimate use case.  If you have "
-		    "one, please send an email to linux-mm@kvack.org.\n");
+		    "one, please send an email to linux-mm@kvack.org.\n",
+		    current->comm);
 }
 
 /*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch


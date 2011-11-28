From: akpm@linux-foundation.org
Subject: + vmscan-add-task-name-to-warn_scan_unevictable-messages.patch added to -mm tree
Date: Mon, 28 Nov 2011 13:44:44 -0800
Message-ID: <201111282144.pASLiitw017288@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63484 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1K1Vos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 16:44:48 -0500
Received: by faaq16 with SMTP id q16so5768faa.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 13:44:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     Subject: vmscan: add task name to warn_scan_unevictable() messages
has been added to the -mm tree.  Its filename is
     vmscan-add-task-name-to-warn_scan_unevictable-messages.patch

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
Subject: Subject: vmscan: add task name to warn_scan_unevictable() messages

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch


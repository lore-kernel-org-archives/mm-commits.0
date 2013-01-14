From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:25 -0800
Message-ID: <20130114203825.C3422820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36630 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab3ANUi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:27 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so537222ggn.3
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: r64343@freescale.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix echo 1 > compact_memory return error issue
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Liu <r64343@freescale.com>
Subject: mm: compaction: fix echo 1 > compact_memory return error issue

when run the folloing command under shell, it will return error
sh/$ echo 1 > /proc/sys/vm/compact_memory
sh/$ sh: write error: Bad address

After strace, I found the following log:
...
write(1, "1\n", 2)               = 3
write(1, "", 4294967295)         = -1 EFAULT (Bad address)
write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
) = 31

This tells system return 3(COMPACT_COMPLETE) after write data to compact_memory.

The fix is to make the system just return 0 instead 3(COMPACT_COMPLETE) from
sysctl_compaction_handler after compaction_nodes finished.

Signed-off-by: Jason Liu <r64343@freescale.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-echo-1-compact_memory-return-error-issue mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-echo-1-compact_memory-return-error-issue
+++ a/mm/compaction.c
@@ -1210,7 +1210,7 @@ static int compact_node(int nid)
 }
 
 /* Compact all nodes in the system */
-static int compact_nodes(void)
+static void compact_nodes(void)
 {
 	int nid;
 
@@ -1219,8 +1219,6 @@ static int compact_nodes(void)
 
 	for_each_online_node(nid)
 		compact_node(nid);

From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:35:27 -0800
Message-ID: <20130107213528.4B606100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38318 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3AGVf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:35:29 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so2135781vba.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:35:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: r64343@freescale.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix echo 1 > compact_memory return error issue
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

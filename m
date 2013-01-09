From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch added to -mm tree
Date: Tue, 08 Jan 2013 16:15:39 -0800
Message-ID: <20130109001539.A43AA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57541 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3AIAPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 19:15:40 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so155887vcq.4
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 16:15:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com


The patch titled
     Subject: mm: memory_hotplug: no need to check res twice in add_memory
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: memory_hotplug: no need to check res twice in add_memory

Remove one redundant check of res.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory
+++ a/mm/memory_hotplug.c
@@ -901,8 +901,7 @@ error:
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
-	if (res)
-		release_memory_resource(res);
+	release_memory_resource(res);
 
 out:
 	unlock_memory_hotplug();
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch


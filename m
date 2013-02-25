From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:32 -0800
Message-ID: <20130225204932.99C4F5A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44285 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab3BYUtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:33 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so346032vcd.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: no need to check res twice in add_memory
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch
posix-timer-dont-call-idr_find-w-out-of-range-id.patch
idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-redo-kvm.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch


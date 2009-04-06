From: akpm@linux-foundation.org
Subject: [merged] debug-cgroup-remove-unneeded-cgroup_lock.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:21 -0700
Message-ID: <200904061934.n36JYLEi011574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757216AbZDFTgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     debug cgroup: remove unneeded cgroup_lock
has been removed from the -mm tree.  Its filename was
     debug-cgroup-remove-unneeded-cgroup_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: debug cgroup: remove unneeded cgroup_lock
From: Li Zefan <lizf@cn.fujitsu.com>

Since we are in cgroup write handler, so the cgrp is valid, so we don't
have to hold cgroup_mutex when calling cgroup_task_count().  One similar
example is in cgroup_tasks_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_debug.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/cgroup_debug.c~debug-cgroup-remove-unneeded-cgroup_lock kernel/cgroup_debug.c
--- a/kernel/cgroup_debug.c~debug-cgroup-remove-unneeded-cgroup_lock
+++ a/kernel/cgroup_debug.c
@@ -40,9 +40,7 @@ static u64 taskcount_read(struct cgroup 
 {
 	u64 count;
 
-	cgroup_lock();
 	count = cgroup_task_count(cont);
-	cgroup_unlock();
 	return count;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch


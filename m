From: akpm@linux-foundation.org
Subject: - memcgroup-remove-a-useless-vm_bug_on.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:46:06 -0800
Message-ID: <200802250046.m1P0k6DU006315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528AbYBYAsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcgroup: remove a useless VM_BUG_ON()
has been removed from the -mm tree.  Its filename was
     memcgroup-remove-a-useless-vm_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: remove a useless VM_BUG_ON()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove this VM_BUG_ON(), as Balbir stated:

We used to have a for loop with !list_empty() as a termination condition
and VM_BUG_ON(!pc) is a spill over.  With the new loop, VM_BUG_ON(!pc) does
not make sense.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcgroup-remove-a-useless-vm_bug_on mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-remove-a-useless-vm_bug_on
+++ a/mm/memcontrol.c
@@ -534,7 +534,6 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (scan >= nr_to_scan)
 			break;
 		page = pc->page;
-		VM_BUG_ON(!pc);
 
 		if (unlikely(!PageLRU(page)))
 			continue;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

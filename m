From: akpm@linux-foundation.org
Subject: + memcgroup-remove-a-useless-vm_bug_on.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:50 -0800
Message-ID: <200802230733.m1N7XdNo018241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365AbYBWHyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcgroup: remove a useless VM_BUG_ON()
has been added to the -mm tree.  Its filename is
     memcgroup-remove-a-useless-vm_bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cgroup-fix-and-update-documentation.patch
cgroup-fix-comments.patch
cgroup-clean-up-cgrouph.patch
cgroup-fix-memory-leak-in-cgroup_get_sb.patch
cgroup-fix-subsys-bitops.patch
cgroup-remove-duplicate-code-in-find_css_set.patch
cgroup-remove-dead-code-in-cgroup_get_rootdir.patch
memcgroup-fix-and-update-documentation.patch
memcgroup-remove-a-useless-vm_bug_on.patch
memcgroup-return-negative-error-code-in-mem_cgroup_create.patch

From: akpm@linux-foundation.org
Subject: - memrlimit-improve-error-handling-update.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:20:03 -0700
Message-ID: <200810210020.m9L0K3jZ019818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbYJUAUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valin


The patch titled
     memrlimit-improve-error-handling update
has been removed from the -mm tree.  Its filename was
     memrlimit-improve-error-handling-update.patch

This patch was dropped because it was folded into memrlimit-add-memrlimit-controller-accounting-and-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit-improve-error-handling update
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This is a newer version of the patch, could you please drop the older one
and pick this. Aplogies for the inconvenience.

Changelog v2->v1
1. Address some of Hugh's comments. Reuse error (don't add new ret variable)

TODO: Merge ret & ~PAGE_MASK and vm_expanded.

memrlimit cgroup does not handle error cases after may_expand_vm(). This
BUG was reported by Kamezawa, with the test case below to reproduce it

[root@iridium kamezawa]# cat /opt/cgroup/test/memrlimit.usage_in_bytes
71921664
[root@iridium kamezawa]# ulimit -s 3
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ls
Killed
[root@iridium kamezawa]# ulimit -s unlimited
[root@iridium kamezawa]# cat /opt/cgroup/test/memrlimit.usage_in_bytes
72368128
[root@iridium kamezawa]#

This patch adds better handling support to fix the reported problem.

Reported-by: [kamezawa.hiroyu@jp.fujitsu.com]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c   |    6 +++---
 mm/mremap.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~memrlimit-improve-error-handling-update mm/mmap.c
--- a/mm/mmap.c~memrlimit-improve-error-handling-update
+++ a/mm/mmap.c
@@ -1996,7 +1996,6 @@ unsigned long do_brk(unsigned long addr,
 	struct rb_node ** rb_link, * rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
-	int ret = -ENOMEM;
 
 	len = PAGE_ALIGN(len);
 	if (!len)
@@ -2048,9 +2047,10 @@ unsigned long do_brk(unsigned long addr,
 		goto munmap_back;
 	}
 
+	error = -ENOMEM;
 	/* Check against address space limits *after* clearing old maps... */
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return ret;
+		return error;
 
 	if (mm->map_count > sysctl_max_map_count)
 		goto undo_charge;
@@ -2089,7 +2089,7 @@ out:
 	return addr;
 undo_charge:
 	memrlimit_cgroup_uncharge_as(mm, len >> PAGE_SHIFT);
-	return ret;
+	return error;
 }
 
 EXPORT_SYMBOL(do_brk);
diff -puN mm/mremap.c~memrlimit-improve-error-handling-update mm/mremap.c
--- a/mm/mremap.c~memrlimit-improve-error-handling-update
+++ a/mm/mremap.c
@@ -427,7 +427,7 @@ out:
 	if (ret & ~PAGE_MASK)
 		vm_unacct_memory(charged);
 out_nc:
-	if (vm_expanded)
+	if ((ret & ~PAGE_MASK) && vm_expanded)
 		memrlimit_cgroup_uncharge_as(mm,
 				(new_len - old_len) >> PAGE_SHIFT);
 	return ret;
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch


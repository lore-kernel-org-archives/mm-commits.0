From: akpm@linux-foundation.org
Subject: + memcg-clean-up-checking-of-the-disabled-flag.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:50:25 -0700
Message-ID: <200806082050.m58KoPeO019890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562AbYFHUvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     memcg: clean up checking of  the disabled flag
has been added to the -mm tree.  Its filename is
     memcg-clean-up-checking-of-the-disabled-flag.patch

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
Subject: memcg: clean up checking of  the disabled flag
From: Li Zefan <lizf@cn.fujitsu.com>

Those checks are unnecessary, because when the subsystem is disabled
it can't be mounted, so those functions won't get called.

The check is needed in functions which will be called in other places
except cgroup.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-checking-of-the-disabled-flag mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-checking-of-the-disabled-flag
+++ a/mm/memcontrol.c
@@ -845,9 +845,6 @@ static int mem_cgroup_force_empty(struct
 	int ret = -EBUSY;
 	int node, zid;
 
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
@@ -1105,8 +1102,6 @@ static void mem_cgroup_destroy(struct cg
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	if (mem_cgroup_subsys.disabled)
-		return 0;
 	return cgroup_add_files(cont, ss, mem_cgroup_files,
 					ARRAY_SIZE(mem_cgroup_files));
 }
@@ -1119,9 +1114,6 @@ static void mem_cgroup_move_task(struct 
 	struct mm_struct *mm;
 	struct mem_cgroup *mem, *old_mem;
 
-	if (mem_cgroup_subsys.disabled)
-		return;
-
 	mm = get_task_mm(p);
 	if (mm == NULL)
 		return;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
git-leds.patch
call_usermodehelper-increase-reliability.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch


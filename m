From: akpm@linux-foundation.org
Subject: + devcgroup-use-list_for_each_entry_rcu.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:41:47 -0800
Message-ID: <200811212341.mALNfllY031611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbYKUXmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:42:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     devcgroup: use list_for_each_entry_rcu()
has been added to the -mm tree.  Its filename is
     devcgroup-use-list_for_each_entry_rcu.patch

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
Subject: devcgroup: use list_for_each_entry_rcu()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

We should use list_for_each_entry_rcu in RCU read site.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/device_cgroup.c~devcgroup-use-list_for_each_entry_rcu security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-use-list_for_each_entry_rcu
+++ a/security/device_cgroup.c
@@ -517,7 +517,7 @@ int devcgroup_inode_mknod(int mode, dev_
 
 	dev_cgroup = task_devcgroup(current);
 
-	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
+	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(mode))
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch


From: akpm@linux-foundation.org
Subject: - devcgroup-use-list_for_each_entry_rcu.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:53 -0800
Message-ID: <200901082247.n08MlrqP027288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763375AbZAHWvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     devcgroup: use list_for_each_entry_rcu()
has been removed from the -mm tree.  Its filename was
     devcgroup-use-list_for_each_entry_rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


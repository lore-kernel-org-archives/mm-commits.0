From: akpm@linux-foundation.org
Subject: [merged] devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:20 -0700
Message-ID: <200906182245.n5IMjKjD004451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758098AbZFRW5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: skip superfluous checks when found the DEV_ALL elem
has been removed from the -mm tree.  Its filename was
     devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: skip superfluous checks when found the DEV_ALL elem
From: Li Zefan <lizf@cn.fujitsu.com>

While walking through the whitelist, if the DEV_ALL item is found, no more
check is needed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem
+++ a/security/device_cgroup.c
@@ -490,7 +490,7 @@ int devcgroup_inode_permission(struct in
 
 	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
-			goto acc_check;
+			goto found;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
 			continue;
 		if ((wh->type & DEV_CHAR) && !S_ISCHR(inode->i_mode))
@@ -499,11 +499,12 @@ int devcgroup_inode_permission(struct in
 			continue;
 		if (wh->minor != ~0 && wh->minor != iminor(inode))
 			continue;
-acc_check:
+
 		if ((mask & MAY_WRITE) && !(wh->access & ACC_WRITE))
 			continue;
 		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
 			continue;
+found:
 		rcu_read_unlock();
 		return 0;
 	}
@@ -527,7 +528,7 @@ int devcgroup_inode_mknod(int mode, dev_
 
 	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
-			goto acc_check;
+			goto found;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(mode))
 			continue;
 		if ((wh->type & DEV_CHAR) && !S_ISCHR(mode))
@@ -536,9 +537,10 @@ int devcgroup_inode_mknod(int mode, dev_
 			continue;
 		if (wh->minor != ~0 && wh->minor != MINOR(dev))
 			continue;
-acc_check:
+
 		if (!(wh->access & ACC_MKNOD))
 			continue;
+found:
 		rcu_read_unlock();
 		return 0;
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch


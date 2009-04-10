From: akpm@linux-foundation.org
Subject: + devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch added to -mm tree
Date: Thu, 09 Apr 2009 17:06:17 -0700
Message-ID: <200904100006.n3A06Hid005609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZDJAH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 20:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, serue@us.ibm.com


The patch titled
     devcgroup: skip superfluous checks when found the DEV_ALL elem
has been added to the -mm tree.  Its filename is
     devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

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

documentation-sysctl-nettxt-fix-a-typo.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch


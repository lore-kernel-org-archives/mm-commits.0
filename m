From: akpm@linux-foundation.org
Subject: [merged] devcgroup-avoid-using-cgroup_lock.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:23 -0700
Message-ID: <200904061934.n36JYNjc011577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbZDFTig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:38:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: avoid using cgroup_lock
has been removed from the -mm tree.  Its filename was
     devcgroup-avoid-using-cgroup_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: avoid using cgroup_lock
From: Li Zefan <lizf@cn.fujitsu.com>

There is nothing special that has to be protected by cgroup_lock,
so introduce devcgroup_mtuex for it's own use.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-avoid-using-cgroup_lock security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-avoid-using-cgroup_lock
+++ a/security/device_cgroup.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
+#include <linux/mutex.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2
@@ -21,9 +22,11 @@
 #define DEV_CHAR  2
 #define DEV_ALL   4  /* this represents all devices */
 
+static DEFINE_MUTEX(devcgroup_mutex);
+
 /*
  * whitelist locking rules:
- * hold cgroup_lock() for update/read.
+ * hold devcgroup_mutex for update/read.
  * hold rcu_read_lock() for read.
  */
 
@@ -67,7 +70,7 @@ static int devcgroup_can_attach(struct c
 }
 
 /*
- * called under cgroup_lock()
+ * called under devcgroup_mutex
  */
 static int dev_whitelist_copy(struct list_head *dest, struct list_head *orig)
 {
@@ -92,7 +95,7 @@ free_and_exit:
 
 /* Stupid prototype - don't bother combining existing entries */
 /*
- * called under cgroup_lock()
+ * called under devcgroup_mutex
  */
 static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
@@ -130,7 +133,7 @@ static void whitelist_item_free(struct r
 }
 
 /*
- * called under cgroup_lock()
+ * called under devcgroup_mutex
  */
 static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
@@ -185,8 +188,10 @@ static struct cgroup_subsys_state *devcg
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
+		mutex_lock(&devcgroup_mutex);
 		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
 				&parent_dev_cgroup->whitelist);
+		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
 			return ERR_PTR(ret);
@@ -273,7 +278,7 @@ static int devcgroup_seq_read(struct cgr
  * does the access granted to dev_cgroup c contain the access
  * requested in whitelist item refwh.
  * return 1 if yes, 0 if no.
- * call with c->lock held
+ * call with devcgroup_mutex held
  */
 static int may_access_whitelist(struct dev_cgroup *c,
 				       struct dev_whitelist_item *refwh)
@@ -426,11 +431,11 @@ static int devcgroup_access_write(struct
 				  const char *buffer)
 {
 	int retval;
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
+
+	mutex_lock(&devcgroup_mutex);
 	retval = devcgroup_update_access(cgroup_to_devcgroup(cgrp),
 					 cft->private, buffer);
-	cgroup_unlock();
+	mutex_unlock(&devcgroup_mutex);
 	return retval;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch


From: akpm@linux-foundation.org
Subject: - improve-cgroup-printks.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:42 -0800
Message-ID: <200711152108.lAFL8gRL015381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761954AbXKOVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: diegocg@gmail.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     Improve cgroup printks
has been removed from the -mm tree.  Its filename was
     improve-cgroup-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Improve cgroup printks
From: Diego Calleja <diegocg@gmail.com>

When I boot with the 'quiet' parameter, I see on the screen:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[   39.036026] Initializing cgroup subsys cpuacct
[   39.036080] Initializing cgroup subsys debug
[   39.036118] Initializing cgroup subsys ns

This patch lowers the priority of those messages, adds a "cgroup: " prefix
to another couple of printks and kills the useless reference to the source
file.

Signed-off-by: Diego Calleja <diegocg@gmail.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup.c~improve-cgroup-printks kernel/cgroup.c
--- a/kernel/cgroup.c~improve-cgroup-printks
+++ a/kernel/cgroup.c
@@ -1,6 +1,4 @@
 /*
- *  kernel/cgroup.c
- *
  *  Generic process-grouping system.
  *
  *  Based originally on the cpuset system, extracted by Paul Menage
@@ -2200,7 +2198,8 @@ static void cgroup_init_subsys(struct cg
 {
 	struct cgroup_subsys_state *css;
 	struct list_head *l;
-	printk(KERN_ERR "Initializing cgroup subsys %s\n", ss->name);
+
+	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
 	/* Create the top cgroup state for this subsystem */
 	ss->root = &rootnode;
@@ -2273,7 +2272,7 @@ int __init cgroup_init_early(void)
 		BUG_ON(!ss->create);
 		BUG_ON(!ss->destroy);
 		if (ss->subsys_id != i) {
-			printk(KERN_ERR "Subsys %s id == %d\n",
+			printk(KERN_ERR "cgroup: Subsys %s id == %d\n",
 			       ss->name, ss->subsys_id);
 			BUG();
 		}
@@ -2605,7 +2604,7 @@ int cgroup_clone(struct task_struct *tsk
 	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
 	if (IS_ERR(dentry)) {
 		printk(KERN_INFO
-		       "Couldn't allocate dentry for %s: %ld\n", nodename,
+		       "cgroup: Couldn't allocate dentry for %s: %ld\n", nodename,
 		       PTR_ERR(dentry));
 		ret = PTR_ERR(dentry);
 		goto out_release;
_

Patches currently in -mm which might be from diegocg@gmail.com are

origin.patch

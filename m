From: akpm@linux-foundation.org
Subject: - cgroups-suppress-bogus-warning-messages.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:20 -0800
Message-ID: <200812291918.mBTJIKTW030705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYL2TTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sharyath@in.ibm.com, adobriyan@gmail.com, menage@google.com, serge@hallyn.com, sharyathi@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: suppress bogus warning messages
has been removed from the -mm tree.  Its filename was
     cgroups-suppress-bogus-warning-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: suppress bogus warning messages
From: Sharyathi Nagesh <sharyath@in.ibm.com>

Remove spurious warning messages that are thrown onto the console during
cgroup operations.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Sharyathi Nagesh <sharyathi@in.ibm.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/cgroup.c~cgroups-suppress-bogus-warning-messages kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-suppress-bogus-warning-messages
+++ a/kernel/cgroup.c
@@ -2934,9 +2934,6 @@ int cgroup_clone(struct task_struct *tsk
  again:
 	root = subsys->root;
 	if (root == &rootnode) {
-		printk(KERN_INFO
-		       "Not cloning cgroup for unused subsystem %s\n",
-		       subsys->name);
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
_

Patches currently in -mm which might be from sharyath@in.ibm.com are



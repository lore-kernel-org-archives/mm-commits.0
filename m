From: akpm@linux-foundation.org
Subject: - ns_cgroup-remove-unused-spinlock.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:24 -0800
Message-ID: <200901082247.n08MlOS0026837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763501AbZAHWsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     ns_cgroup: remove unused spinlock
has been removed from the -mm tree.  Its filename was
     ns_cgroup-remove-unused-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ns_cgroup: remove unused spinlock
From: Li Zefan <lizf@cn.fujitsu.com>

I happened to find the spinlock in struct ns_cgroup is never used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ns_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/ns_cgroup.c~ns_cgroup-remove-unused-spinlock kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~ns_cgroup-remove-unused-spinlock
+++ a/kernel/ns_cgroup.c
@@ -13,7 +13,6 @@
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
-	spinlock_t lock;
 };
 
 struct cgroup_subsys ns_subsys;
@@ -84,7 +83,6 @@ static struct cgroup_subsys_state *ns_cr
 	ns_cgroup = kzalloc(sizeof(*ns_cgroup), GFP_KERNEL);
 	if (!ns_cgroup)
 		return ERR_PTR(-ENOMEM);
-	spin_lock_init(&ns_cgroup->lock);
 	return &ns_cgroup->css;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch


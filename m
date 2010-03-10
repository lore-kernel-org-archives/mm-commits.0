From: akpm@linux-foundation.org
Subject: [folded] cgroups-subsystem-module-loading-interface-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:52:05 -0800
Message-ID: <201003102252.o2AMq5vZ008661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0CJWwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: modular subsystems support for use_id
has been removed from the -mm tree.  Its filename was
     cgroups-subsystem-module-loading-interface-fix.patch

This patch was dropped because it was folded into cgroups-subsystem-module-loading-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: modular subsystems support for use_id
From: Ben Blum <bblum@andrew.cmu.edu>

This patch adds support for subsys.use_id in module-loadable subsystems.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup.c~cgroups-subsystem-module-loading-interface-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-subsystem-module-loading-interface-fix
+++ a/kernel/cgroup.c
@@ -255,7 +255,8 @@ struct cg_cgroup_link {
 static struct css_set init_css_set;
 static struct cg_cgroup_link init_css_set_link;
 
-static int cgroup_subsys_init_idr(struct cgroup_subsys *ss);
+static int cgroup_init_idr(struct cgroup_subsys *ss,
+			   struct cgroup_subsys_state *css);
 
 /* css_set_lock protects the list of css_set objects, and the
  * chain of tasks off each css_set.  Nests outside task->alloc_lock
@@ -3376,6 +3377,18 @@ int __init_or_module cgroup_load_subsys(
 
 	/* our new subsystem will be attached to the dummy hierarchy. */
 	init_cgroup_css(css, ss, dummytop);
+	/* init_idr must be after init_cgroup_css because it sets css->id. */
+	if (ss->use_id) {
+		int ret = cgroup_init_idr(ss, css);
+		if (ret) {
+			dummytop->subsys[ss->subsys_id] = NULL;
+			ss->destroy(ss, dummytop);
+			subsys[i] = NULL;
+			mutex_unlock(&cgroup_mutex);
+			return ret;
+		}
+	}
+
 	/*
 	 * Now we need to entangle the css into the existing css_sets. unlike
 	 * in cgroup_init_subsys, there are now multiple css_sets, so each one
@@ -3492,7 +3505,7 @@ int __init cgroup_init(void)
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
 		if (ss->use_id)
-			cgroup_subsys_init_idr(ss);
+			cgroup_init_idr(ss, init_css_set.subsys[ss->subsys_id]);
 	}
 
 	/* Add init_css_set to the hash table */
@@ -4161,15 +4174,14 @@ err_out:
 
 }
 
-static int __init cgroup_subsys_init_idr(struct cgroup_subsys *ss)
+static int __init_or_module cgroup_init_idr(struct cgroup_subsys *ss,
+					    struct cgroup_subsys_state *rootcss)
 {
 	struct css_id *newid;
-	struct cgroup_subsys_state *rootcss;
 
 	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
-	rootcss = init_css_set.subsys[ss->subsys_id];
 	newid = get_new_cssid(ss, 0);
 	if (IS_ERR(newid))
 		return PTR_ERR(newid);
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-subsystem-module-unloading-fix.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch


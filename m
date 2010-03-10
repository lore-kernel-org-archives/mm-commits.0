From: akpm@linux-foundation.org
Subject: [folded] cgroups-subsystem-module-unloading-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:52:33 -0800
Message-ID: <201003102252.o2AMqX4e008672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0CJWwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:52:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cgroups-subsystem-module-unloading-fix
has been removed from the -mm tree.  Its filename was
     cgroups-subsystem-module-unloading-fix.patch

This patch was dropped because it was folded into cgroups-subsystem-module-unloading.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-subsystem-module-unloading-fix
From: Ben Blum <bblum@andrew.cmu.edu>

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cgroup.c~cgroups-subsystem-module-unloading-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-subsystem-module-unloading-fix
+++ a/kernel/cgroup.c
@@ -977,7 +977,9 @@ static int rebind_subsystems(struct cgro
 			 * drop the extra reference.
 			 */
 			module_put(ss->module);
+#ifdef CONFIG_MODULE_UNLOAD
 			BUG_ON(ss->module && !module_refcount(ss->module));
+#endif
 		} else {
 			/* Subsystem state shouldn't exist */
 			BUG_ON(cgrp->subsys[i]);
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-unloading.patch
cgroups-subsystem-module-unloading-fix.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch


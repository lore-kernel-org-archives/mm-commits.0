From: akpm@linux-foundation.org
Subject: + cgroups-subsystem-module-unloading-fix.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:45:11 -0800
Message-ID: <201001142345.o0ENjBBc006897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712Ab0ANXpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:45:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@andrew.cmu.edu, randy.dunlap@oracle.com


The patch titled
     cgroups-subsystem-module-unloading-fix
has been added to the -mm tree.  Its filename is
     cgroups-subsystem-module-unloading-fix.patch

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
@@ -962,7 +962,9 @@ static int rebind_subsystems(struct cgro
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
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-subsystem-module-unloading-fix.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch


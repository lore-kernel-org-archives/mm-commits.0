From: akpm@linux-foundation.org
Subject: [merged] pnpbios-fix-warning-if-no-hotplug.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:37 -0700
Message-ID: <200904061933.n36JXbXB011196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbZDFTfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: erik@kryo.se, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnpbios: fix warning if CONFIG_HOTPLUG=n
has been removed from the -mm tree.  Its filename was
     pnpbios-fix-warning-if-no-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpbios: fix warning if CONFIG_HOTPLUG=n
From: Erik Ekman <erik@kryo.se>

drivers/pnp/pnpbios/core.c: In function 'pnpbios_thread_init':
drivers/pnp/pnpbios/core.c:578: warning: unused variable 'task'

Signed-off-by: Erik Ekman <erik@kryo.se>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/pnp/pnpbios/core.c~pnpbios-fix-warning-if-no-hotplug drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnpbios-fix-warning-if-no-hotplug
+++ a/drivers/pnp/pnpbios/core.c
@@ -575,8 +575,6 @@ fs_initcall(pnpbios_init);
 
 static int __init pnpbios_thread_init(void)
 {
-	struct task_struct *task;
-
 #if defined(CONFIG_PPC)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return 0;
@@ -584,10 +582,13 @@ static int __init pnpbios_thread_init(vo
 	if (pnpbios_disabled)
 		return 0;
 #ifdef CONFIG_HOTPLUG
-	init_completion(&unload_sem);
-	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
-	if (!IS_ERR(task))
-		unloading = 0;
+	{
+		struct task_struct *task;
+		init_completion(&unload_sem);
+		task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
+		if (!IS_ERR(task))
+			unloading = 0;
+	}
 #endif
 	return 0;
 }
_

Patches currently in -mm which might be from erik@kryo.se are

origin.patch


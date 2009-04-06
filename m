From: akpm@linux-foundation.org
Subject: [merged] pnpbios-propagate-kthread_run-error.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:40 -0700
Message-ID: <200904061933.n36JXeHh011206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbZDFTfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: erik@kryo.se, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnpbios: propagate kthread_run() error
has been removed from the -mm tree.  Its filename was
     pnpbios-propagate-kthread_run-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpbios: propagate kthread_run() error
From: Erik Ekman <erik@kryo.se>

- Error code from kthread_run() is now returned in pnpbios_thread_init()

- Remove variable which always was 0.

Signed-off-by: Erik Ekman <erik@kryo.se>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/pnpbios/core.c~pnpbios-propagate-kthread_run-error drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnpbios-propagate-kthread_run-error
+++ a/drivers/pnp/pnpbios/core.c
@@ -94,7 +94,6 @@ struct pnp_dev_node_info node_info;
 
 #ifdef CONFIG_HOTPLUG
 
-static int unloading = 0;
 static struct completion unload_sem;
 
 /*
@@ -158,7 +157,7 @@ static int pnp_dock_thread(void *unused)
 	int docked = -1, d = 0;
 
 	set_freezable();
-	while (!unloading) {
+	while (1) {
 		int status;
 
 		/*
@@ -586,8 +585,8 @@ static int __init pnpbios_thread_init(vo
 		struct task_struct *task;
 		init_completion(&unload_sem);
 		task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
-		if (!IS_ERR(task))
-			unloading = 0;
+		if (IS_ERR(task))
+			return PTR_ERR(task);
 	}
 #endif
 	return 0;
_

Patches currently in -mm which might be from erik@kryo.se are

origin.patch


From: akpm@linux-foundation.org
Subject: + pnpbios-propagate-kthread_run-error.patch added to -mm tree
Date: Wed, 14 Jan 2009 15:03:11 -0800
Message-ID: <200901142303.n0EN3BwO001008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbZANXDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 18:03:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: erik@kryo.se, bjorn.helgaas@hp.com


The patch titled
     pnpbios: propagate kthread_run() error
has been added to the -mm tree.  Its filename is
     pnpbios-propagate-kthread_run-error.patch

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

linux-next.patch
pnpbios-fix-warning-if-no-hotplug.patch
pnpbios-propagate-kthread_run-error.patch


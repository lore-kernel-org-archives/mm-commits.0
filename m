From: akpm@linux-foundation.org
Subject: + pnpbios-fix-warning-if-no-hotplug.patch added to -mm tree
Date: Wed, 14 Jan 2009 13:13:29 -0800
Message-ID: <200901142113.n0ELDTdZ003251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756367AbZANVNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 16:13:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: erik@kryo.se, bjorn.helgaas@hp.com


The patch titled
     pnpbios: fix warning if CONFIG_HOTPLUG=n
has been added to the -mm tree.  Its filename is
     pnpbios-fix-warning-if-no-hotplug.patch

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

linux-next.patch
pnpbios-fix-warning-if-no-hotplug.patch


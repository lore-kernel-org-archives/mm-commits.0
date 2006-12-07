From: akpm@osdl.org
Subject: - quieten-freezer-if-config_pm_debug.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:27 -0800
Message-ID: <200612072259.kB7MxRNN029522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51038 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163683AbWLGW7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ncunningham@linuxmail.org, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     swsusp: quieten Freezer if !CONFIG_PM_DEBUG
has been removed from the -mm tree.  Its filename was
     quieten-freezer-if-config_pm_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: quieten Freezer if !CONFIG_PM_DEBUG
From: Nigel Cunningham <ncunningham@linuxmail.org>

The freezer currently prints an '=' for every process that is frozen.  This
is pretty pointless, as the equals sign says nothing about which process is
frozen, and makes logs look messier (especially if there were a large
number of processes running).  All we really need to know is that we
started trying to freeze processes and what processes (if any) failed to
freeze, or that we succeeded.

Signed-off-by: Nigel Cunningham <nigel@suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/process.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/power/process.c~quieten-freezer-if-config_pm_debug kernel/power/process.c
--- a/kernel/power/process.c~quieten-freezer-if-config_pm_debug
+++ a/kernel/power/process.c
@@ -40,7 +40,6 @@ void refrigerator(void)
 	long save;
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
-	printk("=");
 
 	frozen_process(current);
 	spin_lock_irq(&current->sighand->siglock);
_

Patches currently in -mm which might be from ncunningham@linuxmail.org are

origin.patch


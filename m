From: akpm@linux-foundation.org
Subject: - make-elv_register-output-atomic.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:43:18 -0700
Message-ID: <200703290743.l2T7hIVm030373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965977AbXC2Hq4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:46:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: T-Bone@parisc-linux.org, varenet@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     make elv_register() output atomic
has been removed from the -mm tree.  Its filename was
     make-elv_register-output-atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make elv_register() output atomic
From: Thibaut VARENE <T-Bone@parisc-linux.org>

Booting 2.6.21-rc3-g45592145 I noticed the following on one of my
machines in the bootlog:

io scheduler noop registered<6>Time: jiffies clocksource has been installed.

io scheduler deadline registered (default)

Looking at block/elevator.c, it appears that elv_register() uses two
consecutive printks in a non-atomic way, leading to the above glitch.  The
attached trivial patch fixes this issue, by using a single printk.

Signed-off-by: Thibaut VARENE <varenet@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN block/elevator.c~make-elv_register-output-atomic block/elevator.c
--- a/block/elevator.c~make-elv_register-output-atomic
+++ a/block/elevator.c
@@ -964,17 +964,18 @@ void elv_unregister_queue(struct request
 
 int elv_register(struct elevator_type *e)
 {
+	char *def = "";
 	spin_lock_irq(&elv_list_lock);
 	BUG_ON(elevator_find(e->elevator_name));
 	list_add_tail(&e->list, &elv_list);
 	spin_unlock_irq(&elv_list_lock);
 
-	printk(KERN_INFO "io scheduler %s registered", e->elevator_name);
 	if (!strcmp(e->elevator_name, chosen_elevator) ||
 			(!*chosen_elevator &&
 			 !strcmp(e->elevator_name, CONFIG_DEFAULT_IOSCHED)))
-				printk(" (default)");
-	printk("\n");
+				def = " (default)";
+
+	printk(KERN_INFO "io scheduler %s registered%s\n", e->elevator_name, def);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(elv_register);
_

Patches currently in -mm which might be from T-Bone@parisc-linux.org are

origin.patch
git-netdev-all.patch

From: akpm@linux-foundation.org
Subject: - uml-mconsole-locking.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:35 -0800
Message-ID: <200702112248.l1BMmZrD015645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59738 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676AbXBKWsh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: mconsole locking
has been removed from the -mm tree.  Its filename was
     uml-mconsole-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: mconsole locking
From: Jeff Dike <jdike@addtoit.com>

Locking fixes.  Locking was totally lacking for the mconsole_devices, which
got a spin lock, and the unplugged pages data, which got a mutex.

The locking of the mconsole console output code was confused.  Now, the
console_lock (renamed to client_lock) protects the clients list.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |   21 +++++++++++++++------
 arch/um/drivers/net_kern.c      |    1 +
 arch/um/drivers/ssl.c           |    1 +
 arch/um/drivers/ubd_kern.c      |    1 +
 arch/um/kernel/tt/gdb_kern.c    |    1 +
 5 files changed, 19 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-mconsole-locking arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-mconsole-locking
+++ a/arch/um/drivers/mconsole_kern.c
@@ -337,13 +337,15 @@ void mconsole_stop(struct mc_request *re
 	mconsole_reply(req, "", 0, 0);
 }
 
-/* This list is populated by __initcall routines. */
-
+static DEFINE_SPINLOCK(mc_devices_lock);
 static LIST_HEAD(mconsole_devices);
 
 void mconsole_register_dev(struct mc_device *new)
 {
+	spin_lock(&mc_devices_lock);
+	BUG_ON(!list_empty(&new->list));
 	list_add(&new->list, &mconsole_devices);
+	spin_unlock(&mc_devices_lock);
 }
 
 static struct mc_device *mconsole_find_dev(char *name)
@@ -367,6 +369,7 @@ struct unplugged_pages {
 	void *pages[UNPLUGGED_PER_PAGE];
 };
 
+static DECLARE_MUTEX(plug_mem_mutex);
 static unsigned long long unplugged_pages_count = 0;
 static struct list_head unplugged_pages = LIST_HEAD_INIT(unplugged_pages);
 static int unplug_index = UNPLUGGED_PER_PAGE;
@@ -402,6 +405,7 @@ static int mem_config(char *str, char **
 
 	diff /= PAGE_SIZE;
 
+	down(&plug_mem_mutex);
 	for(i = 0; i < diff; i++){
 		struct unplugged_pages *unplugged;
 		void *addr;
@@ -447,7 +451,7 @@ static int mem_config(char *str, char **
 					printk("Failed to release memory - "
 					       "errno = %d\n", err);
 					*error_out = "Failed to release memory";
-					goto out;
+					goto out_unlock;
 				}
 				unplugged->pages[unplug_index++] = addr;
 			}
@@ -457,6 +461,8 @@ static int mem_config(char *str, char **
 	}
 
 	err = 0;
+out_unlock:
+	up(&plug_mem_mutex);
 out:
 	return err;
 }
@@ -487,6 +493,7 @@ static int mem_remove(int n, char **erro
 }
 
 static struct mc_device mem_mc = {
+	.list		= LIST_HEAD_INIT(mem_mc.list),
 	.name		= "mem",
 	.config		= mem_config,
 	.get_config	= mem_get_config,
@@ -629,7 +636,7 @@ struct mconsole_output {
 	struct mc_request *req;
 };
 
-static DEFINE_SPINLOCK(console_lock);
+static DEFINE_SPINLOCK(client_lock);
 static LIST_HEAD(clients);
 static char console_buf[MCONSOLE_MAX_DATA];
 static int console_index = 0;
@@ -684,16 +691,18 @@ static void with_console(struct mc_reque
 	unsigned long flags;
 
 	entry.req = req;
+	spin_lock_irqsave(&client_lock, flags);
 	list_add(&entry.list, &clients);
-	spin_lock_irqsave(&console_lock, flags);
+	spin_unlock_irqrestore(&client_lock, flags);
 
 	(*proc)(arg);
 
 	mconsole_reply_len(req, console_buf, console_index, 0, 0);
 	console_index = 0;
 
-	spin_unlock_irqrestore(&console_lock, flags);
+	spin_lock_irqsave(&client_lock, flags);
 	list_del(&entry.list);
+	spin_unlock_irqrestore(&client_lock, flags);
 }
 
 #ifdef CONFIG_MAGIC_SYSRQ
diff -puN arch/um/drivers/net_kern.c~uml-mconsole-locking arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-mconsole-locking
+++ a/arch/um/drivers/net_kern.c
@@ -690,6 +690,7 @@ static int net_remove(int n, char **erro
 }
 
 static struct mc_device net_mc = {
+	.list		= LIST_HEAD_INIT(net_mc.list),
 	.name		= "eth",
 	.config		= net_config,
 	.get_config	= NULL,
diff -puN arch/um/drivers/ssl.c~uml-mconsole-locking arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-mconsole-locking
+++ a/arch/um/drivers/ssl.c
@@ -64,6 +64,7 @@ static struct line_driver driver = {
 	.symlink_from 		= "serial",
 	.symlink_to 		= "tts",
 	.mc  = {
+		.list		= LIST_HEAD_INIT(driver.mc.list),
 		.name  		= "ssl",
 		.config 	= ssl_config,
 		.get_config 	= ssl_get_config,
diff -puN arch/um/drivers/ubd_kern.c~uml-mconsole-locking arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-mconsole-locking
+++ a/arch/um/drivers/ubd_kern.c
@@ -828,6 +828,7 @@ out:
  * ubd-specific locks.
  */
 static struct mc_device ubd_mc = {
+	.list		= LIST_HEAD_INIT(ubd_mc.list),
 	.name		= "ubd",
 	.config		= ubd_config,
  	.get_config	= ubd_get_config,
diff -puN arch/um/kernel/tt/gdb_kern.c~uml-mconsole-locking arch/um/kernel/tt/gdb_kern.c
--- a/arch/um/kernel/tt/gdb_kern.c~uml-mconsole-locking
+++ a/arch/um/kernel/tt/gdb_kern.c
@@ -12,6 +12,7 @@ extern int gdb_config(char *str, char **
 extern int gdb_remove(int n, char **error_out);
 
 static struct mc_device gdb_mc = {
+	.list		= INIT_LIST_HEAD(gdb_mc.list),
 	.name		= "gdb",
 	.config		= gdb_config,
 	.remove		= gdb_remove,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch

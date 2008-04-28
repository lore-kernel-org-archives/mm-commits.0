From: akpm@linux-foundation.org
Subject: - uml-make-several-things-static.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:00 -0700
Message-ID: <200804282155.m3SLt0vg018058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934567AbYD1VzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: make several things static
has been removed from the -mm tree.  Its filename was
     uml-make-several-things-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: make several things static
From: WANG Cong <xiyou.wangcong@gmail.com>

Make several things static, because they no longer need to be global.

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c      |    6 +++---
 arch/um/drivers/slip_kern.c     |    4 ++--
 arch/um/drivers/stdio_console.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-make-several-things-static arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-make-several-things-static
+++ a/arch/um/drivers/net_kern.c
@@ -116,7 +116,7 @@ static void uml_dev_close(struct work_st
 	dev_close(lp->dev);
 }
 
-irqreturn_t uml_net_interrupt(int irq, void *dev_id)
+static irqreturn_t uml_net_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct uml_net_private *lp = dev->priv;
@@ -296,7 +296,7 @@ static struct ethtool_ops uml_net_ethtoo
 	.get_link	= ethtool_op_get_link,
 };
 
-void uml_net_user_timer_expire(unsigned long _conn)
+static void uml_net_user_timer_expire(unsigned long _conn)
 {
 #ifdef undef
 	struct connection *conn = (struct connection *)_conn;
@@ -786,7 +786,7 @@ static int uml_inetaddr_event(struct not
 }
 
 /* uml_net_init shouldn't be called twice on two CPUs at the same time */
-struct notifier_block uml_inetaddr_notifier = {
+static struct notifier_block uml_inetaddr_notifier = {
 	.notifier_call		= uml_inetaddr_event,
 };
 
diff -puN arch/um/drivers/slip_kern.c~uml-make-several-things-static arch/um/drivers/slip_kern.c
--- a/arch/um/drivers/slip_kern.c~uml-make-several-things-static
+++ a/arch/um/drivers/slip_kern.c
@@ -13,7 +13,7 @@ struct slip_init {
 	char *gate_addr;
 };
 
-void slip_init(struct net_device *dev, void *data)
+static void slip_init(struct net_device *dev, void *data)
 {
 	struct uml_net_private *private;
 	struct slip_data *spri;
@@ -57,7 +57,7 @@ static int slip_write(int fd, struct sk_
 			       (struct slip_data *) &lp->user);
 }
 
-const struct net_kern_info slip_kern_info = {
+static const struct net_kern_info slip_kern_info = {
 	.init			= slip_init,
 	.protocol		= slip_protocol,
 	.read			= slip_read,
diff -puN arch/um/drivers/stdio_console.c~uml-make-several-things-static arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-make-several-things-static
+++ a/arch/um/drivers/stdio_console.c
@@ -34,7 +34,7 @@
 
 static struct tty_driver *console_driver;
 
-void stdio_announce(char *dev_name, int dev)
+static void stdio_announce(char *dev_name, int dev)
 {
 	printk(KERN_INFO "Virtual console %d assigned device '%s'\n", dev,
 	       dev_name);
@@ -158,7 +158,7 @@ static struct console stdiocons = {
 	.index		= -1,
 };
 
-int stdio_init(void)
+static int stdio_init(void)
 {
 	char *new_title;
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch


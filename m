From: akpm@linux-foundation.org
Subject: + netconsole-introduce-netconsole_target.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:13:29 -0700
Message-ID: <200707310013.l6V0DTH3005680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936275AbXGaANw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com


The patch titled
     netconsole: Introduce netconsole_target
has been added to the -mm tree.  Its filename is
     netconsole-introduce-netconsole_target.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netconsole: Introduce netconsole_target
From: Satyam Sharma <satyam@infradead.org>

Introduce a wrapper structure over netpoll to represent logging targets
configured in netconsole.  This will get extended with other members in
further patches.

This is done independent of the (to-be-introduced) NETCONSOLE_DYNAMIC config
option so that we're able to drastically cut down on the #ifdef complexity of
final netconsole.c.  Also, struct netconsole_target would be required for
multiple targets support also, and not just dynamic reconfigurability.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-introduce-netconsole_target drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-introduce-netconsole_target
+++ a/drivers/net/netconsole.c
@@ -62,24 +62,35 @@ static int __init option_setup(char *opt
 __setup("netconsole=", option_setup);
 #endif	/* MODULE */
 
-static struct netpoll np = {
-	.name		= "netconsole",
-	.dev_name	= "eth0",
-	.local_port	= 6665,
-	.remote_port	= 6666,
-	.remote_mac	= {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
+/**
+ * struct netconsole_target - Represents a configured netconsole target.
+ * @np:		The netpoll structure for this target.
+ */
+struct netconsole_target {
+	struct netpoll		np;
+};
+
+static struct netconsole_target default_target = {
+	.np		= {
+		.name		= "netconsole",
+		.dev_name	= "eth0",
+		.local_port	= 6665,
+		.remote_port	= 6666,
+		.remote_mac	= {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
+	},
 };
 
 static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
 	int frag, left;
 	unsigned long flags;
+	struct netconsole_target *nt = &default_target;
 
-	if (netif_running(np.dev)) {
+	if (netif_running(nt->np.dev)) {
 		local_irq_save(flags);
 		for (left = len; left;) {
 			frag = min(left, MAX_PRINT_CHUNK);
-			netpoll_send_udp(&np, msg, frag);
+			netpoll_send_udp(&nt->np, msg, frag);
 			msg += frag;
 			left -= frag;
 		}
@@ -96,17 +107,18 @@ static struct console netconsole = {
 static int __init init_netconsole(void)
 {
 	int err = 0;
+	struct netconsole_target *nt = &default_target;
 
 	if (!strnlen(config, MAX_PARAM_LENGTH)) {
 		printk(KERN_INFO "netconsole: not configured, aborting\n");
 		goto out;
 	}
 
-	err = netpoll_parse_options(&np, config);
+	err = netpoll_parse_options(&nt->np, config);
 	if (err)
 		goto out;
 
-	err = netpoll_setup(&np);
+	err = netpoll_setup(&nt->np);
 	if (err)
 		goto out;
 
@@ -119,8 +131,10 @@ out:
 
 static void __exit cleanup_netconsole(void)
 {
+	struct netconsole_target *nt = &default_target;
+
 	unregister_console(&netconsole);
-	netpoll_cleanup(&np);
+	netpoll_cleanup(&nt->np);
 }
 
 module_init(init_netconsole);
_

Patches currently in -mm which might be from satyam@infradead.org are

use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch
netconsole-cleanups-codingstyle-prettyfication.patch
netconsole-remove-bogus-check.patch
netconsole-simplify-boot-module-option-setup-logic.patch
netconsole-use-netif_running-in-write_msg.patch
netconsole-add-some-useful-tips-to-documentation.patch
netconsole-introduce-netconsole_target.patch
netconsole-introduce-netconsole_netdev_notifier.patch
netconsole-support-multiple-logging-targets.patch
netconsole-support-dynamic-reconfiguration-using-configfs.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fix-a-typo-in-documentation-keystxt.patch

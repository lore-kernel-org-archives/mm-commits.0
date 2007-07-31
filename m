From: akpm@linux-foundation.org
Subject: + netconsole-simplify-boot-module-option-setup-logic.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:13:23 -0700
Message-ID: <200707310013.l6V0DNj1005671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932826AbXGaANp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com


The patch titled
     netconsole: Simplify boot/module option setup logic
has been added to the -mm tree.  Its filename is
     netconsole-simplify-boot-module-option-setup-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netconsole: Simplify boot/module option setup logic
From: Satyam Sharma <satyam@infradead.org>

Presently, boot/module parameters are set up quite differently for the case of
built-in netconsole (__setup() -> obsolete_checksetup() ->
netpoll_parse_options() -> strlen(config) == 0 in init_netconsole()) vs
modular netconsole (module_param_string() -> string copied to the config
variable -> strlen(config) != 0 init_netconsole() -> netpoll_parse_options()).

This patch makes both of them similar by doing exactly the equivalent of a
module_param_string() in option_setup() also -- just copying the param string
passed from the kernel command line into "config" variable.  So,
strlen(config) != 0 in both cases, and netpoll_parse_options() is always
called from init_netconsole(), thus making the setup logic for both cases
similar.

Now, option_setup() is only ever called / used for the built-in case, so we
put it inside a #ifndef MODULE, otherwise gcc will complain about
option_setup() being "defined but not used".  Also, the "configured" variable
is redundant with this patch and hence removed.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-simplify-boot-module-option-setup-logic drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-simplify-boot-module-option-setup-logic
+++ a/drivers/net/netconsole.c
@@ -53,6 +53,15 @@ static char config[MAX_PARAM_LENGTH];
 module_param_string(netconsole, config, MAX_PARAM_LENGTH, 0);
 MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]\n");
 
+#ifndef	MODULE
+static int __init option_setup(char *opt)
+{
+	strlcpy(config, opt, MAX_PARAM_LENGTH);
+	return 1;
+}
+__setup("netconsole=", option_setup);
+#endif	/* MODULE */
+
 static struct netpoll np = {
 	.name		= "netconsole",
 	.dev_name	= "eth0",
@@ -60,7 +69,6 @@ static struct netpoll np = {
 	.remote_port	= 6666,
 	.remote_mac	= {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
 };
-static int configured;
 
 static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
@@ -85,26 +93,19 @@ static struct console netconsole = {
 	.write	= write_msg,
 };
 
-static int __init option_setup(char *opt)
-{
-	configured = !netpoll_parse_options(&np, opt);
-	return 1;
-}
-
-__setup("netconsole=", option_setup);
-
 static int __init init_netconsole(void)
 {
 	int err = 0;
 
-	if (strnlen(config, MAX_PARAM_LENGTH))
-		option_setup(config);
-
-	if (!configured) {
+	if (!strnlen(config, MAX_PARAM_LENGTH)) {
 		printk(KERN_INFO "netconsole: not configured, aborting\n");
 		goto out;
 	}
 
+	err = netpoll_parse_options(&np, config);
+	if (err)
+		goto out;
+
 	err = netpoll_setup(&np);
 	if (err)
 		goto out;
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

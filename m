From: akpm@linux-foundation.org
Subject: + netconsole-introduce-netconsole_netdev_notifier.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:13:31 -0700
Message-ID: <200707310013.l6V0DVbB005683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938089AbXGaAN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com


The patch titled
     netconsole: Introduce netconsole_netdev_notifier
has been added to the -mm tree.  Its filename is
     netconsole-introduce-netconsole_netdev_notifier.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netconsole: Introduce netconsole_netdev_notifier
From: Satyam Sharma <satyam@infradead.org>

To update fields of underlying netpoll structure at runtime on corresponding
NETDEV_CHANGEADDR or NETDEV_CHANGENAME notifications.

ioctl(SIOCSIFHWADDR or SIOCSIFNAME) could be used to change the hardware/MAC
address or name of the local interface that our netpoll is attached to. 
Whenever this happens, netdev notifier chain is called out with the
NETDEV_CHANGEADDR or NETDEV_CHANGENAME event message.  We respond to that and
update the local_mac or dev_name field of the struct netpoll.  This makes
sense anyway, but is especially required for dynamic netconsole because the
netpoll structure's internal members become user visible files when either
sysfs or configfs are used.  So this helps us to keep up with the MAC
address/name changes and keep values in struct netpoll uptodate.

[ Note that ioctl(SIOCSIFADDR) to change IP address of interface at
  runtime is not handled (to update local_ip of netpoll) on purpose --
  some setups may set the local_ip to a private address, not necessary
  the actual IP address of the sender host, as presently allowed. ]

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+)

diff -puN drivers/net/netconsole.c~netconsole-introduce-netconsole_netdev_notifier drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-introduce-netconsole_netdev_notifier
+++ a/drivers/net/netconsole.c
@@ -80,6 +80,33 @@ static struct netconsole_target default_
 	},
 };
 
+/* Handle network interface device notifications */
+static int netconsole_netdev_event(struct notifier_block *this,
+				   unsigned long event,
+				   void *ptr)
+{
+	struct net_device *dev = ptr;
+	struct netconsole_target *nt = &default_target;
+
+	if (nt->np.dev == dev) {
+		switch (event) {
+		case NETDEV_CHANGEADDR:
+			memcpy(nt->np.local_mac, dev->dev_addr, ETH_ALEN);
+			break;
+
+		case NETDEV_CHANGENAME:
+			strlcpy(nt->np.dev_name, dev->name, IFNAMSIZ);
+			break;
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block netconsole_netdev_notifier = {
+	.notifier_call  = netconsole_netdev_event,
+};
+
 static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
 	int frag, left;
@@ -122,6 +149,10 @@ static int __init init_netconsole(void)
 	if (err)
 		goto out;
 
+	err = register_netdevice_notifier(&netconsole_netdev_notifier);
+	if (err)
+		goto out;
+
 	register_console(&netconsole);
 	printk(KERN_INFO "netconsole: network logging started\n");
 
@@ -134,6 +165,7 @@ static void __exit cleanup_netconsole(vo
 	struct netconsole_target *nt = &default_target;
 
 	unregister_console(&netconsole);
+	unregister_netdevice_notifier(&netconsole_netdev_notifier);
 	netpoll_cleanup(&nt->np);
 }
 
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

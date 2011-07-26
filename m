From: akpm@linux-foundation.org
Subject: [merged] um-add-netpoll-support.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:27 -0700
Message-ID: <201107260753.p6Q7rUh0003235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab1GZHyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: add netpoll support
has been removed from the -mm tree.  Its filename was
     um-add-netpoll-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: add netpoll support
From: Richard Weinberger <richard@nod.at>

To make netconsole usable on UML, its ethernet driver needs netpoll
support.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN arch/um/drivers/net_kern.c~um-add-netpoll-support arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~um-add-netpoll-support
+++ a/arch/um/drivers/net_kern.c
@@ -262,6 +262,15 @@ static int uml_net_change_mtu(struct net
 	return 0;
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void uml_net_poll_controller(struct net_device *dev)
+{
+	disable_irq(dev->irq);
+	uml_net_interrupt(dev->irq, dev);
+	enable_irq(dev->irq);
+}
+#endif
+
 static void uml_net_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
@@ -364,6 +373,9 @@ static const struct net_device_ops uml_n
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu 	= uml_net_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller = uml_net_poll_controller,
+#endif
 };
 
 /*
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch


From: akpm@linux-foundation.org
Subject: + um-add-netpoll-support.patch added to -mm tree
Date: Tue, 28 Jun 2011 15:56:18 -0700
Message-ID: <201106282256.p5SMuIeC012527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab1F1W4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 18:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: add netpoll support
has been added to the -mm tree.  Its filename is
     um-add-netpoll-support.patch

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

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch


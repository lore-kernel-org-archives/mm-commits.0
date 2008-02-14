From: akpm@linux-foundation.org
Subject: - pcmcia-ipwireless-depends-on-netdevices.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:13 -0500
Message-ID: <200802150226.m1F2QWXo015231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765192AbYBOC0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     pcmcia: ipwireless depends on NETDEVICES
has been removed from the -mm tree.  Its filename was
     pcmcia-ipwireless-depends-on-netdevices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: ipwireless depends on NETDEVICES
From: Paul Mundt <lethal@linux-sh.org>

ipwireless (added by 099dc4fb62653f6019d78db55fba7a18ef02d65b) is clearly
a net device:

drivers/built-in.o: In function `ipwireless_ppp_start_xmit':
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:165: undefined reference to `skb_under_panic'
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:165: undefined reference to `kfree_skb'
drivers/built-in.o: In function `ipwireless_network_packet_received':
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:377: undefined reference to `__alloc_skb'
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:377: undefined reference to `skb_over_panic'
drivers/built-in.o: In function `ppp_shutdown_interface':
/home/pmundt/devel/git/sh-2.6.25/drivers/net/ppp_generic.c:2517: undefined reference to `unregister_netdev'
/home/pmundt/devel/git/sh-2.6.25/drivers/net/ppp_generic.c:2517: undefined reference to `free_netdev'
[ ... and many more ... ]

select strikes again. ipwireless selects PPP which in turn tries to select
SLHC, both of which are technically "protected" by an if NETDEVICES
in drivers/net/Kconfig. This leads to .config hilarity, with net suddenly
ending up in the SCSI menu:

	#
	# SCSI device support
	#
	# CONFIG_SCSI_DMA is not set
	# CONFIG_SCSI_NETLINK is not set
	CONFIG_PPP=y
	# CONFIG_PHONE is not set

Curiously the SLHC select from PPP doesn't seem to happen, as there's no
CONFIG_SLHC=y (only CONFIG_PPP=y gets set) -- Kconfig bug? Caught with a
randconfig.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/Kconfig~pcmcia-ipwireless-depends-on-netdevices drivers/char/pcmcia/Kconfig
--- a/drivers/char/pcmcia/Kconfig~pcmcia-ipwireless-depends-on-netdevices
+++ a/drivers/char/pcmcia/Kconfig
@@ -45,7 +45,7 @@ config CARDMAN_4040
 
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
-	depends on PCMCIA
+	depends on PCMCIA && NETDEVICES
 	select PPP
 	help
 	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
fix-module_update_markers-compile-error.patch
git-dvb.patch
git-sh.patch
net-xfrm-statistics-depend-on-inet.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
asm-futexh-should-include-linux-uaccessh.patch

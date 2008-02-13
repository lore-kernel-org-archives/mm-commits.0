From: akpm@linux-foundation.org
Subject: + pcmcia-ipwireless-depends-on-netdevices.patch added to -mm tree
Date: Wed, 13 Feb 2008 10:23:27 -0800
Message-ID: <200802131823.m1DINTUR006745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbYBMSYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 13:24:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, jkosina@suse.cz


The patch titled
     pcmcia: ipwireless depends on NETDEVICES
has been added to the -mm tree.  Its filename is
     pcmcia-ipwireless-depends-on-netdevices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Jiri Kosina <jkosina@suse.cz>
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
git-sh.patch
pcmcia-ipwireless-depends-on-netdevices.patch
sm501-add-uart-support.patch

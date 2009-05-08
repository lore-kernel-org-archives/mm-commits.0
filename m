From: akpm@linux-foundation.org
Subject: + uml-uml-net-driver-does-not-allow-for-vlans.patch added to -mm tree
Date: Fri, 08 May 2009 12:12:03 -0700
Message-ID: <200905081912.n48JC3tm019144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbZEHTQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 15:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@linux.intel.com, blaisorblade@yahoo.it, davem@davemloft.net, devzero@web.de, jdike@addtoit.com


The patch titled
     uml: UML net driver does not allow for vlans
has been added to the -mm tree.  Its filename is
     uml-uml-net-driver-does-not-allow-for-vlans.patch

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
Subject: uml: UML net driver does not allow for vlans
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

See ancient discussion at
http://marc.info/?l=user-mode-linux-devel&m=101990155831279&w=2

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=7854

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Roland Kletzing <devzero@web.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/shared/net_user.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/include/shared/net_user.h~uml-uml-net-driver-does-not-allow-for-vlans arch/um/include/shared/net_user.h
--- a/arch/um/include/shared/net_user.h~uml-uml-net-driver-does-not-allow-for-vlans
+++ a/arch/um/include/shared/net_user.h
@@ -8,7 +8,7 @@
 
 #define ETH_ADDR_LEN (6)
 #define ETH_HEADER_ETHERTAP (16)
-#define ETH_HEADER_OTHER (14)
+#define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for crazy people */
 #define ETH_MAX_PACKET (1500)
 
 #define UML_NET_VERSION (4)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uml-uml-net-driver-does-not-allow-for-vlans.patch
drivers-usb-serial-ti_usb_3410_5052c-ti_usb-returns-eio-when-reopening-the-device.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
serial-8250c-irq-handling-race-and-spurious-iir-read.patch
serial-z85c30-bcm1480-loops-reach-1.patch
serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug.patch
char-isicom-fix-build-warning.patch
linuxpps-core-support.patch


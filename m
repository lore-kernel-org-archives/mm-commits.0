From: akpm@linux-foundation.org
Subject: + the-kernel-gets-no-ip-from-some-dhcp-servers.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:37:29 -0800
Message-ID: <200802292337.m1TNbTcQ026538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbYB2Xhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Marcel.Wappler@bridgeco.net, davem@davemloft.net, kaber@trash.net, shemminger@linux-foundation.org


The patch titled
     The kernel gets no IP from some DHCP servers
has been added to the -mm tree.  Its filename is
     the-kernel-gets-no-ip-from-some-dhcp-servers.patch

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
Subject: The kernel gets no IP from some DHCP servers
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>

This patch fixes a DHCP issue of the kernel: some DHCP servers (i.e.  in the
Linksys WRT54Gv5) are very strict about the contents of the DHCPDISCOVER
packet they receive from clients.

Table 5 in RFC2131 page 36 requests the fields 'ciaddr' and 'siaddr' MUST be
set to '0'.  These DHCP servers ignore Linux kernel's DHCP discovery packets
with these two fields set to '255.255.255.255' (in contrast to popular DHCP
clients, such as 'dhclient' or 'udhcpc').  This leads to a not booting system.

I tested this on a ARM embedded device mounting rootfs over NFS obtaining its
IP from a Linksys WRT54Gv5 Router running VxWorks and a PC based Server
running a Linux.  Changing the two fields to '0.0.0.0' worked.

Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipconfig.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN net/ipv4/ipconfig.c~the-kernel-gets-no-ip-from-some-dhcp-servers net/ipv4/ipconfig.c
--- a/net/ipv4/ipconfig.c~the-kernel-gets-no-ip-from-some-dhcp-servers
+++ a/net/ipv4/ipconfig.c
@@ -29,6 +29,10 @@
  *
  *  Multiple Nameservers in /proc/net/pnp
  *              --  Josef Siemes <jsiemes@web.de>, Aug 2002
+ *
+ *  Bugfix: Not getting an IP from some DHCP servers: RFC2131 page 36
+ *  Table 5 requests DHCPDISCOVER fields ciaddr and siaddr MUST be '0'.
+ *              -- marcel.wappler@bridgeco.net
  */
 
 #include <linux/types.h>
@@ -103,6 +107,7 @@
 					   - '3' from resolv.h */
 
 #define NONE __constant_htonl(INADDR_NONE)
+#define ZERO __constant_htonl(((unsigned long int) 0x00000000))
 
 /*
  * Public IP configuration
@@ -754,8 +759,8 @@ static void __init ic_bootp_send_if(stru
 		b->htype = dev->type; /* can cause undefined behavior */
 	}
 	b->hlen = dev->addr_len;
-	b->your_ip = NONE;
-	b->server_ip = NONE;
+	b->your_ip = ZERO;
+	b->server_ip = ZERO;
 	memcpy(b->hw_addr, dev->dev_addr, dev->addr_len);
 	b->secs = htons(jiffies_diff / HZ);
 	b->xid = d->xid;
_

Patches currently in -mm which might be from Marcel.Wappler@bridgeco.net are

the-kernel-gets-no-ip-from-some-dhcp-servers.patch


From: akpm@linux-foundation.org
Subject: + tun-tap-fix-rtnl-locking.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:35:36 -0800
Message-ID: <200802292335.m1TNZaE9026507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760073AbYB2Xji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Kim.Heino@bluegiga.com, davem@davemloft.net, maxk@qualcomm.com


The patch titled
     tun/tap: fix RTNL-locking
has been added to the -mm tree.  Its filename is
     tun-tap-fix-rtnl-locking.patch

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
Subject: tun/tap: fix RTNL-locking
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>

Current tun/tap driver sets also net device's hw address when asked to change
character device's hw address.  This is a good idea, but it misses
RTLN-locking, resulting following error message in 2.6.25-rc3's
inetdev_event() function:

RTNL: assertion failed at net/ipv4/devinet.c (1050)

Signed-off-by: Kim B. Heino <Kim.Heino@bluegiga.com>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tun.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/net/tun.c~tun-tap-fix-rtnl-locking drivers/net/tun.c
--- a/drivers/net/tun.c~tun-tap-fix-rtnl-locking
+++ a/drivers/net/tun.c
@@ -663,7 +663,11 @@ static int tun_chr_ioctl(struct inode *i
 	case SIOCSIFHWADDR:
 	{
 		/* try to set the actual net device's hw address */
-		int ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
+		int ret;
+
+		rtnl_lock();
+		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
+		rtnl_unlock();
 
 		if (ret == 0) {
 			/** Set the character device's hardware address. This is used when
_

Patches currently in -mm which might be from Kim.Heino@bluegiga.com are

tun-tap-fix-rtnl-locking.patch


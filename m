From: akpm@linux-foundation.org
Subject: + fix-incorrect-prototype-for-ipxrtr_route_packet.patch added to -mm tree
Date: Thu, 17 May 2007 15:27:59 -0700
Message-ID: <200705172227.l4HMRx4v001991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbXEQW3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 18:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org


The patch titled
     Fix incorrect prototype for ipxrtr_route_packet()
has been added to the -mm tree.  Its filename is
     fix-incorrect-prototype-for-ipxrtr_route_packet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix incorrect prototype for ipxrtr_route_packet()
From: David Woodhouse <dwmw2@infradead.org>

The function ipxrtr_route_packet() takes a 'len' argument of type size_t. 
However, its prototype in af_ipx.c incorrectly suggests that the
corresponding argument is of type 'int' instead.

Discovered by building with --combine and letting the compiler see it all
at once.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipx/af_ipx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipx/af_ipx.c~fix-incorrect-prototype-for-ipxrtr_route_packet net/ipx/af_ipx.c
--- a/net/ipx/af_ipx.c~fix-incorrect-prototype-for-ipxrtr_route_packet
+++ a/net/ipx/af_ipx.c
@@ -87,7 +87,7 @@ extern int ipxrtr_add_route(__be32 netwo
 			    unsigned char *node);
 extern void ipxrtr_del_routes(struct ipx_interface *intrfc);
 extern int ipxrtr_route_packet(struct sock *sk, struct sockaddr_ipx *usipx,
-			       struct iovec *iov, int len, int noblock);
+			       struct iovec *iov, size_t len, int noblock);
 extern int ipxrtr_route_skb(struct sk_buff *skb);
 extern struct ipx_route *ipxrtr_lookup(__be32 net);
 extern int ipxrtr_ioctl(unsigned int cmd, void __user *arg);
_

Patches currently in -mm which might be from dwmw2@infradead.org are

remove-slab_ctor_constructor.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-ubi.patch
fix-incorrect-prototype-for-ipxrtr_route_packet.patch
git-battery.patch
ns16550a-restore-hs-settings-in-excr2-on-resume.patch
add-lzo1x-compression-support-to-the-kernel.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch

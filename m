From: akpm@linux-foundation.org
Subject: + arch-um-drivers-remove-duplicate-structure-field-initialization.patch added to -mm tree
Date: Mon, 21 Jun 2010 15:53:56 -0700
Message-ID: <201006212253.o5LMrud6009921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab0FUWya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 18:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, shemminger@vyatta.com


The patch titled
     From: Julia Lawall <julia@diku.dk>
has been added to the -mm tree.  Its filename is
     arch-um-drivers-remove-duplicate-structure-field-initialization.patch

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
Subject: From: Julia Lawall <julia@diku.dk>
From: Julia Lawall <julia@diku.dk>


There are two initializations of ndo_set_mac_address, one to a local
function that is not used otherwise and one to a function that is defined
elsewhere.  This patch keeps the initialization to the local function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

akpm:

- Use the standard eth_mac_addr() in uml_net_set_mac()

- Remove unneeded and racy local set_ether_mac()

- Remove duplicated (and incorrect)
  uml_netdev_ops.ndo_set_mac_address initializer.

Fixes 8bb95b39a16ed55226810596f92216c53329d2fe ("uml: convert network
device to netdevice ops").

[akpm@linux-foundation.org: rework as above]
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN arch/um/drivers/net_kern.c~arch-um-drivers-remove-duplicate-structure-field-initialization arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~arch-um-drivers-remove-duplicate-structure-field-initialization
+++ a/arch/um/drivers/net_kern.c
@@ -25,11 +25,6 @@
 #include "net_kern.h"
 #include "net_user.h"
 
-static inline void set_ether_mac(struct net_device *dev, unsigned char *addr)
-{
-	memcpy(dev->dev_addr, addr, ETH_ALEN);
-}
-
 #define DRIVER_NAME "uml-netdev"
 
 static DEFINE_SPINLOCK(opened_lock);
@@ -266,7 +261,7 @@ static int uml_net_set_mac(struct net_de
 	struct sockaddr *hwaddr = addr;
 
 	spin_lock_irq(&lp->lock);
-	set_ether_mac(dev, hwaddr->sa_data);
+	eth_mac_addr(dev, hwaddr->sa_data);
 	spin_unlock_irq(&lp->lock);
 
 	return 0;
@@ -380,7 +375,6 @@ static const struct net_device_ops uml_n
 	.ndo_tx_timeout 	= uml_net_tx_timeout,
 	.ndo_set_mac_address	= uml_net_set_mac,
 	.ndo_change_mtu 	= uml_net_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -478,7 +472,7 @@ static void eth_configure(int n, void *i
 	    ((*transport->user->init)(&lp->user, dev) != 0))
 		goto out_unregister;
 
-	set_ether_mac(dev, device->mac);
+	eth_mac_addr(dev, device->mac);
 	dev->mtu = transport->user->mtu;
 	dev->netdev_ops = &uml_netdev_ops;
 	dev->ethtool_ops = &uml_net_ethtool_ops;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-hid-eliminate-a-double-lock.patch
arch-sh-mm-eliminate-a-double-lock.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch


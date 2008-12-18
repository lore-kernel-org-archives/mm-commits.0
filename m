From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch added to -mm tree
Date: Thu, 18 Dec 2008 13:10:48 -0800
Message-ID: <200812182110.mBILAnYN022138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbYLRVLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 16:11:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dcbw@redhat.com


The patch titled
     drivers/net/wireless/libertas: move a dereference below a NULL test
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch

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
Subject: drivers/net/wireless/libertas: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.  I have also taken advantage of the availability
of the value of priv->dev in the subsequent calls to netif_stop_queue and
netif_carrier_off.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/libertas/main.c~drivers-net-wireless-libertas-move-a-dereference-below-a-null-test drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~drivers-net-wireless-libertas-move-a-dereference-below-a-null-test
+++ a/drivers/net/wireless/libertas/main.c
@@ -1369,7 +1369,7 @@ EXPORT_SYMBOL_GPL(lbs_start_card);
 
 void lbs_stop_card(struct lbs_private *priv)
 {
-	struct net_device *dev = priv->dev;
+	struct net_device *dev;
 	struct cmd_ctrl_node *cmdnode;
 	unsigned long flags;
 
@@ -1377,9 +1377,10 @@ void lbs_stop_card(struct lbs_private *p
 
 	if (!priv)
 		goto out;
+	dev = priv->dev;
 
-	netif_stop_queue(priv->dev);
-	netif_carrier_off(priv->dev);
+	netif_stop_queue(dev);
+	netif_carrier_off(dev);
 
 	lbs_debugfs_remove_one(priv);
 	if (priv->mesh_tlv) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-rtc-correct-an-error-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-mmc-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
drivers-scsi-move-a-dereference-below-a-null-test.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch


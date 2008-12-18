From: akpm@linux-foundation.org
Subject: + drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch added to -mm tree
Date: Thu, 18 Dec 2008 13:10:46 -0800
Message-ID: <200812182110.mBILAkJ9022077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbYLRVKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 16:10:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/net/hamradio/6pack.c: move a dereference below a NULL test
has been added to the -mm tree.  Its filename is
     drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch

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
Subject: drivers/net/hamradio/6pack.c: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/6pack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/hamradio/6pack.c~drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test
+++ a/drivers/net/hamradio/6pack.c
@@ -717,11 +717,12 @@ static int sixpack_ioctl(struct tty_stru
 	unsigned int cmd, unsigned long arg)
 {
 	struct sixpack *sp = sp_get(tty);
-	struct net_device *dev = sp->dev;
+	struct net_device *dev;
 	unsigned int tmp, err;
 
 	if (!sp)
 		return -ENXIO;
+	dev = sp->dev;
 
 	switch(cmd) {
 	case SIOCGIFNAME:
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


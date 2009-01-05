From: akpm@linux-foundation.org
Subject: - drivers-message-fusion-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Mon, 05 Jan 2009 01:26:33 -0800
Message-ID: <200901050926.n059QXaN008731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZAEJ0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 04:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/message/fusion: Move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-message-fusion-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/message/fusion: Move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptctl.c~drivers-message-fusion-move-a-dereference-below-a-null-test drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~drivers-message-fusion-move-a-dereference-below-a-null-test
+++ a/drivers/message/fusion/mptctl.c
@@ -308,10 +308,11 @@ static void mptctl_timeout_expired (MPT_
 {
 	int rc = 1;
 
-	dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
-				ioctl->ioc->name, ioctl->ioc->id));
 	if (ioctl == NULL)
 		return;
+	dctlprintk(ioctl->ioc,
+		   printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
+		   ioctl->ioc->name, ioctl->ioc->id));
 
 	ioctl->wait_done = 0;
 	if (ioctl->reset & MPTCTL_RESET_OK)
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
drivers-rtc-correct-an-error-test.patch


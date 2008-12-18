From: akpm@linux-foundation.org
Subject: + drivers-mmc-move-a-dereference-below-a-null-test.patch added to -mm tree
Date: Thu, 18 Dec 2008 13:10:44 -0800
Message-ID: <200812182110.mBILAi9H022052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbYLRVKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 16:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/mmc: move a dereference below a NULL test
has been added to the -mm tree.  Its filename is
     drivers-mmc-move-a-dereference-below-a-null-test.patch

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
Subject: drivers/mmc: move a dereference below a NULL test
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

 drivers/mmc/host/tmio_mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~drivers-mmc-move-a-dereference-below-a-null-test drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~drivers-mmc-move-a-dereference-below-a-null-test
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -224,7 +224,7 @@ static inline void tmio_mmc_data_irq(str
 {
 	void __iomem *ctl = host->ctl;
 	struct mmc_data *data = host->data;
-	struct mmc_command *stop = data->stop;
+	struct mmc_command *stop;
 
 	host->data = NULL;
 
@@ -232,6 +232,7 @@ static inline void tmio_mmc_data_irq(str
 		pr_debug("Spurious data end IRQ\n");
 		return;
 	}
+	stop = data->stop;
 
 	/* FIXME - return correct transfer count on errors */
 	if (!data->error)
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


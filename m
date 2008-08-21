From: akpm@linux-foundation.org
Subject: + e100-fix-iomap-read.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:00:30 -0700
Message-ID: <200808211900.m7LJ0UTE020753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbYHUTBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, bruce.w.allan@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com


The patch titled
     e100: fix iomap read
has been added to the -mm tree.  Its filename is
     e100-fix-iomap-read.patch

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
Subject: e100: fix iomap read
From: Jiri Slaby <jirislaby@gmail.com>

There were 2 omitted readb's used on an iomap space. eliminate them
by using ioread8 instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/e100.c~e100-fix-iomap-read drivers/net/e100.c
--- a/drivers/net/e100.c~e100-fix-iomap-read
+++ a/drivers/net/e100.c
@@ -1727,7 +1727,7 @@ static int e100_rx_indicate(struct nic *
 		if ((le16_to_cpu(rfd->command) & cb_el) &&
 		    (RU_RUNNING == nic->ru_running))
 
-			if (readb(&nic->csr->scb.status) & rus_no_res)
+			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
 		return -ENODATA;
 	}
@@ -1750,7 +1750,7 @@ static int e100_rx_indicate(struct nic *
 	if ((le16_to_cpu(rfd->command) & cb_el) &&
 	    (RU_RUNNING == nic->ru_running)) {
 
-	    if (readb(&nic->csr->scb.status) & rus_no_res)
+	    if (ioread8(&nic->csr->scb.status) & rus_no_res)
 		nic->ru_running = RU_SUSPENDED;
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
e100-fix-iomap-read.patch
ath5k-unify-resets.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
char-sx-remove-bogus-iomap.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


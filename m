From: akpm@linux-foundation.org
Subject: + tulip-de_stop_rxtx-polling-wrong.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:53:26 -0700
Message-ID: <200803101953.m2AJrQ26002591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637AbYCJTyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grundler@parisc-linux.org


The patch titled
     tulip: de_stop_rxtx() polling wrong
has been added to the -mm tree.  Its filename is
     tulip-de_stop_rxtx-polling-wrong.patch

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
Subject: tulip: de_stop_rxtx() polling wrong
From: Grant Grundler <grundler@parisc-linux.org>

This untested patch _should_ fix:

	"(net de2104x) Kernel panic with de2104x tulip driver on boot"
	http://bugzilla.kernel.org/show_bug.cgi?id=3156

But the bug submitter isn't responding.  Same fix has been applied to tulip.c
(several years ago) and uli526x.c (Feb 2008) drivers.

[ The panic reported in the bug report was removed in a recently
  (march 2008) accepted patch from Ondrej Zary. ]

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/de2104x.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/net/tulip/de2104x.c~tulip-de_stop_rxtx-polling-wrong drivers/net/tulip/de2104x.c
--- a/drivers/net/tulip/de2104x.c~tulip-de_stop_rxtx-polling-wrong
+++ a/drivers/net/tulip/de2104x.c
@@ -842,7 +842,7 @@ static inline int de_is_running (struct 
 static void de_stop_rxtx (struct de_private *de)
 {
 	u32 macmode;
-	unsigned int work = 1000;
+	unsigned int i = 1300/100;
 
 	macmode = dr32(MacMode);
 	if (macmode & RxTx) {
@@ -850,10 +850,14 @@ static void de_stop_rxtx (struct de_priv
 		dr32(MacMode);
 	}
 
-	while (--work > 0) {
+	/* wait until in-flight frame completes.
+	 * Max time @ 10BT: 1500*8b/10Mbps == 1200us (+ 100us margin)
+	 * Typically expect this loop to end in < 50 us on 100BT.
+	 */
+	while (--i) {
 		if (!de_is_running(de))
 			return;
-		cpu_relax();
+		udelay(100);
 	}
 
 	printk(KERN_WARNING "%s: timeout expired stopping DMA\n", de->dev->name);
_

Patches currently in -mm which might be from grundler@parisc-linux.org are

tulip-de_stop_rxtx-polling-wrong.patch
parisc-new-termios-definitions.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pci-iommu-iotlb-flushing.patch
pci-iommu-iotlb-flushing-speedup.patch


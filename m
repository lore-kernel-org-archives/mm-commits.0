From: akpm@linux-foundation.org
Subject: + w35und-remove-unused-code-from-wbsoft_configure_filter.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:35:47 -0700
Message-ID: <200904072135.n37LZlT8008727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514AbZDGViL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, greg@kroah.com, pavel@ucw.cz


The patch titled
     w35und: remove unused code from wbsoft_configure_filter()
has been added to the -mm tree.  Its filename is
     w35und-remove-unused-code-from-wbsoft_configure_filter.patch

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
Subject: w35und: remove unused code from wbsoft_configure_filter()
From: Pekka Enberg <penberg@cs.helsinki.fi>

We don't initialize hardware multicast filter in the driver nor do we know
how to do that.  Therefore, remove some code that isn't actually used from
wbsoft_configure_filter().

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/winbond/wbusb.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff -puN drivers/staging/winbond/wbusb.c~w35und-remove-unused-code-from-wbsoft_configure_filter drivers/staging/winbond/wbusb.c
--- a/drivers/staging/winbond/wbusb.c~w35und-remove-unused-code-from-wbsoft_configure_filter
+++ a/drivers/staging/winbond/wbusb.c
@@ -83,32 +83,14 @@ static void wbsoft_configure_filter(stru
 				     unsigned int *total_flags,
 				     int mc_count, struct dev_mc_list *mclist)
 {
-	unsigned int bit_nr, new_flags;
-	u32 mc_filter[2];
-	int i;
+	unsigned int new_flags;
 
 	new_flags = 0;
 
-	if (*total_flags & FIF_PROMISC_IN_BSS) {
+	if (*total_flags & FIF_PROMISC_IN_BSS)
 		new_flags |= FIF_PROMISC_IN_BSS;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32)) {
+	else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32))
 		new_flags |= FIF_ALLMULTI;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else {
-		mc_filter[1] = mc_filter[0] = 0;
-		for (i = 0; i < mc_count; i++) {
-			if (!mclist)
-				break;
-			printk("Should call ether_crc here\n");
-			//bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
-			bit_nr = 0;

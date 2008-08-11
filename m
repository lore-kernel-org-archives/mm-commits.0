From: akpm@linux-foundation.org
Subject: + pnp-make-the-resource-type-an-unsigned-long-fix.patch added to -mm tree
Date: Mon, 11 Aug 2008 15:28:05 -0700
Message-ID: <200808112228.m7BMS57S025039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYHKW3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 18:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, andi@firstfloor.org, bjorn.helgaas@hp.com, hpa@zytor.com, rene.herman@gmail.com


The patch titled
     PNP: resource type is now an unsigned long
has been added to the -mm tree.  Its filename is
     pnp-make-the-resource-type-an-unsigned-long-fix.patch

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
Subject: PNP: resource type is now an unsigned long
From: Rene Herman <rene.herman@keyaccess.nl>

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/quirks.c~pnp-make-the-resource-type-an-unsigned-long-fix drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-make-the-resource-type-an-unsigned-long-fix
+++ a/drivers/pnp/quirks.c
@@ -245,7 +245,7 @@ static void quirk_system_pci_resources(s
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			unsigned int type;
+			unsigned long type;
 
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

i2c-dont-autograb-i2c-pca-is.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch


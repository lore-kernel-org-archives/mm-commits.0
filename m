From: akpm@linux-foundation.org
Subject: + acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information.patch added to -mm tree
Date: Mon, 21 Jun 2010 14:56:08 -0700
Message-ID: <201006212156.o5LLu86x007209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932513Ab0FUV45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 17:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rkc@chromium.org, andi@lisas.de, lenb@kernel.org, mjg@redhat.com, peter@piie.net, petkovbb@gmail.com


The patch titled
     acerhdf: driver didn't verify the pointers in which it got product information
has been added to the -mm tree.  Its filename is
     acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information.patch

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
Subject: acerhdf: driver didn't verify the pointers in which it got product information
From: Rahul Chaturvedi <rkc@chromium.org>

Driver didn't verify the pointers in which it got product information back
from DMI; on QEMU one of the pointers came back null, which made the
driver crash and subsequently caused a kernel panic.

Signed-off-by: Rahul Chaturvedi <rkc@chromium.org>
Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information
+++ a/drivers/platform/x86/acerhdf.c
@@ -524,6 +524,10 @@ static int acerhdf_check_hardware(void)
 	version = dmi_get_system_info(DMI_BIOS_VERSION);
 	product = dmi_get_system_info(DMI_PRODUCT_NAME);
 
+	if (!vendor || !version || !product) {
+		pr_err("error getting hardware information\n");
+		return -EINVAL;
+	}
 
 	pr_info("Acer Aspire One Fan driver, v.%s\n", DRV_VER);
 
_

Patches currently in -mm which might be from rkc@chromium.org are

acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information.patch


From: akpm@linux-foundation.org
Subject: + acerhdf-limit-modalias-matching-to-supported.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:44:47 -0800
Message-ID: <200912032244.nB3MilMG004419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbZLCWp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefan.bader@canonical.com, lenb@kernel.org, peter@piie.net, petkovbb@gmail.com, stable@kernel.org


The patch titled
     acerhdf: limit modalias matching to supported
has been added to the -mm tree.  Its filename is
     acerhdf-limit-modalias-matching-to-supported.patch

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
Subject: acerhdf: limit modalias matching to supported
From: Stefan Bader <stefan.bader@canonical.com>

BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958

The module alias currently matches any Acer computer but when loaded the
BIOS checks will only succeed on Aspire One models.  This causes a invalid
BIOS warning for all other models (seen on Aspire 4810T).  This is not
fatal but worries users that see this message.  Limiting the moule alias
to models starting with AOA or DOA for Packard Bell.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Acked-by: Peter Feuerer <peter@piie.net>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-limit-modalias-matching-to-supported drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-limit-modalias-matching-to-supported
+++ a/drivers/platform/x86/acerhdf.c
@@ -640,9 +640,10 @@ static void __exit acerhdf_exit(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
-MODULE_ALIAS("dmi:*:*Acer*:*:");
-MODULE_ALIAS("dmi:*:*Gateway*:*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
_

Patches currently in -mm which might be from stefan.bader@canonical.com are

acerhdf-limit-modalias-matching-to-supported.patch


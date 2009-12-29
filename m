From: akpm@linux-foundation.org
Subject: [merged] acerhdf-limit-modalias-matching-to-supported.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:02 -0800
Message-ID: <200912292132.nBTLW2Y8008596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbZL2Vcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan.bader@canonical.com, lenb@kernel.org, peter@piie.net, petkovbb@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acerhdf: limit modalias matching to supported
has been removed from the -mm tree.  Its filename was
     acerhdf-limit-modalias-matching-to-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch


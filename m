From: akpm@linux-foundation.org
Subject: + acpi-fix-overflow.patch added to -mm tree
Date: Fri, 29 Feb 2008 00:47:51 -0800
Message-ID: <200802290847.m1T8lqQS014068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbYB2Irz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 03:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.m.lin@intel.com, rui.zhang@intel.com


The patch titled
     acpi: fix overflow
has been added to the -mm tree.  Its filename is
     acpi-fix-overflow.patch

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
Subject: acpi: fix overflow
From: Lin Ming <ming.m.lin@intel.com>

Fix a memory overflow bug when copying NULL internal package element object to
external.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/utilities/utobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/utilities/utobject.c~acpi-fix-overflow drivers/acpi/utilities/utobject.c
--- a/drivers/acpi/utilities/utobject.c~acpi-fix-overflow
+++ a/drivers/acpi/utilities/utobject.c
@@ -432,7 +432,7 @@ acpi_ut_get_simple_object_size(union acp
 	 * element -- which is legal)
 	 */
 	if (!internal_object) {
-		*obj_length = 0;
+		*obj_length = sizeof(union acpi_object);
 		return_ACPI_STATUS(AE_OK);
 	}
 
_

Patches currently in -mm which might be from ming.m.lin@intel.com are

acpi-fix-overflow.patch


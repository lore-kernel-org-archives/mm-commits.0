From: akpm@linux-foundation.org
Subject: - acpi-fix-overflow.patch removed from -mm tree
Date: Thu, 13 Mar 2008 12:00:06 -0700
Message-ID: <200803131900.m2DJ06S7028030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbYCMTAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.m.lin@intel.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: fix overflow
has been removed from the -mm tree.  Its filename was
     acpi-fix-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-acpi.patch


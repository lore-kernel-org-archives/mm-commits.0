From: akpm@linux-foundation.org
Subject: - acpi-suspend-execute-_wak-with-the-right-argument.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:41 -0500
Message-ID: <200802150227.m1F2R0Ug015274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760438AbYBOC3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:29:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, mt-ml@gmx.de, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     ACPI suspend: execute _WAK with the right argument
has been removed from the -mm tree.  Its filename was
     acpi-suspend-execute-_wak-with-the-right-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI suspend: execute _WAK with the right argument
From: Rafael J. Wysocki <rjw@sisk.pl>

The _WAK global ACPI control method has to be called with the
argument representing the sleep state being exited.  Make it happen.

Special thanks to Mirco Tischler for reporting the problem and debugging.

Reported-by: Mirco Tischler <mt-ml@gmx.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Mirco Tischler <mt-ml@gmx.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/hardware/hwsleep.c~acpi-suspend-execute-_wak-with-the-right-argument drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c~acpi-suspend-execute-_wak-with-the-right-argument
+++ a/drivers/acpi/hardware/hwsleep.c
@@ -616,6 +616,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		return_ACPI_STATUS(status);
 	}
 
+	arg.integer.value = sleep_state;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
shrink_slab-handle-bad-shrinkers.patch

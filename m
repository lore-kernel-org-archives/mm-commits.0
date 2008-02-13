From: akpm@linux-foundation.org
Subject: + acpi-suspend-execute-_wak-with-the-right-argument.patch added to -mm tree
Date: Tue, 12 Feb 2008 16:08:45 -0800
Message-ID: <200802130008.m1D08jdn030197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbYBMAJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 19:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, mt-ml@gmx.de, pavel@ucw.cz


The patch titled
     ACPI suspend: execute _WAK with the right argument
has been added to the -mm tree.  Its filename is
     acpi-suspend-execute-_wak-with-the-right-argument.patch

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

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
git-x86.patch
git-xfs.patch
acpi-suspend-execute-_wak-with-the-right-argument.patch
shrink_slab-handle-bad-shrinkers.patch

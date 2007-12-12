From: akpm@linux-foundation.org
Subject: + acpi-sbs-reset-alarm-bit.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:44:37 -0800
Message-ID: <200712120544.lBC5ibGb028085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbXLLFoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:44:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     ACPI: SBS: Reset alarm bit
has been added to the -mm tree.  Its filename is
     acpi-sbs-reset-alarm-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: SBS: Reset alarm bit
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Alarm bit should be cleared in order for other alarms to be sent.
Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9362

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbshc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/sbshc.c~acpi-sbs-reset-alarm-bit drivers/acpi/sbshc.c
--- a/drivers/acpi/sbshc.c~acpi-sbs-reset-alarm-bit
+++ a/drivers/acpi/sbshc.c
@@ -222,6 +222,7 @@ static int smbus_alarm(void *context)
 	if (!status.fields.alarm)
 		return 0;
 	mutex_lock(&hc->lock);
+	status.fields.alarm = 0;
 	smb_hc_write(hc, ACPI_SMB_STATUS, status.raw);
 	if (hc->callback)
 		acpi_os_execute(OSL_GPE_HANDLER, acpi_smbus_callback, hc);
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

git-acpi.patch
acpi-sbs-reset-alarm-bit.patch
acpi-sbs-ignore-alarms-coming-from-unknown-devices.patch
acpi-sbs-return-rate-in-mw-if-capacity-in-mwh.patch

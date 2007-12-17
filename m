From: akpm@linux-foundation.org
Subject: - acpi-sbs-reset-alarm-bit.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:41:16 -0800
Message-ID: <200712172341.lBHNfG5H008374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762825AbXLQXwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: astarikovskiy@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: SBS: Reset alarm bit
has been removed from the -mm tree.  Its filename was
     acpi-sbs-reset-alarm-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch

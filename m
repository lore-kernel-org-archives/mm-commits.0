From: akpm@linux-foundation.org
Subject: + acpi_power_meter-dont-leak-acpi-error-codes-to-userspace.patch added to -mm tree
Date: Tue, 03 Nov 2009 15:50:37 -0800
Message-ID: <200911032350.nA3Nobjh022628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbZKCXvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 18:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org, lenb@kernel.org


The patch titled
     acpi_power_meter: don't leak ACPI error codes to userspace
has been added to the -mm tree.  Its filename is
     acpi_power_meter-dont-leak-acpi-error-codes-to-userspace.patch

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
Subject: acpi_power_meter: don't leak ACPI error codes to userspace
From: "Darrick J. Wong" <djwong@us.ibm.com>

If the ACPI methods return an error code, we must return -EINVAL to
userspace to flag the error.  Right now we pass the (positive) number
right through, which causes echo to keep writing bogus values.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/acpi/power_meter.c~acpi_power_meter-dont-leak-acpi-error-codes-to-userspace drivers/acpi/power_meter.c
--- a/drivers/acpi/power_meter.c~acpi_power_meter-dont-leak-acpi-error-codes-to-userspace
+++ a/drivers/acpi/power_meter.c
@@ -294,7 +294,11 @@ static int set_acpi_trip(struct acpi_pow
 		return -EINVAL;
 	}
 
-	return data;
+	/* _PTP returns 0 on success, nonzero otherwise */
+	if (data)
+		return -EINVAL;
+
+	return 0;
 }
 
 static ssize_t set_trip(struct device *dev, struct device_attribute *devattr,
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
acpi_power_meter-dont-leak-acpi-error-codes-to-userspace.patch


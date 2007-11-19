From: akpm@linux-foundation.org
Subject: - acpi-expose-_sun-in-proc-acpi-processor-info.patch removed from -mm tree
Date: Mon, 19 Nov 2007 13:02:48 -0800
Message-ID: <200711192102.lAJL2p9F028886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbXKSVCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 16:02:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, mm-commits@vger.kernel.org


The patch titled
     acpi: expose _SUN in /proc/acpi/processor/<...>/info
has been removed from the -mm tree.  Its filename was
     acpi-expose-_sun-in-proc-acpi-processor-info.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: acpi: expose _SUN in /proc/acpi/processor/<...>/info
From: Alex Chiang <achiang@hp.com>

On platforms that provide _SUN for the processor object, higher
level software can consume the data to learn physical topology
information, so let's expose it.

Platforms that do not implement _SUN will see <not supported>.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |   11 +++++++++++
 include/acpi/processor.h      |    1 +
 2 files changed, 12 insertions(+)

diff -puN drivers/acpi/processor_core.c~acpi-expose-_sun-in-proc-acpi-processor-info drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-expose-_sun-in-proc-acpi-processor-info
+++ a/drivers/acpi/processor_core.c
@@ -302,6 +302,11 @@ static int acpi_processor_info_seq_show(
 		   pr->flags.throttling ? "yes" : "no",
 		   pr->flags.limit ? "yes" : "no");
 
+	if (pr->sun == -1)
+		seq_printf(seq, "slot user number:        <not supported>\n");
+	else
+		seq_printf(seq, "slot user number:        %d\n", (int)pr->sun);
+
       end:
 	return 0;
 }
@@ -590,6 +595,12 @@ static int acpi_processor_get_info(struc
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Processor [%d:%d]\n", pr->id,
 			  pr->acpi_id));
 
+	status = acpi_evaluate_object(pr->handle, "_SUN", NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		object.integer.value = -1;
+
+	pr->sun = object.integer.value;
+
 	if (!object.processor.pblk_address)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
 	else if (object.processor.pblk_length != 6)
diff -puN include/acpi/processor.h~acpi-expose-_sun-in-proc-acpi-processor-info include/acpi/processor.h
--- a/include/acpi/processor.h~acpi-expose-_sun-in-proc-acpi-processor-info
+++ a/include/acpi/processor.h
@@ -210,6 +210,7 @@ struct acpi_processor {
 	u32 acpi_id;
 	u32 id;
 	u32 pblk;
+	acpi_native_int sun;
 	int performance_platform_limit;
 	int throttling_platform_limit;
 	/* 0 - states 0..n-th state available */
_

Patches currently in -mm which might be from achiang@hp.com are

acpi-expose-_sun-in-proc-acpi-processor-info.patch

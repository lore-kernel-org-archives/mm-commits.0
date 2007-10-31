From: akpm@linux-foundation.org
Subject: + acpi-expose-_sun-in-proc-acpi-processor-info.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:34:28 -0700
Message-ID: <200710312134.l9VLYSfF029893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbXJaVec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com


The patch titled
     acpi: expose _SUN in /proc/acpi/processor/<...>/info
has been added to the -mm tree.  Its filename is
     acpi-expose-_sun-in-proc-acpi-processor-info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

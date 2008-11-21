From: akpm@linux-foundation.org
Subject: + acpi-check-_pss-invalidation-when-bios-report-_pss-with-all-0x80000000.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:08:43 -0800
Message-ID: <200811212308.mALN8hN8014000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757201AbYKUXIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: youquan.song@intel.com, lenb@kernel.org, venkatesh.pallipadi@intel.com


The patch titled
     acpi: check _PSS invalidation when BIOS report _PSS with 0x80000000
has been added to the -mm tree.  Its filename is
     acpi-check-_pss-invalidation-when-bios-report-_pss-with-all-0x80000000.patch

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
Subject: acpi: check _PSS invalidation when BIOS report _PSS with 0x80000000
From: youquan_song@linux.intel.com

When cpu frequencey scaling is disabled, some BIOSes report _PSS with all
0x80000000.  If the kernel treats this case as valid, the kernel will boot
crash when load cpufreq govenors.

So in order to cover more buggy BIOSs, the patch just check _PSS core
frequency invalidation.

Signed-off-by: Youquan, Song <youquan.song@intel.com>
Signed-off-by: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_perflib.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/acpi/processor_perflib.c~acpi-check-_pss-invalidation-when-bios-report-_pss-with-all-0x80000000 drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~acpi-check-_pss-invalidation-when-bios-report-_pss-with-all-0x80000000
+++ a/drivers/acpi/processor_perflib.c
@@ -50,6 +50,7 @@
 #define ACPI_PROCESSOR_CLASS		"processor"
 #define ACPI_PROCESSOR_FILE_PERFORMANCE	"performance"
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
+#define ACPI_PROCESSOR_PSS_INVALID	0x80000000
 ACPI_MODULE_NAME("processor_perflib");
 
 static DEFINE_MUTEX(performance_mutex);
@@ -324,6 +325,14 @@ static int acpi_processor_get_performanc
 			kfree(pr->performance->states);
 			goto end;
 		}
+
+		if (px->core_frequency == ACPI_PROCESSOR_PSS_INVALID) {
+			printk(KERN_ERR PREFIX
+				    "P-states disabled in the BIOS\n");
+			result = -EFAULT;
+			kfree(pr->performance->states);
+			goto end;
+		}
 	}
 
       end:
_

Patches currently in -mm which might be from youquan.song@intel.com are

acpi-check-_pss-invalidation-when-bios-report-_pss-with-all-0x80000000.patch


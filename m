From: akpm@linux-foundation.org
Subject: + acpi_pad-processor_aggregator-name-too-long.patch added to -mm tree
Date: Wed, 31 Mar 2010 12:47:12 -0700
Message-ID: <201003311947.o2VJlChF004616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756585Ab0CaTrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 15:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, lenb@kernel.org, pavel@ucw.cz, shaohua.li@intel.com, wharms@bfs.de


The patch titled
     acpi_pad: "processor_aggregator" name too long
has been added to the -mm tree.  Its filename is
     acpi_pad-processor_aggregator-name-too-long.patch

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
Subject: acpi_pad: "processor_aggregator" name too long
From: Dan Carpenter <error27@gmail.com>

cpi_device_class can only be 19 characters and a NULL terminator.

With the current name we get a buffer overflow in acpi_pad_add()
	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: walter harms <wharms@bfs.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_pad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/acpi_pad.c~acpi_pad-processor_aggregator-name-too-long drivers/acpi/acpi_pad.c
--- a/drivers/acpi/acpi_pad.c~acpi_pad-processor_aggregator-name-too-long
+++ a/drivers/acpi/acpi_pad.c
@@ -31,7 +31,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"processor_aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"cpu_aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch


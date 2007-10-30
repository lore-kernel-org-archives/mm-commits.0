From: akpm@linux-foundation.org
Subject: - make-smart-battery-system-depend-on-acpi_sbs.patch removed from -mm tree
Date: Mon, 29 Oct 2007 22:08:34 -0700
Message-ID: <200710300508.l9U58Yg7010249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990AbXJ3FJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 01:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, astarikovskiy@suse.de, cbou@mail.ru, lenb@kernel.org, vladimir.p.lebedev@intel.com, mm-commits@vger.kernel.org


The patch titled
     Make Smart Battery System depend on ACPI_SBS ACPI_PROC_EVENT
has been removed from the -mm tree.  Its filename was
     make-smart-battery-system-depend-on-acpi_sbs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Make Smart Battery System depend on ACPI_SBS ACPI_PROC_EVENT
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>

Playing with the latest -mm kernel I stumbled upon the following compile
error:

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
  LD      drivers/acpi/built-in.o
  LD [M]  drivers/acpi/processor.o
  CC [M]  drivers/acpi/sbs.o
drivers/acpi/sbs.c: In function 'acpi_battery_add':
drivers/acpi/sbs.c:825: warning: ignoring return value of 'device_create_file',\
 declared with attribute warn_unused_result
drivers/acpi/sbs.c: In function 'acpi_sbs_callback':
drivers/acpi/sbs.c:898: error: implicit declaration of function 'acpi_bus_gener\
ate_proc_event4'
make[2]: *** [drivers/acpi/sbs.o] Error 1
make[1]: *** [drivers/acpi] Error 2
make: *** [drivers] Error 2

The problem turned out to be that the sbs module is still using
acpi_bus_generate_proc_event4(), which is part of the deprecated
/proc/acpi/event interface.  This patch makes this dependency explicit.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Len Brown <lenb@kernel.org>
Cc: <astarikovskiy@suse.de>
Cc: <vladimir.p.lebedev@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/Kconfig~make-smart-battery-system-depend-on-acpi_sbs drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~make-smart-battery-system-depend-on-acpi_sbs
+++ a/drivers/acpi/Kconfig
@@ -353,6 +353,7 @@ config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
 	depends on POWER_SUPPLY
+	depends on ACPI_PROC_EVENT
 	help
 	  This driver adds support for the Smart Battery System, another
 	  type of access to battery information, found on some laptops.
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

make-smart-battery-system-depend-on-acpi_sbs.patch

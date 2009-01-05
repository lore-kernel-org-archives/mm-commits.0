From: akpm@linux-foundation.org
Subject: + drivers-acpi-hardware-hwsleepc-fix-warning-msg.patch added to -mm tree
Date: Sun, 04 Jan 2009 23:23:25 -0800
Message-ID: <200901050723.n057NPZF006789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZAEHYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 02:24:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: valdis.kletnieks@vt.edu, lenb@kernel.org


The patch titled
     drivers/acpi/hardware/hwsleep.c: fix warning msg
has been added to the -mm tree.  Its filename is
     drivers-acpi-hardware-hwsleepc-fix-warning-msg.patch

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
Subject: drivers/acpi/hardware/hwsleep.c: fix warning msg
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

In mmotm1230 the linux.next patch, most likely via this commit:

commit ecd196686aee5028f71ee09072c8581c7293a847
Author: Len Brown <len.brown=40intel.com>
Date:   Fri Dec 19 03:53:37 2008 -0500

    ACPICA: disable ACPI 2.0 _GTS/_BFS support

added some warning messages:

  CC      drivers/acpi/hardware/hwsleep.o
drivers/acpi/hardware/hwsleep.c: In function`acpi_enter_sleep_state':
drivers/acpi/hardware/hwsleep.c:231: warning: unused variable`arg'
drivers/acpi/hardware/hwsleep.c:230: warning: unused variable`arg_list'
drivers/acpi/hardware/hwsleep.c: In function`acpi_leave_sleep_state_prep':
drivers/acpi/hardware/hwsleep.c:471: warning: unused variable`arg'
drivers/acpi/hardware/hwsleep.c:470: warning: unused variable`arg_list'

If we're going to ifdef-wrap the code, let's do the variables involved
as well, so we don't get warnings.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/acpi/hardware/hwsleep.c~drivers-acpi-hardware-hwsleepc-fix-warning-msg drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c~drivers-acpi-hardware-hwsleepc-fix-warning-msg
+++ a/drivers/acpi/hardware/hwsleep.c
@@ -227,8 +227,10 @@ acpi_status asmlinkage acpi_enter_sleep_
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 in_value;
+#ifdef	ACPI_20_GTS_BFS
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
+#endif
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
@@ -467,8 +469,10 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
  ******************************************************************************/
 acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 {
+#ifdef	ACPI_20_GTS_BFS
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
+#endif
 	acpi_status status;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch
drivers-acpi-hardware-hwsleepc-fix-warning-msg.patch


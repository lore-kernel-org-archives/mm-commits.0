From: akpm@google.com
Subject: + acpi-fix-possible-recursive-locking-in-hwregsc.patch added to -mm tree
Date: Wed, 21 Sep 2011 15:36:18 -0700
Message-ID: <201109212236.p8LMaJOY031254@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:35641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1IUWhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2011 18:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, len.brown@intel.com, lenb@kernel.org


The patch titled
     Subject: acpi: fix possible recursive locking in hwregs.c
has been added to the -mm tree.  Its filename is
     acpi-fix-possible-recursive-locking-in-hwregsc.patch

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
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: acpi: fix possible recursive locking in hwregs.c

Calling pm-suspend triggers a recursive lock.  In function
acpi_hw_clear_acpi_status(), acpi_os_release_lock() holds the lock
acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then
without releasing acpi_gbl_hardware_lock, this function calls
acpi_ev_walk_gpe_list(), which also tries to hold acpi_gbl_hardware_lock and
thus causes a recursive lock.

Fix this by releasing acpi_gbl_hardware_lock before calling
acpi_ev_walk_gpe_list().

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/acpi/acpica/hwregs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/acpica/hwregs.c~acpi-fix-possible-recursive-locking-in-hwregsc drivers/acpi/acpica/hwregs.c
--- a/drivers/acpi/acpica/hwregs.c~acpi-fix-possible-recursive-locking-in-hwregsc
+++ a/drivers/acpi/acpica/hwregs.c
@@ -269,6 +269,9 @@ acpi_status acpi_hw_clear_acpi_status(vo
 
 	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
 					ACPI_BITMASK_ALL_FIXED_STATUS);
+
+	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+
 	if (ACPI_FAILURE(status)) {
 		goto unlock_and_exit;
 	}
@@ -278,7 +281,6 @@ acpi_status acpi_hw_clear_acpi_status(vo
 	status = acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
 
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
_
Subject: Subject: acpi: fix possible recursive locking in hwregs.c

Patches currently in -mm which might be from rakib.mullick@gmail.com are

acpi-fix-possible-recursive-locking-in-hwregsc.patch


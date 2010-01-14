From: akpm@linux-foundation.org
Subject: + acpi-fix-section-mismatch.patch added to -mm tree
Date: Wed, 13 Jan 2010 17:03:25 -0800
Message-ID: <201001140103.o0E13PJK007119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab0ANBEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 20:04:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, achiang@hp.com, lenb@kernel.org, tony.luck@intel.com


The patch titled
     acpi: fix section mismatch
has been added to the -mm tree.  Its filename is
     acpi-fix-section-mismatch.patch

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
Subject: acpi: fix section mismatch
From: Jeff Mahoney <jeffm@suse.com>

acpi_early_processor_set_pdc() uses processor_idle_dmi_table(), which is
marked __cpuinitdata.  It's only called by acpi_bus_init, which is __init.
We mark it __cpuinit.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Alex Chiang <achiang@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_pdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_pdc.c~acpi-fix-section-mismatch drivers/acpi/processor_pdc.c
--- a/drivers/acpi/processor_pdc.c~acpi-fix-section-mismatch
+++ a/drivers/acpi/processor_pdc.c
@@ -151,7 +151,7 @@ early_init_pdc(acpi_handle handle, u32 l
 	return AE_OK;
 }
 
-void acpi_early_processor_set_pdc(void)
+void __cpuinit acpi_early_processor_set_pdc(void)
 {
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
_

Patches currently in -mm which might be from jeffm@suse.com are

acpi-fix-section-mismatch.patch
hugetlb-fix-section-mismatches-2.patch


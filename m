From: akpm@linux-foundation.org
Subject: + acpi-fix-buggy-bios-check-when-cpus-are-hot-removed.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:02:52 -0700
Message-ID: <200804080702.m3872qrk013363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbYDHHDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akataria@vmware.com, arai@vmware.com, lenb@kernel.org, stable@kernel.org


The patch titled
     acpi: fix "buggy BIOS check" when CPUs are hot removed
has been added to the -mm tree.  Its filename is
     acpi-fix-buggy-bios-check-when-cpus-are-hot-removed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix "buggy BIOS check" when CPUs are hot removed
From: Alok Kataria <akataria@vmware.com>

Fixes a BUG in ACPI hotplugging.

processor_device_array[pr->id] needs to be set to NULL when removing a CPU. 
Else the "buggy BIOS check" in acpi_processor_start mistakenly fires when a
CPU is removed from the system and then later re-added.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Arai <arai@vmware.com>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_core.c~acpi-fix-buggy-bios-check-when-cpus-are-hot-removed drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-fix-buggy-bios-check-when-cpus-are-hot-removed
+++ a/drivers/acpi/processor_core.c
@@ -822,7 +822,7 @@ static int acpi_processor_remove(struct 
 	}
 
 	processors[pr->id] = NULL;

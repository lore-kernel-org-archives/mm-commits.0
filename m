From: akpm@linux-foundation.org
Subject: - acpi-fix-buggy-bios-check-when-cpus-are-hot-removed.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:00:57 -0700
Message-ID: <200804102000.m3AK0veA014932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756466AbYDJUBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akataria@vmware.com, arai@vmware.com, lenb@kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix "buggy BIOS check" when CPUs are hot removed
has been removed from the -mm tree.  Its filename was
     acpi-fix-buggy-bios-check-when-cpus-are-hot-removed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

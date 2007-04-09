From: akpm@linux-foundation.org
Subject: + acpi-processor_idlec-remove-duplicate-include.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:08:53 -0700
Message-ID: <200704091908.l39J8rh5020941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXDITKJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ray-lk@madrabbit.org, lenb@kernel.org


The patch titled
     acpi/processor_idle.c: remove duplicate include
has been added to the -mm tree.  Its filename is
     acpi-processor_idlec-remove-duplicate-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi/processor_idle.c: remove duplicate include
From: Ray Lee <ray-lk@madrabbit.org>

Thomas's patch for including <asm/apic.h> for x86 UP builds came into
Linus's tree from two different directions, both of which were merged. 
This reverts the latter, yanking out the duplicate #include and comment.

Signed-off-by: Ray Lee <ray-lk@madrabbit.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    8 --------
 1 files changed, 8 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-processor_idlec-remove-duplicate-include drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-processor_idlec-remove-duplicate-include
+++ a/drivers/acpi/processor_idle.c
@@ -52,14 +52,6 @@
 #include <asm/apic.h>
 #endif
 
-/*
- * Include the apic definitions for x86 to have the APIC timer related defines
- * available also for UP (on SMP it gets magically included via linux/smp.h).
- */
-#ifdef CONFIG_X86
-#include <asm/apic.h>
-#endif
-
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
_

Patches currently in -mm which might be from ray-lk@madrabbit.org are

acpi-processor_idlec-remove-duplicate-include.patch

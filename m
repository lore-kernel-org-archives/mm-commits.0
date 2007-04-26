From: akpm@linux-foundation.org
Subject: - acpi-processor_idlec-remove-duplicate-include.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:16 -0700
Message-ID: <200704260659.l3Q6xGGx023127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933223AbXDZHAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ray-lk@madrabbit.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi/processor_idle.c: remove duplicate include
has been removed from the -mm tree.  Its filename was
     acpi-processor_idlec-remove-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-acpi.patch

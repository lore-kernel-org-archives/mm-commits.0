From: akpm@linux-foundation.org
Subject: [merged]
 x86-amd_gart-print-stacktrace-for-a-leak-with-kern_err.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:38:26 -0700
Message-ID: <20200610003826.QF0sAHjZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgFJAi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, dima@arista.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: x86/amd_gart: print stacktrace for a leak with KERN_ERR
has been removed from the -mm tree.  Its filename was
     x86-amd_gart-print-stacktrace-for-a-leak-with-kern_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: x86/amd_gart: print stacktrace for a leak with KERN_ERR

It's under CONFIG_IOMMU_LEAK option which is enabled by debug config. 
Likely the backtrace is worth to be seen - so aligning with log level of
error message in iommu_full().

Link: http://lkml.kernel.org/r/20200418201944.482088-46-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_gart_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_gart_64.c~x86-amd_gart-print-stacktrace-for-a-leak-with-kern_err
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -159,7 +159,7 @@ static void dump_leak(void)
 		return;
 	dump = 1;
 
-	show_stack(NULL, NULL);
+	show_stack_loglvl(NULL, NULL, KERN_ERR);
 	debug_dma_dump_mappings(NULL);
 }
 #endif
_

Patches currently in -mm which might be from dima@arista.com are

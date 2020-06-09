From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 45/93] x86/amd_gart: print stacktrace for a leak
 with KERN_ERR
Date: Mon, 08 Jun 2020 21:32:13 -0700
Message-ID: <20200609043213.Ov2lIaOay%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:15 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, dima@arista.com, hpa@zytor.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

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

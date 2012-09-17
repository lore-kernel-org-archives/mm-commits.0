From: akpm@linux-foundation.org
Subject: [merged] x86-mm-initc-devmem_is_allowed-off-by-one.patch removed from -mm tree
Date: Mon, 17 Sep 2012 11:37:14 -0700
Message-ID: <20120917183715.229315C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55217 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2IQShR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 14:37:17 -0400
Received: by wibhr14 with SMTP id hr14so145821wib.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 11:37:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tmac@hp.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm/init.c: devmem_is_allowed() off by one
has been removed from the -mm tree.  Its filename was
     x86-mm-initc-devmem_is_allowed-off-by-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: T Makphaibulchoke <tmac@hp.com>
Subject: x86/mm/init.c: devmem_is_allowed() off by one

Fix an off-by-one error in devmem_is_allowed(), which allows accesses to
physical addresses 0x100000-0x100fff, an extra page past 1MB.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/init.c~x86-mm-initc-devmem_is_allowed-off-by-one arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-initc-devmem_is_allowed-off-by-one
+++ a/arch/x86/mm/init.c
@@ -319,7 +319,7 @@ unsigned long __init_refok init_memory_m
  */
 int devmem_is_allowed(unsigned long pagenr)
 {
-	if (pagenr <= 256)
+	if (pagenr < 256)
 		return 1;
 	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
 		return 0;
_

Patches currently in -mm which might be from tmac@hp.com are

linux-next.patch
kernel-resourcec-fix-stack-overflow-in-__reserve_region_with_split.patch


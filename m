From: akpm@linux-foundation.org
Subject: - use-correct-macros-in-raid-code-not-raw-asm.patch removed from -mm tree
Date: Thu, 08 Feb 2007 17:44:33 -0800
Message-ID: <200702090144.l191iXMt001364@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946010AbXBIBow (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 20:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@muc.de, mingo@elte.hu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use correct macros in raid code, not raw asm
has been removed from the -mm tree.  Its filename was
     use-correct-macros-in-raid-code-not-raw-asm.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Use correct macros in raid code, not raw asm
From: Rusty Russell <rusty@rustcorp.com.au>

This make sure it's paravirtualized correctly when CONFIG_PARAVIRT=y.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@muc.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid6x86.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid6x86.h~use-correct-macros-in-raid-code-not-raw-asm drivers/md/raid6x86.h
--- a/drivers/md/raid6x86.h~use-correct-macros-in-raid-code-not-raw-asm
+++ a/drivers/md/raid6x86.h
@@ -21,6 +21,8 @@
 
 #if defined(__i386__) || defined(__x86_64__)
 
+#include <asm/system.h>
+
 #ifdef __x86_64__
 
 typedef struct {
@@ -75,13 +77,14 @@ static inline unsigned long raid6_get_fp
 	unsigned long cr0;
 
 	preempt_disable();
-	asm volatile("mov %%cr0,%0 ; clts" : "=r" (cr0));
+	cr0 = read_cr0();
+	clts();
 	return cr0;
 }
 
 static inline void raid6_put_fpu(unsigned long cr0)
 {
-	asm volatile("mov %0,%%cr0" : : "r" (cr0));
+	write_cr0(cr0);
 	preempt_enable();
 }
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

use-correct-macros-in-raid-code-not-raw-asm.patch
vmi-versus-hrtimers.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch

From: akpm@linux-foundation.org
Subject: - kvm-fix-asm-constraint-for-lldt-instruction.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:41 -0800
Message-ID: <200702122248.l1CMmft9014042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030398AbXBLWud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, avi@qumranet.com, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kvm: Fix asm constraint for lldt instruction
has been removed from the -mm tree.  Its filename was
     kvm-fix-asm-constraint-for-lldt-instruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: Fix asm constraint for lldt instruction
From: S.Caglar Onur <caglar@pardus.org.tr>

lldt does not accept immediate operands, which "g" allows.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/kvm.h~kvm-fix-asm-constraint-for-lldt-instruction drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-fix-asm-constraint-for-lldt-instruction
+++ a/drivers/kvm/kvm.h
@@ -558,7 +558,7 @@ static inline void load_gs(u16 sel)
 #ifndef load_ldt
 static inline void load_ldt(u16 sel)
 {
-	asm ("lldt %0" : : "g"(sel));
+	asm ("lldt %0" : : "rm"(sel));
 }
 #endif
 
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

origin.patch

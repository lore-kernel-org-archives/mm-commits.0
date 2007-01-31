From: akpm@osdl.org
Subject: + kvm-fix-asm-constraint-for-lldt-instruction.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:37 -0800
Message-ID: <200701310036.l0V0abnE002548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58814 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbXAaAhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: Fix asm constraint for lldt instruction
has been added to the -mm tree.  Its filename is
     kvm-fix-asm-constraint-for-lldt-instruction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: Fix asm constraint for lldt instruction
From: S.Caglar Onur <caglar@pardus.org.tr>

lldt does not accept immediate operands, which "g" allows.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

kvm-fix-asm-constraint-for-lldt-instruction.patch

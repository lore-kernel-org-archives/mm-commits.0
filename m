From: akpm@linux-foundation.org
Subject: - add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:05 -0700
Message-ID: <200710180657.l9I6v5ue030760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760340AbXJRHPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     add-vmcore: use the existing ia64_tpa() instead of asm code
has been removed from the -mm tree.  Its filename was
     add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add-vmcore: use the existing ia64_tpa() instead of asm code
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/machine_kexec.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/machine_kexec.c~add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -21,6 +21,7 @@
 #include <asm/setup.h>
 #include <asm/delay.h>
 #include <asm/meminit.h>
+#include <asm/processor.h>
 
 typedef NORET_TYPE void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
@@ -145,9 +146,6 @@ void arch_crash_save_vmcoreinfo(void)
 
 unsigned long paddr_vmcoreinfo_note(void)
 {
-	unsigned long vaddr, paddr;
-	vaddr = (unsigned long)(char *)&vmcoreinfo_note;
-	asm volatile ("tpa %0 = %1" : "=r"(paddr) : "r"(vaddr) : "memory");
-	return paddr;
+	return ia64_tpa((unsigned long)(char *)&vmcoreinfo_note);
 }
 
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch

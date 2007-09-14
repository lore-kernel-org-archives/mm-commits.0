From: akpm@linux-foundation.org
Subject: + add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:00:08 -0700
Message-ID: <200709140100.l8E108FO014440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbXINBAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp


The patch titled
     add-vmcore: use the existing ia64_tpa() instead of asm code
has been added to the -mm tree.  Its filename is
     add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -149,9 +150,6 @@ void arch_crash_save_vmcoreinfo(void)
 
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

add-vmcoreinfo.patch
add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
